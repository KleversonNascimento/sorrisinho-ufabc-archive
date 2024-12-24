package com.sorrisinho.sorrisinhoapi.api;

import com.sorrisinho.sorrisinhoapi.business.classroom.Classroom;
import com.sorrisinho.sorrisinhoapi.business.classroom.ClassroomService;
import com.sorrisinho.sorrisinhoapi.business.promos.NoisResolveDTO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import javax.persistence.criteria.CriteriaBuilder;
import java.util.List;

@RestController
@RequestMapping("/classroom")
public class ClassroomApi {

    @Autowired
    ClassroomService classroomService;

    @RequestMapping(value="/allByRa/{ra}", method= RequestMethod.GET)
    public ResponseEntity<List<Classroom>> create(@PathVariable("ra") String ra) {
        return ResponseEntity.ok(classroomService.getAllClassroomsByRa(ra));
    }

    @RequestMapping(value="/allByRa/{ra}", method= RequestMethod.POST)
    public ResponseEntity<List<Classroom>> allByRaWithExtras(@PathVariable("ra") String ra, @RequestBody(required = false) List<Integer> additionalDisciplines) {
        return ResponseEntity.ok(classroomService.getAllClassroomsByRaWithExtras(ra, additionalDisciplines));
    }

    @RequestMapping(value="/noisresolve/{ra}", method= RequestMethod.POST)
    public ResponseEntity<NoisResolveDTO> noisresolve(@PathVariable("ra") String ra, @RequestBody(required = false) List<Integer> additionalDisciplines) {
        return ResponseEntity.ok(new NoisResolveDTO());
    }
}
