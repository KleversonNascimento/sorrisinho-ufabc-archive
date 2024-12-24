package com.sorrisinho.sorrisinhoapi.business.student;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import javax.persistence.*;
import java.time.Instant;
import java.util.Date;

@Entity
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@JsonIgnoreProperties(value={"hibernateLazyInitializer","handler"})
public class Student {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(nullable = false)
    private Long id;

    @Column(nullable = false)
    private String ra;

    @Column(nullable = false)
    private String chatId;

    @Column(nullable = false)
    private Boolean receiveResume = false;

    @Column(nullable = false)
    private Integer resumeOffSet = -1;

    @Column(nullable = false)
    private Integer resumeHour = 22;

    private Boolean needsFillSigaaString = false;

    private Date createdAt = Date.from(Instant.now());

    public Student (Integer id) { this.id = Long.valueOf(id); }
}
