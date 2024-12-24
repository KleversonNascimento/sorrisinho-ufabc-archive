package com.sorrisinho.sorrisinhoapi.business.bot;

import com.pengrad.telegrambot.TelegramBot;
import com.pengrad.telegrambot.model.Update;
import com.pengrad.telegrambot.model.request.ChatAction;
import com.pengrad.telegrambot.request.GetUpdates;
import com.pengrad.telegrambot.request.SendChatAction;
import com.pengrad.telegrambot.request.SendMessage;
import com.pengrad.telegrambot.response.GetUpdatesResponse;
import com.sorrisinho.sorrisinhoapi.business.discipline.DisciplineService;
import com.sorrisinho.sorrisinhoapi.business.enrollment.Enrollment;
import com.sorrisinho.sorrisinhoapi.business.enrollment.EnrollmentRepository;
import com.sorrisinho.sorrisinhoapi.business.message.Message;
import com.sorrisinho.sorrisinhoapi.business.message.MessageRepository;
import com.sorrisinho.sorrisinhoapi.business.message.MessageService;
import com.sorrisinho.sorrisinhoapi.business.student.Student;
import com.sorrisinho.sorrisinhoapi.business.student.StudentRepository;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Service;

import javax.transaction.Transactional;
import java.sql.SQLException;
import java.util.List;
import java.util.Optional;

@Component
@Service
@Slf4j
public class General {
    @Autowired
    private EnrollmentRepository enrollmentRepository;

    @Autowired
    private StudentRepository studentRepository;

    @Autowired
    private MessageRepository messageRepository;

    @Autowired
    private MessageService messageService;

    @Autowired
    private Sender sender;

    @Autowired
    private DisciplineService disciplineService;

    @Scheduled(fixedRate = 1000)
    @Transactional
    public void bot() throws InterruptedException {
        TelegramBot bot = new TelegramBot("insert id here");

        Optional<Message> lastProcessedMessage = messageRepository.findFirstByTypeOrderByUpdatedIdDesc("Received");

        Long offset = 0L;

        if (lastProcessedMessage.isPresent()) {
            offset = lastProcessedMessage.get().getUpdatedId() + 1L;
        }

        log.info("offset=" + offset.intValue());

        GetUpdates getUpdates = new GetUpdates().limit(10).offset(offset.intValue()).timeout(500);
        getUpdates.allowedUpdates("message");
        GetUpdatesResponse updatesResponse = bot.execute(getUpdates);
        log.info("Desc" + updatesResponse.description());
        log.info("Error" + updatesResponse.errorCode());
        log.info("isOk" + updatesResponse.isOk());
        List<Update> updates = updatesResponse.updates();

        Long finalOffset = offset;
        if (updates != null) {
            updates.forEach(update -> {
                try {
                    processMessage(update, bot);
                } catch (Exception ex) {
                    log.info(ex.toString());
                    try {
                        messageService.saveReceivedMessage(finalOffset + 1, "Erro", null, 0L);
                    } catch (SQLException e) {
                        e.printStackTrace();
                    }
                }
            });
        }
    }

    private void processMessage(Update update, TelegramBot bot) throws SQLException {
        if (update.message() != null && update.message().chat() != null && update.message().chat().id() != null) {
            Long chatId = update.message().chat().id();
            try {
            Optional<Student> student = studentRepository.findOneByChatId(String.valueOf(chatId));
            if (student.isPresent() && (student.get().getNeedsFillSigaaString() == null || student.get().getNeedsFillSigaaString() == false)) {
                String receivedMessage = update.message().text();

                messageService.saveReceivedMessage(Long.valueOf(update.updateId()), receivedMessage, student.get(), chatId);

                generalCommands(receivedMessage, chatId, student.get(), bot);
            } else {
                newStudent(chatId, update, bot);
            }
            } catch (Exception ex) {
                messageService.saveReceivedMessage(Long.valueOf(update.updateId()), "Erro", null, chatId);
            }
        }
    }

    private void generalCommands(String message, Long chatId, Student student, TelegramBot bot) throws SQLException {
        switch (message) {
            case "/command6":
                deleteRA(chatId, student, bot);
                break;
            case "/command2":
                aulasSemana(chatId, student, bot);
                break;
            case "/command1":
                aulasDeHoje(chatId, student, bot);
                break;
            case "/command3":
                gradeCompleta(chatId, student, bot);
                break;
            case "/command4":
                horariosFretados(chatId, student, bot);
                break;
            case "/command5":
                contato(chatId, student, bot);
                break;
            default:
                String notFoundMessage = "Não entendi o que você quis dizer.\nVeja os comandos disponíveis no menu do lado esquerdo do teclado\n\n⬇️";
                sender.sendMessage(chatId, bot, notFoundMessage, null, student);
        }
    }

    private void horariosFretados(Long chatId, Student student, TelegramBot bot) throws SQLException {
        sender.sendMessage(chatId, bot, "Os horários dos fretados estão disponíveis em: \nhttps://pu.ufabc.edu.br/horarios-dos-onibus", null, student);
    }

    private void contato(Long chatId, Student student, TelegramBot bot) throws SQLException {
        sender.sendMessage(chatId, bot, "Você pode tirar dúvidas, fazer reclamações/críticas/elogios em: \nhttps://t.me/sorrisinhoufabcsuporte", null, student);
    }

    private void aulasDeHoje(Long chatId, Student student, TelegramBot bot) throws SQLException {
        bot.execute(new SendChatAction(chatId, ChatAction.typing));
        sender.sendMessage(chatId, bot, disciplineService.aulasDeHoje(Long.valueOf(student.getRa())), null, student);
    }

    private void aulasSemana(Long chatId, Student student, TelegramBot bot) throws SQLException {
        bot.execute(new SendChatAction(chatId, ChatAction.typing));
        sender.sendMessage(chatId, bot, disciplineService.aulasDaSemana(Long.valueOf(student.getRa())), null, student);
    }

    private void gradeCompleta(Long chatId, Student student, TelegramBot bot) throws SQLException {
        bot.execute(new SendChatAction(chatId, ChatAction.typing));
        sender.sendMessage(chatId, bot, disciplineService.buildCompleteGrade(Long.valueOf(student.getRa())), null, student);
    }

    private void deleteRA(Long chatId, Student student, TelegramBot bot) throws SQLException {
        enrollmentRepository.deleteAllByRaAndMadeByUser(student.getRa(), true);
        student.setRa("0");
        student.setChatId("0");
        studentRepository.save(student);
        String successMessage = "RA deletado.\n\nQuando quiser se cadastrar novamente, basta <b>digitar o RA</b> ️";
        sender.sendMessage(chatId, bot, successMessage, "/insert-ra", student);
    }

    private void newStudent(Long chatId, Update update, TelegramBot bot) throws SQLException {
        String receivedMessage = update.message().text();

        messageService.saveReceivedMessage(Long.valueOf(update.updateId()), receivedMessage, null, chatId);

        String tree = getTree(chatId);

        if (tree != null && tree.equals("/insert-sigaa-text")) {
            bot.execute(new SendChatAction(chatId, ChatAction.typing));
            Optional<Student> student = studentRepository.findOneByChatId(String.valueOf(chatId));

            if (!student.isPresent()) {
                String responseMessage = "Não conseguimos encontrar suas aulas\nMande uma mensagem em https://t.me/sorrisinhoufabcsuporte para resolvermos seu problema";
                sender.sendMessage(chatId, bot, responseMessage, "/insert-sigaa-text", null);
            } else {
                try {
                    final Student studentVerified = student.get();
                    disciplineService.makeEnrollmentsBySigaaString(receivedMessage, studentVerified.getRa());
                    studentVerified.setNeedsFillSigaaString(false);
                    studentRepository.save(studentVerified);
                    sender.sendMessage(chatId, bot, disciplineService.buildCompleteGrade(Long.valueOf(studentVerified.getRa())), "/insert-ra", studentVerified);
                } catch (Exception ex) {
                    String responseMessage = "Não conseguimos encontrar suas aulas\nMande uma mensagem em https://t.me/sorrisinhoufabcsuporte para resolvermos seu problema";
                    sender.sendMessage(chatId, bot, responseMessage, "/insert-sigaa-text", null);
                }
            }
        } else {
            if (tree != null && tree.equals("/insert-ra")) {
                try {
                    bot.execute(new SendChatAction(chatId, ChatAction.typing));
                    Long ra = Long.valueOf(receivedMessage);

                    Student newStudent = new Student();
                    newStudent.setRa(String.valueOf(ra));
                    newStudent.setChatId(String.valueOf(chatId));

                    List<Enrollment> enrollments = enrollmentRepository.findByRa(String.valueOf(ra));

                    if (enrollments.isEmpty() && String.valueOf(ra).contains("2023")) {
                        newStudent.setNeedsFillSigaaString(true);
                        Student savedStudent = studentRepository.save(newStudent);
                        String responseMessage = "Oi, bixo/bixete \nInfelizmente a matrícula de vocês é feita de forma diferente dos veteranos e por isso você precisa executar mais um passo:\nAcesse https://sig.ufabc.edu.br/sigaa/mobile/touch/menu.jsf, faça o login, escolha a opção Atestado de matrícula, <b>copie todo o conteúdo da primeira tabela abaixo da quantidade de turmas matriculadas e me envie aqui:</b>";
                        sender.sendMessage(chatId, bot, responseMessage, "/insert-sigaa-text", savedStudent);
                    } else {
                        Student savedStudent = studentRepository.save(newStudent);

                        sender.sendMessage(chatId, bot, disciplineService.buildCompleteGrade(ra), "/insert-ra", savedStudent);
                    }
                } catch (Exception ex) {
                    String responseMessage = "Não conseguimos encontrar seu RA. \n<b>Digite seu RA apenas com números:</b>";
                    sender.sendMessage(chatId, bot, responseMessage, "/insert-ra", null);
                }
            } else {
                insertRAMessage(chatId, bot);
            }
        }
    }


    private void insertRAMessage(Long chatId, TelegramBot bot) throws SQLException {
        String responseMessage = "Oi! Sou um bot feito para ajudar alunos da UFABC. \nPosso te ajudar a ver sua grade do Q3.2023, para isso só preciso que você <b>digite seu RA:</b>";

        sender.sendMessage(chatId, bot, responseMessage, "/insert-ra", null);
    }



    private String getTree(Long chatId) {
        Optional<Message> lastMessage = messageRepository.findFirstByChatIdAndTypeOrderByCreatedAtDesc(chatId, "Send");


        if (lastMessage.isPresent()) {
            return lastMessage.get().getTree();
        }

        return null;
    }
}
