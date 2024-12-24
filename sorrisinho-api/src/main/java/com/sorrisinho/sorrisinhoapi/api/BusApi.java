package com.sorrisinho.sorrisinhoapi.api;

import com.sorrisinho.sorrisinhoapi.business.bus.Bus;
import com.sorrisinho.sorrisinhoapi.business.bus.BusService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.io.IOException;
import java.util.List;

@RestController
@RequestMapping("/bus")
public class BusApi {
    @Autowired
    BusService busService;

    /*@RequestMapping("/fill")
    public ResponseEntity<String> fill() throws IOException, ParseException {
        return ResponseEntity.ok(busService.fill());
    }*/

    @RequestMapping("/all")
    public ResponseEntity<List<Bus>> getAll() throws IOException {
        return ResponseEntity.ok(busService.getAll());
    }
}
