package com.sorrisinho.sorrisinhoapi.business.discipline;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.sorrisinho.sorrisinhoapi.business.classroom.Classroom;
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
public class Discipline {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(nullable = false)
    private Long id;

    @Column(nullable = false)
    private String name;

    @Column(nullable = false)
    private String campus;

    @Column(nullable = false)
    private String period;

    @Column(nullable = false)
    private String code;

    @Column(nullable = false)
    private String type;

    @Column(nullable = false)
    private String classCode;

    @Column(nullable = false)
    private Integer quarterNumber;

    @Column(nullable = false)
    private Integer quarterYear;

    @Column(nullable = false)
    private Date createdAt = Date.from(Instant.now());

    @Column(nullable = false)
    private String course;

    @Column(nullable = false)
    private String tpi;

    void updateFromAnotherDiscipline(Discipline disciplineToCopy) {
        this.name = disciplineToCopy.getName();
        this.campus = disciplineToCopy.getCampus();
        this.period = disciplineToCopy.getPeriod();
        this.code = disciplineToCopy.getCode();
        this.type = disciplineToCopy.getType();
        this.classCode = disciplineToCopy.getClassCode();
        this.course = disciplineToCopy.getCourse();
        this.tpi = disciplineToCopy.getTpi();

    }


    public Discipline (Integer id) { this.id = Long.valueOf(id); }
}
