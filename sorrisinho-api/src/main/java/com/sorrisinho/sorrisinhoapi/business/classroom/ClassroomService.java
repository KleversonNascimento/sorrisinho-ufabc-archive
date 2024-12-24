package com.sorrisinho.sorrisinhoapi.business.classroom;

import com.sorrisinho.sorrisinhoapi.business.discipline.Discipline;
import com.sorrisinho.sorrisinhoapi.business.discipline.DisciplineRepository;
import com.sorrisinho.sorrisinhoapi.business.discipline.DisciplineScheduleDTO;
import com.sorrisinho.sorrisinhoapi.business.enrollment.Enrollment;
import com.sorrisinho.sorrisinhoapi.business.enrollment.EnrollmentRepository;
import com.sorrisinho.sorrisinhoapi.business.promos.NoisResolveDTO;
import com.sorrisinho.sorrisinhoapi.business.promos.NoisResolveEntry;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.Random;
import java.util.function.Function;
import java.util.stream.Collectors;

@Service
@Slf4j
public class ClassroomService {
    @Autowired
    private ClassroomRepository classroomRepository;

    @Autowired
    private EnrollmentRepository enrollmentRepository;

    @Autowired
    private DisciplineRepository disciplineRepository;

    private final List<NoisResolveEntry> noisResolveDisciplines = List.of(
            new NoisResolveEntry("FUNÇÕES DE VÁRIAS VARIÁVEIS", "FVV", "https://wa.me/5511962029415?text=Ol%C3%A1!!%20Estou%20precisando%20de%20ajuda%20em%20FVV"),
            new NoisResolveEntry("BASES COMPUTACIONAIS DA CIÊNCIA", "BCC", "https://wa.me/5511962029415?text=Ol%C3%A1!!%20Estou%20precisando%20de%20ajuda%20em%20BCC"),
            new NoisResolveEntry("BASES MATEMÁTICAS", "BM", "https://wa.me/5511962029415?text=Ol%C3%A1!!%20Estou%20precisando%20de%20ajuda%20em%20BM"),
            new NoisResolveEntry("FENÔMENOS ELETROMAGNÉTICOS", "ELETROMAG", "https://wa.me/5511962029415?text=Ol%C3%A1!!%20Estou%20precisando%20de%20ajuda%20em%20Fenomenos%20Eletromagneticos"),
            new NoisResolveEntry("INTRODUÇÃO À PROBABILIDADE E À ESTATÍSTICA", "IPE", "https://wa.me/5511962029415?text=Ol%C3%A1!!%20Estou%20precisando%20de%20ajuda%20em%20IPE"),
            new NoisResolveEntry("FENÔMENOS TÉRMICOS", "FETERM", "https://wa.me/5511962029415?text=Ol%C3%A1!!%20Estou%20precisando%20de%20ajuda%20em%20FETERM"),
            new NoisResolveEntry("INTRODUÇÃO ÀS EQUAÇÕES DIFERENCIAIS ORDINÁRIAS", "IEDO", "https://wa.me/5511962029415?text=Ol%C3%A1!!%20Estou%20precisando%20de%20ajuda%20em%20IEDO"),
            new NoisResolveEntry("INTERAÇÕES ATÔMICAS E MOLECULARES", "IAM", "https://wa.me/5511962029415?text=Ol%C3%A1!!%20Estou%20precisando%20de%20ajuda%20em%20IAM"),
            new NoisResolveEntry("CÁLCULO NUMÉRICO", "cálculo numérico", "https://wa.me/5511962029415?text=Ol%C3%A1!!%20Estou%20precisando%20de%20ajuda%20em%20Calculo%20Numerico"),
            new NoisResolveEntry("ÁLGEBRA LINEAR", "ALGELIN", "https://wa.me/5511962029415?text=Ol%C3%A1!!%20Estou%20precisando%20de%20ajuda%20em%20Algebra%20Linear"),
            new NoisResolveEntry("PROCESSAMENTO DA INFORMAÇÃO", "PI", "https://wa.me/5511962029415?text=Ol%C3%A1!!%20Estou%20precisando%20de%20ajuda%20em%20Processamento%20da%20Informacao")
            );

    public List<Classroom> getAllClassroomsByRa(String ra) {
        List<Enrollment> enrollments = enrollmentRepository.findByRaAndQuarterNumberAndQuarterYear(ra, 3, 2024);
        List<Discipline> disciplines = enrollments.stream().map(Enrollment::getDiscipline).collect(Collectors.toList());
        List<Classroom>  allClassrooms = new ArrayList<>();

        disciplines.forEach(discipline -> {
            allClassrooms.addAll(classroomRepository.findAllByDiscipline(discipline));
        });


        return allClassrooms;
    }

    public List<Classroom> getAllClassroomsByRaWithExtras(String ra, List<Integer> additionalDisciplines) {
        List<Enrollment> enrollments = enrollmentRepository.findByRaAndQuarterNumberAndQuarterYear(ra, 3, 2024);
        List<Discipline> disciplines = enrollments.stream().map(Enrollment::getDiscipline).collect(Collectors.toList());

        if (additionalDisciplines != null && !additionalDisciplines.isEmpty()) {
            List<Discipline> extrasDisciplines = disciplineRepository
                    .findAllById(
                            additionalDisciplines.stream().map(Integer::longValue).collect(Collectors.toList()))
                    .stream().filter(discipline -> discipline.getQuarterNumber() == 3 && discipline.getQuarterYear() == 2024)
                    .collect(Collectors.toList());
            disciplines.addAll(extrasDisciplines);
        }

        List<Classroom>  allClassrooms = new ArrayList<>();

        disciplines.forEach(discipline -> {
            allClassrooms.addAll(classroomRepository.findAllByDiscipline(discipline));
        });


        return allClassrooms;
    }

    public NoisResolveDTO findBanner(String ra, List<Integer> additionalDisciplines) {
        List<Enrollment> enrollments = enrollmentRepository.findByRaAndQuarterNumberAndQuarterYear(ra, 3, 2024);
        List<Discipline> disciplines = enrollments.stream().map(Enrollment::getDiscipline).collect(Collectors.toList());

        if (additionalDisciplines != null && !additionalDisciplines.isEmpty()) {
            List<Discipline> extrasDisciplines = disciplineRepository
                    .findAllById(
                            additionalDisciplines.stream().map(Integer::longValue).collect(Collectors.toList()))
                    .stream().filter(discipline -> discipline.getQuarterNumber() == 3 && discipline.getQuarterYear() == 2024)
                    .collect(Collectors.toList());
            disciplines.addAll(extrasDisciplines);
        }

        
        final List<String> noisResolveDisciplineNames = noisResolveDisciplines.stream().map(NoisResolveEntry::getDisciplineName).collect(Collectors.toList());

        final List<Discipline> availableDisciplines =  disciplines.stream().filter(discipline -> noisResolveDisciplineNames.contains(discipline.getName())).collect(Collectors.toList());

        if (availableDisciplines.isEmpty()) {
            return new NoisResolveDTO();
        }

        final Discipline selectedDiscipline = availableDisciplines.get(new Random().nextInt(availableDisciplines.size()));
        final NoisResolveEntry selectedEntry = noisResolveDisciplines.stream().filter(entry -> entry.getDisciplineName().contains(selectedDiscipline.getName())).findFirst().get();

        if (selectedEntry.getDisciplineAcronym().equals("IAM")) {
            return new NoisResolveDTO("Preocupado com a reta final de IAM?\n"
                + "A Nois Resolve está aqui para ajudar!\n"
                + "✅ Lista resolvida com mais de 20 questões para a P2\n"
                + "✅ Lista resolvida com 20+ questões para a P1/Rec", selectedEntry.getLink());
        }

        List<Function<String, String>> availableCopys = List.of(copy1, copy2, copy3);
        final String text = availableCopys.get(new Random().nextInt(availableCopys.size())).apply(selectedEntry.getDisciplineAcronym());

        return new NoisResolveDTO(text, selectedEntry.getLink());
    }

    Function<String, String> copy1 = (String acronym) -> {
        return "Preocupado/a com a p2 de " + acronym + "? A Nois Resolve te ajuda!";
    };

    Function<String, String> copy2 = (String acronym) ->  {
        return "Ainda dá tempo de passar em " + acronym + "! A Nois Resolve está aqui para te ajudar!";
    };

    Function<String, String> copy3 = (String acronym) ->  {
        return "Preocupado com a reta final de " + acronym + "? A Nois Resolve te ajuda!";
    };
}
