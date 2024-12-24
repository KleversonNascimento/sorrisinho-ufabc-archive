package com.sorrisinho.sorrisinhoapi.business.enrollment;

import com.sorrisinho.sorrisinhoapi.business.discipline.Discipline;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface EnrollmentRepository extends JpaRepository<Enrollment, Long> {
    List<Enrollment> findByRa(String ra);

    List<Enrollment> findByRaAndQuarterNumberAndQuarterYear(String ra, Integer quarterNumber, Integer quarterYear);

    Optional<Enrollment> findOneByRaAndDiscipline(String ra, Discipline discipline);

    void deleteAllByRaAndMadeByUser(String ra, Boolean madeByUser);

    void deleteAllByMadeByUser(Boolean madeByUser);
}
