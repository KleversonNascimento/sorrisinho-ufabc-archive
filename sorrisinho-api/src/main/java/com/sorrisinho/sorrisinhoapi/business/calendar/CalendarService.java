package com.sorrisinho.sorrisinhoapi.business.calendar;

import lombok.extern.slf4j.Slf4j;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.ClassPathResource;
import org.springframework.stereotype.Service;

import java.io.*;
import java.sql.Date;
import java.sql.Time;
import java.util.List;
import java.util.stream.Collectors;

@Service
@Slf4j
public class CalendarService {

    @Autowired
    CalendarRepository calendarRepository;

    public List<EventDTO> getAllEvents() throws IOException {
        return calendarRepository.findAll().stream().map(EventDTO::new).collect(Collectors.toList());
    }

    public String fillEvents() throws IOException, ParseException {
        JSONParser parser = new JSONParser();
        Object obj = parser.parse(new FileReader(new ClassPathResource("/calendar_2024.json").getFile()));

        JSONArray allEnrollments = (JSONArray) obj;

        System.out.println("Total: " + allEnrollments.size());

        for (int i = 0; i < allEnrollments.size(); i++) {
            JSONObject enrollment = (JSONObject) allEnrollments.get(i);

            final Event newEvent = new Event();
            newEvent.setDescription(enrollment.get("description").toString());
            newEvent.setName(enrollment.get("name").toString());
            newEvent.setStartDate(Date.valueOf(enrollment.get("startDate").toString()));
            newEvent.setEndDate(Date.valueOf(enrollment.get("endDate").toString()));
            newEvent.setStartTime(Time.valueOf(enrollment.get("startTime").toString()+":00"));
            newEvent.setEndTime(Time.valueOf(enrollment.get("endTime").toString()+":00"));

            calendarRepository.save(newEvent);
        }

        return "Ok";
    }
}
