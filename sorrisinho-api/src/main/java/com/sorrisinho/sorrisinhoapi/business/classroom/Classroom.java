package com.sorrisinho.sorrisinhoapi.business.classroom;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.sorrisinho.sorrisinhoapi.business.discipline.Discipline;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import javax.persistence.*;

@Entity
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@JsonIgnoreProperties(value={"hibernateLazyInitializer","handler"})
public class Classroom implements Comparable {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(nullable = false)
    private Long id;

    @Column(nullable = false)
    private String day;

    @Column(nullable = false)
    private Integer weekdayNumber;

    @Column(nullable = false)
    private String room;

    @Column(nullable = false)
    private String frequency;

    @Column(nullable = false)
    private String teacher;

    @Column(nullable = false)
    private String secondaryTeacher;

    @Column(nullable = false)
    private String type;

    @Column(nullable = false)
    private Integer start;

    @Column(nullable = false)
    private Integer end;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "discipline_id")
    private Discipline discipline;

    public Classroom (Integer id) { this.id = Long.valueOf(id); }

    @Override
    public int compareTo(Object o) {
        return this.getStart().compareTo(((Classroom) o).getStart());
    }
}
