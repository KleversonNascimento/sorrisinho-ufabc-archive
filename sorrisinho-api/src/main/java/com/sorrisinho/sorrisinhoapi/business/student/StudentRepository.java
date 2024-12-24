package com.sorrisinho.sorrisinhoapi.business.student;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.Optional;

public interface StudentRepository extends JpaRepository<Student, Long> {
    Optional<Student> findOneByChatId(String chatId);

    @Query("UPDATE Student s SET s.ra = 0, s.chatId = 0 WHERE s.id = :studentId")
    void changeRAAndChatId(@Param("studentId") Long studentId);
}
