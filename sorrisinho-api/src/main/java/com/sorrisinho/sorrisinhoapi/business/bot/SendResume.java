package com.sorrisinho.sorrisinhoapi.business.bot;

import com.pengrad.telegrambot.Callback;
import com.pengrad.telegrambot.TelegramBot;
import com.pengrad.telegrambot.model.Update;
import com.pengrad.telegrambot.request.BaseRequest;
import com.pengrad.telegrambot.request.GetUpdates;
import com.pengrad.telegrambot.response.BaseResponse;
import com.pengrad.telegrambot.response.GetUpdatesResponse;
import com.sorrisinho.sorrisinhoapi.business.discipline.DisciplineDTO;
import com.sorrisinho.sorrisinhoapi.business.enrollment.EnrollmentRepository;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.transaction.Transactional;
import java.io.IOException;
import java.util.List;

@Service
@Slf4j
public class SendResume {
    @Autowired
    private EnrollmentRepository enrollmentRepository;

    Integer offset = 0;

    @Transactional
    public DisciplineDTO bot() throws InterruptedException {
        TelegramBot bot = new TelegramBot("id here");

        while (true) {
            GetUpdates getUpdates = new GetUpdates().limit(100).offset(offset).timeout(0);
            GetUpdatesResponse updatesResponse = bot.execute(getUpdates);
            List<Update> updates = updatesResponse.updates();

            if (updates.size() > 0) {

                
                log.info(updates.get(0).message().text());
                offset = updates.get(0).updateId() + 1;
            }


            Thread.sleep(1000);
        }
    }
}
