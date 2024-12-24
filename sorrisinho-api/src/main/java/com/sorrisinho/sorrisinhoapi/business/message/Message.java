package com.sorrisinho.sorrisinhoapi.business.message;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.sorrisinho.sorrisinhoapi.business.student.Student;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import javax.persistence.*;
import java.sql.Blob;
import java.time.Instant;
import java.util.Date;

@Entity
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@JsonIgnoreProperties(value={"hibernateLazyInitializer","handler"})
public class Message {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(nullable = false)
    private Long id;

    @Column(nullable = false)
    private Blob message;

    @Column
    private String tree;

    @Column(nullable = false)
    private Long chatId;

    @Column(nullable = false)
    private String type;

    @Column
    private Long updatedId;

    @Column
    private Date createdAt = Date.from(Instant.now());

    @ManyToOne(fetch = FetchType.LAZY)
    private Student student;
}
