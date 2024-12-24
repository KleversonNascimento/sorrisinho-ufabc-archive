package com.sorrisinho.sorrisinhoapi.api;

import com.sorrisinho.sorrisinhoapi.business.discipline.Discipline;
import com.sorrisinho.sorrisinhoapi.business.discipline.DisciplineDTO;
import com.sorrisinho.sorrisinhoapi.business.discipline.DisciplineService;
import org.json.simple.parser.ParseException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.io.IOException;
import java.util.List;

@RestController
@RequestMapping("/discipline")
public class DisciplineApi {
    @Autowired
    DisciplineService disciplineService;

    @PostMapping(consumes = {MediaType.APPLICATION_FORM_URLENCODED_VALUE, MediaType.APPLICATION_JSON_VALUE})
    public ResponseEntity<DisciplineDTO> create(@RequestBody final DisciplineDTO disciplineDTO) {
        DisciplineDTO savedDiscipline = disciplineService.save(disciplineDTO);
        return ResponseEntity.ok(savedDiscipline);
    }

    @RequestMapping(value="/enrollment/sigaa/{ra}", method = RequestMethod.POST)
    public ResponseEntity<Object> enrollmentBySigaa(@PathVariable("ra") String ra, @RequestBody String sigaaString) {
        disciplineService.makeEnrollmentsBySigaaString(sigaaString, ra);
        return ResponseEntity.ok(true);
    }

    @RequestMapping(value="/enrollment/sigaa/delete/{ra}", method= RequestMethod.GET)
    public ResponseEntity<Object> deleteBySigaa(@PathVariable("ra") String ra) {
        disciplineService.notifyDeleteRa(ra);
        return ResponseEntity.ok(true);
    }

    /*@RequestMapping("/load/enrollments/newHires")
    public ResponseEntity<Object> loadEnrollments() throws IOException, ParseException {
        disciplineService.loadNewHiresEnrollments();
        return ResponseEntity.ok(true);
    }*/

    @RequestMapping("/update/disciplines")
    public ResponseEntity<Object> updateDisciplines() throws IOException, org.json.simple.parser.ParseException {
        disciplineService.updateDisciplines();
        return ResponseEntity.ok(true);
    }

    @RequestMapping("/load/disciplines")
    public ResponseEntity<Object> loadDisciplines() throws IOException, ParseException {
        disciplineService.loadDisciplines();
        return ResponseEntity.ok(true);
    }

    @RequestMapping("/load/enrollments")
    public ResponseEntity<Object> loadEnrollments() throws IOException, ParseException {
        disciplineService.loadEnrollments();
        return ResponseEntity.ok(true);
    }

    @RequestMapping("/all")
    public ResponseEntity<List<Discipline>> all(){
        return ResponseEntity.ok(disciplineService.all());
    }
}
