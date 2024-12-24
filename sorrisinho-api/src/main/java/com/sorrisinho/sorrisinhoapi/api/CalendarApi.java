package com.sorrisinho.sorrisinhoapi.api;


import com.sorrisinho.sorrisinhoapi.business.calendar.CalendarService;
import com.sorrisinho.sorrisinhoapi.business.calendar.EventDTO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.io.IOException;
import java.util.List;

@RestController
@RequestMapping("/calendar")
public class CalendarApi {

    @Autowired
    CalendarService calendarService;

    @RequestMapping("/all")
    public ResponseEntity<List<EventDTO>> getAllDates() throws IOException {
        return ResponseEntity.ok(calendarService.getAllEvents());
    }

    /*@RequestMapping("/fill")
    public ResponseEntity<String> fillEvents() throws IOException, ParseException {
        return ResponseEntity.ok(calendarService.fillEvents());
    }*/
}
