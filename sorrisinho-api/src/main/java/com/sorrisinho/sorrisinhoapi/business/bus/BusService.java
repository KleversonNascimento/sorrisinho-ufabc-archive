package com.sorrisinho.sorrisinhoapi.business.bus;

import com.sorrisinho.sorrisinhoapi.business.calendar.Event;
import lombok.extern.slf4j.Slf4j;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.ClassPathResource;
import org.springframework.stereotype.Service;

import java.io.FileReader;
import java.io.IOException;
import java.sql.Date;
import java.sql.Time;
import java.util.List;

@Service
@Slf4j
public class BusService {

    @Autowired
    private BusRepository busRepository;

    public List<Bus> getAll() {
        return busRepository.findAll();
    }

    public String fill() throws IOException, ParseException {
        JSONParser parser = new JSONParser();
        Object obj = parser.parse(new FileReader(new ClassPathResource("/bus.json").getFile()));

        JSONArray allBus = (JSONArray) obj;

        System.out.println("Total: " + allBus.size());

        for (int i = 0; i < allBus.size(); i++) {
            JSONObject bus = (JSONObject) allBus.get(i);

           final BusFrequency frequency = bus.get("frequency").toString().equals("SATURDAY")
                   ? BusFrequency.SATURDAY
                   : BusFrequency.BUSINESS_DAY;

            final Bus newBus = new Bus();
            newBus.setDeparture(bus.get("departure").toString());
            newBus.setDepartureTime(Time.valueOf(bus.get("departureTime").toString()+":00"));
            newBus.setArrival(bus.get("arrival").toString());
            newBus.setArrivalTime(Time.valueOf(bus.get("arrivalTime").toString()+":00"));
            newBus.setLineNumber(Integer.valueOf(bus.get("line").toString()));
            newBus.setFrequency(frequency);

            busRepository.save(newBus);
        }

        return "Ok";
    }

}
