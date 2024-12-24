package com.sorrisinho.sorrisinhoapi.business.discipline;

import com.sorrisinho.sorrisinhoapi.business.classroom.Classroom;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.List;

@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
public class DisciplineScheduleDTO {
    private Discipline discipline;

    private List<Classroom> classrooms;
}
