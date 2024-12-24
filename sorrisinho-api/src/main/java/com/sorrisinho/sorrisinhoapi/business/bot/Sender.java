package com.sorrisinho.sorrisinhoapi.business.bot;

import com.pengrad.telegrambot.TelegramBot;
import com.pengrad.telegrambot.model.request.ParseMode;
import com.pengrad.telegrambot.response.BaseResponse;
import com.sorrisinho.sorrisinhoapi.business.message.MessageRepository;
import com.sorrisinho.sorrisinhoapi.business.message.MessageService;
import com.sorrisinho.sorrisinhoapi.business.student.Student;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.sql.SQLException;

@Service
@Slf4j
public class Sender {
    @Autowired
    private MessageRepository messageRepository;

    @Autowired
    private MessageService messageService;

    public void sendMessage(Long chatId, TelegramBot bot, String text, String tree, Student student) throws SQLException {
        com.pengrad.telegrambot.request.SendMessage sendMessage = new com.pengrad.telegrambot.request.SendMessage(chatId, text);
        sendMessage.parseMode(ParseMode.HTML);

        try {
            BaseResponse response = bot.execute(sendMessage);
        } catch (Exception ex) {
            log.info(ex.toString());
        }

        messageService.saveProcessedMessage(text, student, chatId, tree);
    }
}
