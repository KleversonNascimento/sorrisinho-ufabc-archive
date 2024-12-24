package com.sorrisinho.sorrisinhoapi.business.discipline;

import com.sorrisinho.sorrisinhoapi.business.classroom.Classroom;
import com.sorrisinho.sorrisinhoapi.business.classroom.ClassroomRepository;
import com.sorrisinho.sorrisinhoapi.business.enrollment.Enrollment;
import com.sorrisinho.sorrisinhoapi.business.enrollment.EnrollmentRepository;
import lombok.extern.slf4j.Slf4j;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.ClassPathResource;
import org.springframework.stereotype.Service;

import javax.transaction.Transactional;
import java.io.FileReader;
import java.io.IOException;
import java.util.*;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.stream.Collectors;

@Service
@Slf4j
public class DisciplineService {
    @Autowired
    private DisciplineRepository disciplineRepository;

    @Autowired
    private ClassroomRepository classroomRepository;

    @Autowired
    private EnrollmentRepository enrollmentRepository;

    @Transactional
    public DisciplineDTO save(final DisciplineDTO disciplineDTO) {
        final Discipline savedDiscipline = this.disciplineRepository.save(disciplineDTO.toDiscipline());
        return new DisciplineDTO(savedDiscipline);
    }

    public List<Discipline> all() {
        return disciplineRepository.findByQuarterNumberAndQuarterYear(3, 2024);
    }

    @Transactional
    public void loadEnrollments() throws IOException, ParseException {
        JSONParser parser = new JSONParser();
        Object obj = parser.parse(new FileReader(new ClassPathResource("matriculas_3_2024.json").getFile()));

        JSONArray allEnrollments = (JSONArray) obj;

        System.out.println("Total: " + allEnrollments.size());

        for (int i = 0; i < allEnrollments.size(); i++) {
            JSONObject enrollment = (JSONObject) allEnrollments.get(i);
            Optional<Discipline> foundDiscipline = disciplineRepository.findOneByCodeAndQuarterNumberAndQuarterYear(String.valueOf(enrollment.get("Código turma")), 3, 2024);

            if (foundDiscipline.isPresent()) {

                if (String.valueOf(enrollment.get("RA")).length() > 4 && !enrollmentRepository.findOneByRaAndDiscipline(String.valueOf(enrollment.get("RA")), foundDiscipline.get()).isPresent()) {
                    log.info(String.valueOf(i));

                    log.info("Não criada");

                    enrollmentRepository.save(createEnrollment(foundDiscipline.get(), String.valueOf(enrollment.get("RA"))));
                } else {
                    log.info("Já criada");
                }
            } else {
                System.out.println("Erro: Disciplina não encontada: " + String.valueOf(enrollment.get("Nome Disciplina")));
            }
        }
    }

    @Transactional
    public void loadNewHiresEnrollments() throws IOException, ParseException {
        JSONParser parser = new JSONParser();
        Object obj = parser.parse(new FileReader(new ClassPathResource("enrollments_new_hires.json").getFile()));

        JSONArray allEnrollments = (JSONArray) obj;

        System.out.println("Total: " + allEnrollments.size());

        enrollmentRepository.deleteAllByMadeByUser(true);

        for (int i = 0; i < allEnrollments.size(); i++) {
            JSONObject enrollment = (JSONObject) allEnrollments.get(i);
            Optional<Discipline> foundDiscipline = disciplineRepository.findOneByCodeAndQuarterNumberAndQuarterYear(String.valueOf(enrollment.get("CODIGO TURMA")), 3, 2024);

            if (foundDiscipline.isPresent()) {

                if (String.valueOf(enrollment.get("RA")).length() > 4 && !enrollmentRepository.findOneByRaAndDiscipline(String.valueOf(enrollment.get("RA")), foundDiscipline.get()).isPresent()) {
                    log.info(String.valueOf(i));

                    log.info("Não criada");

                    enrollmentRepository.save(createEnrollment(foundDiscipline.get(), String.valueOf(enrollment.get("RA"))));
                } else {
                    log.info("Já criada");
                }
            } else {
                System.out.println("Erro: Disciplina não encontrada: " + String.valueOf(enrollment.get("TURMA")));
            }
        }
    }

    @Transactional
    public void loadDisciplines() throws IOException, ParseException {
        JSONParser parser = new JSONParser();
        Object obj = parser.parse(new FileReader(new ClassPathResource("turmas_salas_2024_3.json").getFile()));

        JSONArray allDisciplines = (JSONArray) obj;

        System.out.println("Total: " + allDisciplines.size());

        for (int i = 0; i < allDisciplines.size(); i++) {
            final Discipline createdDiscipline = buildDiscipline((JSONObject) allDisciplines.get(i));
            log.info(createdDiscipline.getCode());
            if (!createdDiscipline.getCode().contains("CÓDIGO DE TURMA") && !disciplineRepository.findOneByCodeAndQuarterNumberAndQuarterYear(createdDiscipline.getCode(), 3, 2024).isPresent()) {
                final Discipline savedDiscipline = disciplineRepository.save(createdDiscipline);

                final List<Classroom> classrooms = buildClassRooms((JSONObject) allDisciplines.get(i));

                classrooms.forEach(classroom -> {
                    classroom.setDiscipline(savedDiscipline);
                    classroomRepository.save(classroom);
                });

                log.info(String.valueOf(i));
            }
        }
    }

    @Transactional
    public void updateDisciplines() throws IOException, ParseException {
        JSONParser parser = new JSONParser();
        Object obj = parser.parse(new FileReader(new ClassPathResource("salas_100_atualizado.json").getFile()));

        JSONArray allDisciplines = (JSONArray) obj;

        System.out.println("Total: " + allDisciplines.size());

        for (int i = 0; i < allDisciplines.size(); i++) {
            final Discipline createdDiscipline = buildDiscipline((JSONObject) allDisciplines.get(i));
            log.info(createdDiscipline.getCode());
            final Optional<Discipline> existentDiscipline = disciplineRepository.findOneByCodeAndQuarterNumberAndQuarterYear(createdDiscipline.getCode(), 3, 2024);
            if (!createdDiscipline.getCode().contains("CÓDIGO DE TURMA") && !existentDiscipline.isPresent()) {
                final Discipline savedDiscipline = disciplineRepository.save(createdDiscipline);

                final List<Classroom> classrooms = buildClassRooms((JSONObject) allDisciplines.get(i));

                classrooms.forEach(classroom -> {
                    classroom.setDiscipline(savedDiscipline);
                    classroomRepository.save(classroom);
                });

                log.info("Created: " + String.valueOf(i));
            } else {
                if (!createdDiscipline.getCode().contains("CÓDIGO DE TURMA")) {
                    final Discipline disciplineToUpdate = existentDiscipline.get();

                    disciplineToUpdate.updateFromAnotherDiscipline(createdDiscipline);
                    disciplineRepository.save(disciplineToUpdate);

                    classroomRepository.deleteAllByDiscipline(disciplineToUpdate);

                    final List<Classroom> classrooms = buildClassRooms((JSONObject) allDisciplines.get(i));

                    classrooms.forEach(classroom -> {
                        classroom.setDiscipline(disciplineToUpdate);
                        classroomRepository.save(classroom);
                    });

                    log.info("Updated: " + String.valueOf(i));
                }
            }
        }
    }

    private Discipline buildDiscipline(JSONObject discipline) {
        Discipline newDiscipline = new Discipline();
        newDiscipline.setCode(String.valueOf(discipline.get("CÓDIGO DE TURMA")));
        newDiscipline.setPeriod(getPeriod(discipline));
        newDiscipline.setType("In-person");
        newDiscipline.setCampus(getCampus(discipline));
        newDiscipline.setName(getName(discipline));
        newDiscipline.setClassCode(getClassCode(discipline));
        newDiscipline.setQuarterYear(2024);
        newDiscipline.setQuarterNumber(3);
        newDiscipline.setCourse(capitalizeAll(String.valueOf(discipline.get("CURSO")).toLowerCase()));
        newDiscipline.setTpi("");

        return newDiscipline;
    }

    private String getPeriod(JSONObject discipline) {
        if (String.valueOf(discipline.get("TURMA")).contains("Noturno")) {
            return "Noturno";
        }

        return "Diurno";
    }

    private String getCampus(JSONObject discipline) {
        if (String.valueOf(discipline.get("TURMA")).contains("(SA)")) {
            return "Santo André";
        }

        return "São Bernardo";
    }

    private String getNameWithClassCode(String rawValue) {
        if(rawValue.equals("TURMA")) {
            return "";
        }

        return rawValue.substring(0, rawValue.lastIndexOf('-'));
    }

    private String getName(JSONObject discipline) {
        String first = getNameWithClassCode(String.valueOf(discipline.get("TURMA")));
        String[] second = first.split(" ");
        String third = second[0];
        for (int i = 1; i < second.length - 1; i++) {
            third = third.concat(" ").concat(second[i]);
        }
        return third;
    }

    private String getClassCode(JSONObject discipline) {
        String first = getNameWithClassCode(String.valueOf(discipline.get("TURMA")));
        String[] second = first.split(" ");

        return second[second.length - 1];
    }

    private List<Classroom> buildClassRooms(JSONObject discipline) {
        List<Classroom> classrooms = new ArrayList<>();

        String[] teoria = String.valueOf(discipline.get("TEORIA")).split(",");

        if (teoria.length >= 3) {
            for (int i = 0; i < teoria.length; i = i + 3) {
                classrooms.add(buildClassRoom(teoria[i], teoria[i + 1], teoria[i + 2], "Teoria", String.valueOf(discipline.get("DOCENTE TEORIA")), String.valueOf(discipline.get("DOCENTE TEORIA 2"))));
            }
        }

        String[] pratica = String.valueOf(discipline.get("PRÁTICA")).split(",");

        if (pratica.length >= 3) {
            for (int i = 0; i < pratica.length; i = i + 3) {
                classrooms.add(buildClassRoom(pratica[i], pratica[i + 1], pratica[i + 2], "Prática", String.valueOf(discipline.get("DOCENTE PRÁTICA")), String.valueOf(discipline.get("DOCENTE PRÁTICA 2"))));
            }
        }

        return classrooms;
    }

    private Classroom buildClassRoom(String first, String second, String third, String type, String teacher, String secondaryTeacher) {
        Classroom newClassRoom = new Classroom();
        newClassRoom.setType(type);
        newClassRoom.setTeacher(capitalizeAll(teacher.toLowerCase()));
        newClassRoom.setSecondaryTeacher(capitalizeAll(secondaryTeacher.toLowerCase()));
        newClassRoom.setDay(getClassDay(first));
        newClassRoom.setWeekdayNumber(getClassDayNumber(first));
        newClassRoom.setFrequency(getFrequency(third));
        newClassRoom.setStart(getStart(first));
        newClassRoom.setEnd(getEnd(first));
        newClassRoom.setRoom(getRoom(second));

        return newClassRoom;
    }

    private String getClassDay(String rawValue) {
        if (rawValue.toLowerCase().contains("segunda")) {
            return "Segunda-feira";
        }

        if (rawValue.toLowerCase().contains("terça")) {
            return "Terça-feira";
        }

        if (rawValue.toLowerCase().contains("quarta")) {
            return "Quarta-feira";
        }

        if (rawValue.toLowerCase().contains("quinta")) {
            return "Quinta-feira";
        }

        if (rawValue.toLowerCase().contains("sexta")) {
            return "Sexta-feira";
        }

        if (rawValue.toLowerCase().contains("sábado")) {
            return "Sábado";
        }

        return null;
    }

    private Integer getClassDayNumber(String rawValue) {
        if (rawValue.toLowerCase().contains("segunda")) {
            return 1;
        }

        if (rawValue.toLowerCase().contains("terça")) {
            return 2;
        }

        if (rawValue.toLowerCase().contains("quarta")) {
            return 3;
        }

        if (rawValue.toLowerCase().contains("quinta")) {
            return 4;
        }

        if (rawValue.toLowerCase().contains("sexta")) {
            return 5;
        }

        if (rawValue.toLowerCase().contains("sábado")) {
            return 6;
        }

        return null;
    }

    private String getFrequency(String rawValue) {
        if (rawValue.contains("semanal")) {
            return "Semanal";
        }

        if (rawValue.contains("II")) {
            return "Quinzenal II";
        }

        if (rawValue.contains("I")) {
            return "Quinzenal I";
        }

        return null;
    }

    private Integer getStart(String rawValue) {
        String[] first = rawValue.split("das");
        String second = Arrays.stream(first[first.length - 1].replace(" ", "").split(":")).findFirst().get();
        return Integer.valueOf(second);
    }

    private Integer getEnd(String rawValue) {
        String[] first = rawValue.split("às");
        String second = Arrays.stream(first[first.length - 1].replace(" ", "").split(":")).findFirst().get();
        return Integer.valueOf(second);
    }

    private String getRoom(String rawValue) {
        String first = rawValue.replace("sala de aula", "").replace("sala", "").replace("laboratório", "").replace("lab", "").replace(" ", "").replace("e", " e ");
        return first;
    }

    public static String capitalizeAll(String str) {
        if (str == null || str.isEmpty()) {
            return str;
        }

        return Arrays.stream(str.split("\\s+"))
                .map(t -> t.substring(0, 1).toUpperCase() + t.substring(1))
                .collect(Collectors.joining(" "));
    }

    private Enrollment createEnrollment(Discipline discipline, String ra) {
        Enrollment newEnrollment = new Enrollment();
        newEnrollment.setDiscipline(discipline);
        newEnrollment.setRa(ra);
        newEnrollment.setQuarterNumber(3);
        newEnrollment.setQuarterYear(2024);

        return newEnrollment;
    }

    public String aulasDaSemana(Long ra) {
        List<Enrollment> enrollments = enrollmentRepository.findByRaAndQuarterNumberAndQuarterYear(String.valueOf(ra), 3, 2024);

        if (isBeforeQuarterStart()) {
            return "Felizmente estamos de férias, então sem aulas nesta semana ;)";
        }

        if (enrollments.isEmpty()) {
            return "Não encontramos nenhuma aula para o seu RA :(";
        }

        String finalMessage = "<b>Suas aulas da semana</b>\n";

        Calendar calendar = Calendar.getInstance(TimeZone.getTimeZone("America/Sao_Paulo"));

        String quinzenal = calendar.get(Calendar.WEEK_OF_YEAR) % 2 == 0  ? "Quinzenal I" : "Quinzenal II";

        finalMessage = finalMessage.concat("Essa semana é " + quinzenal + "\n\n");

        List<Discipline> disciplines = new ArrayList<>();
        enrollments.forEach(enrollment -> disciplines.add(enrollment.getDiscipline()));

        finalMessage = finalMessage.concat(buildQuinzenal(quinzenal, disciplines));

        finalMessage = finalMessage.concat(theNewsPubli());

        return finalMessage;
    }

    public String aulasDeHoje(Long ra) {
        List<Enrollment> enrollments = enrollmentRepository.findByRaAndQuarterNumberAndQuarterYear(String.valueOf(ra), 3, 2024);

        if (isBeforeQuarterStart()) {
            return "Felizmente estamos de férias, então sem aulas hoje ;)";
        }

        if (enrollments.isEmpty()) {
            return "Não encontramos nenhuma aula para o seu RA :(";
        }

        String finalMessage = "<b>Suas aulas de hoje</b>\n";

        Calendar calendar = Calendar.getInstance(TimeZone.getTimeZone("America/Sao_Paulo"));

        String quinzenal = calendar.get(Calendar.WEEK_OF_YEAR) % 2 == 0  ? "Quinzenal I" : "Quinzenal II";

        finalMessage = finalMessage.concat("Estamos em uma semana " + quinzenal + "\n\n");

        List<Discipline> disciplines = new ArrayList<>();
        enrollments.forEach(enrollment -> disciplines.add(enrollment.getDiscipline()));

        finalMessage = finalMessage.concat(addDayToGradeMessage(getDayOfWeek(calendar.get(Calendar.DAY_OF_WEEK)), quinzenal, disciplines));

        if (finalMessage.length() == 0) {
            finalMessage = finalMessage.concat("Você não tem nenhuma aula hoje");
        }

        finalMessage = finalMessage.concat(theNewsPubli());

        return finalMessage;
    }

    public boolean isBeforeQuarterStart() {
        Calendar calendar = Calendar.getInstance(TimeZone.getTimeZone("America/Sao_Paulo"));

        Calendar quadStartDate = Calendar.getInstance();

        quadStartDate.set(Calendar.MONTH, 1);
        quadStartDate.set(Calendar.DATE, 3);
        quadStartDate.set(Calendar.YEAR, 2024);

        if (calendar.before(quadStartDate)) {
            return true;
        }

        return false;
    }

    private String getDayOfWeek(int day) {
        if (day == 2) {
            return "Segunda-feira";
        }

        if (day == 3) {
            return "Terça-feira";
        }

        if (day == 4) {
            return "Quarta-feira";
        }

        if (day == 5) {
            return "Quinta-feira";
        }

        if (day == 6) {
            return "Sexta-feira";
        }

        if (day == 7) {
            return "Sábado";
        }

        return "Domingo";
    }

    public String buildCompleteGrade(Long ra) {
        List<Enrollment> enrollments = enrollmentRepository.findByRaAndQuarterNumberAndQuarterYear(String.valueOf(ra), 3, 2024);

        if (enrollments.isEmpty()) {
            return "Não encontramos nenhuma aula para o seu RA :(";
        }


        String finalMessage = "<b>Grade do RA " + ra + " para o Q3.2024</b> \n\n";

        List<Discipline> disciplines = new ArrayList<>();
        enrollments.forEach(enrollment -> disciplines.add(enrollment.getDiscipline()));

        finalMessage = finalMessage.concat("<b>Quinzenal I:</b>\n\n");
        finalMessage = finalMessage.concat(buildQuinzenal("Quinzenal I", disciplines));

        finalMessage = finalMessage.concat("\n<b>Quinzenal II:</b>\n\n");
        finalMessage = finalMessage.concat(buildQuinzenal("Quinzenal II", disciplines));

        //finalMessage = finalMessage.concat(theNewsPubli());

        return finalMessage;
    }

    public String buildQuinzenal(String quinzenal, List<Discipline> disciplines) {
        String finalMessage = "";
        finalMessage = finalMessage.concat(addDayToGradeMessage("Segunda-feira", quinzenal, disciplines));
        finalMessage = finalMessage.concat(addDayToGradeMessage("Terça-feira", quinzenal, disciplines));
        finalMessage = finalMessage.concat(addDayToGradeMessage("Quarta-feira", quinzenal, disciplines));
        finalMessage = finalMessage.concat(addDayToGradeMessage("Quinta-feira", quinzenal, disciplines));
        finalMessage = finalMessage.concat(addDayToGradeMessage("Sexta-feira", quinzenal, disciplines));
        finalMessage = finalMessage.concat(addDayToGradeMessage("Sábado", quinzenal, disciplines));

        return finalMessage;
    }

    public String addDayToGradeMessage(String day, String frequency, List<Discipline> disciplines) {
        List<Classroom> allClassrooms = new ArrayList<>();

        disciplines.forEach(discipline -> {
            allClassrooms.addAll(classroomRepository.achar(discipline.getId(), day, frequency));
        });

        if (allClassrooms.isEmpty()) {
            return "";
        }

        String finalMessage = "<b>" + day + "</b>\n\n";

        Collections.sort(allClassrooms);

        for (int i = 0; i < allClassrooms.size(); i++) {
            Classroom classroom = allClassrooms.get(i);
            finalMessage = finalMessage.concat(buildClassroom(classroom) + "\n");
        }

        return finalMessage;
    }

    private String buildClassroom(Classroom classroom) {
        String finalMessage = "";

        finalMessage = finalMessage.concat("<b>" + classroom.getStart() + ":00 às " + classroom.getEnd() + ":00 </b>\n");
        finalMessage = finalMessage.concat(classroom.getDiscipline().getName() + " - " + classroom.getDiscipline().getClassCode() + "\n");
        finalMessage = finalMessage.concat(classroom.getRoom() + " - " + classroom.getDiscipline().getCampus() + "\n");
        if (classroom.getSecondaryTeacher().length() > 2) {
            finalMessage = finalMessage.concat(classroom.getTeacher() + " e " + classroom.getSecondaryTeacher() + "\n");
        } else {
            finalMessage = finalMessage.concat(classroom.getTeacher() + "\n");
        }


        return  finalMessage;
    }

    @Transactional
    public void makeEnrollmentsBySigaaString(final String sigaaString, final String ra) {
        final String formattedSigaaString = sigaaString.replaceAll("\\r|\\n", "").replaceAll(" ", "");
        enrollmentRepository.deleteAllByRaAndMadeByUser(ra, true);
        firstPattern(formattedSigaaString, ra);
        secondPattern(formattedSigaaString, ra);
    }

    public void firstPattern(final String sigaaString, final String ra) {
        Pattern pattern = Pattern.compile("\\w{7}\\d{3}-\\d{2}\\w{2}");
        Matcher matcher = pattern.matcher(sigaaString);

        while(matcher.find()) {
            final String disciplineCode = matcher.group();

            final Optional<Discipline> discipline = disciplineRepository.findOneByCodeAndQuarterNumberAndQuarterYear(disciplineCode, 3, 2024);

            if (discipline.isPresent()) {
                final Optional<Enrollment> enrollment = enrollmentRepository.findOneByRaAndDiscipline(ra, discipline.get());

                if (!enrollment.isPresent()) {
                    Enrollment newEnrollment = new Enrollment();
                    newEnrollment.setDiscipline(discipline.get());
                    newEnrollment.setRa(ra);
                    newEnrollment.setMadeByUser(true);
                    newEnrollment.setQuarterNumber(3);
                    newEnrollment.setQuarterYear(2024);

                    enrollmentRepository.save(newEnrollment);
                }
            }
        }
    }

    public void secondPattern(final String sigaaString, final String ra) {
        Pattern pattern = Pattern.compile("\\w{7}\\d{3}\\d{2}\\w{2}");
        Matcher matcher = pattern.matcher(sigaaString);

        while(matcher.find()) {
            final String disciplineCode = matcher.group();

            final String formattedCode = disciplineCode.substring(0, 10) + "-" + disciplineCode.substring(10, 14);

            final Optional<Discipline> discipline = disciplineRepository.findOneByCodeAndQuarterNumberAndQuarterYear(formattedCode, 3, 2024);

            if (discipline.isPresent()) {
                final Optional<Enrollment> enrollment = enrollmentRepository.findOneByRaAndDiscipline(ra, discipline.get());

                if (!enrollment.isPresent()) {
                    Enrollment newEnrollment = new Enrollment();
                    newEnrollment.setDiscipline(discipline.get());
                    newEnrollment.setRa(ra);
                    newEnrollment.setMadeByUser(true);
                    newEnrollment.setQuarterNumber(3);
                    newEnrollment.setQuarterYear(2024);

                    enrollmentRepository.save(newEnrollment);
                }
            }
        }
    }

    @Transactional
    public void notifyDeleteRa(String ra) {
        enrollmentRepository.deleteAllByRaAndMadeByUser(ra, true);
    }

    private String theNewsPubli() {
        String finalMessage = "\n\nVocê sabia que se manter informado pode ser tão simples quanto ver suas aulas por aqui? E o melhor, também é <b>totalmente de graça</b>.\n\nCom a newsletter do the news ☕ você recebe diariamente as notícias mais importantes de forma resumida, tem newsletter de vários temas como esportes, negócios (tecnologia e startups) e também uma mais geral. Se cadastre agora no link:\nhttps://thenewscc.com.br/indicacao?grsf=mc6x3f";
        return finalMessage;
    }
}
