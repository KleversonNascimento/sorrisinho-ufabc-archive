package com.sorrisinho.sorrisinhoapi.business.discipline;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import javax.persistence.Column;
import java.time.Instant;
import java.util.Date;

@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
public class DisciplineDTO {
    private Long id;

    private String name;

    private String campus;

    private String period;

    private String code;

    private String type;

    private String classCode;

    private Integer quarterNumber;

    private Integer quarterYear;

    private Date createdAt = Date.from(Instant.now());

    private String course;

    private String tpi;

    public DisciplineDTO(Discipline discipline) {
        this.id = discipline.getId();
        this.name = discipline.getName();
        this.campus = discipline.getCampus();
        this.period = discipline.getPeriod();
        this.code = discipline.getCode();
        this.type = discipline.getType();
        this.quarterNumber = discipline.getQuarterNumber();
        this.quarterYear = discipline.getQuarterYear();
        this.createdAt = discipline.getCreatedAt();
        this.course = discipline.getCourse();
        this.tpi = discipline.getTpi();
    }

    public Discipline toDiscipline() {
        return new Discipline(this.getId(), this.getName(), this.getCampus(), this.getPeriod(), this.getCode(), this.getType(), this.getClassCode(), this.getQuarterNumber(), this.getQuarterYear(), this.getCreatedAt(), this.getCourse(), this.getTpi());
    }
}
