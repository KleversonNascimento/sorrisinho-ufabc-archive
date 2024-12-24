package com.sorrisinho.sorrisinhoapi.business.classroom;

import com.sorrisinho.sorrisinhoapi.business.discipline.Discipline;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;
import java.util.Optional;

public interface ClassroomRepository  extends JpaRepository<Classroom, Long> {
    @Query("SELECT c FROM Classroom c JOIN c.discipline d WHERE d.id = :discipline"
            + " AND c.day = :day"
            + " AND (c.frequency = 'Semanal' OR c.frequency = :frequency)"
            + " ORDER BY c.start")
    List<Classroom> achar(@Param("discipline") Long discipline, @Param("day") String day, @Param("frequency") String frequency);

    List<Classroom> findAllByDiscipline(Discipline discipline);

    void deleteAllByDiscipline(Discipline discipline);
}
