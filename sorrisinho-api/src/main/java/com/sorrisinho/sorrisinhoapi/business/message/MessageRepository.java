package com.sorrisinho.sorrisinhoapi.business.message;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.Optional;

public interface MessageRepository extends JpaRepository<Message, Long> {
    Optional<Message> findFirstByTypeOrderByUpdatedIdDesc(String type);

    Optional<Message> findFirstByChatIdAndTypeOrderByCreatedAtDesc(Long chatId, String type);

}
