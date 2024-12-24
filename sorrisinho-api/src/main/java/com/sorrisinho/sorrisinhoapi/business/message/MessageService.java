package com.sorrisinho.sorrisinhoapi.business.message;

import com.sorrisinho.sorrisinhoapi.business.student.Student;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.sql.rowset.serial.SerialBlob;
import java.nio.charset.StandardCharsets;
import java.sql.SQLException;

@Service
@Slf4j
public class MessageService {
    @Autowired
    private MessageRepository messageRepository;

    public void saveReceivedMessage(Long updatedId, String text, Student student, Long chatId) throws SQLException {
        Message newReceivedMessage = new Message();

        newReceivedMessage.setType("Received");
        newReceivedMessage.setUpdatedId(updatedId);
        newReceivedMessage.setMessage(new SerialBlob(text.getBytes(StandardCharsets.UTF_8)));
        newReceivedMessage.setStudent(student);
        newReceivedMessage.setChatId(chatId);

        try {
            messageRepository.save(newReceivedMessage);
        } catch (Exception e) {
            log.info(e.toString());
        }
    }

    public void saveProcessedMessage(String message, Student student, Long chatId, String tree) throws SQLException {
        Message newProcessedMessage = new Message();

        newProcessedMessage.setType("Send");
        newProcessedMessage.setMessage(new SerialBlob(message.getBytes(StandardCharsets.UTF_8)));
        newProcessedMessage.setStudent(student);
        newProcessedMessage.setChatId(chatId);
        newProcessedMessage.setTree(tree);

        try {
            messageRepository.save(newProcessedMessage);
        } catch (Exception e) {
            log.info(e.toString());
        }
    }
}
