package com.sorrisinho.sorrisinhoapi.business.discipline;

import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface DisciplineRepository extends JpaRepository<Discipline, Long> {
    Optional<Discipline> findOneByCodeAndQuarterNumberAndQuarterYear(String code, Integer quarterNumber, Integer quarterYear);

    List<Discipline> findByQuarterNumberAndQuarterYear(Integer quarterNumber, Integer quarterYear);
}
