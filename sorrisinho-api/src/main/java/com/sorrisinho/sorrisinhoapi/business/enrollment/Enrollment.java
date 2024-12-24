package com.sorrisinho.sorrisinhoapi.business.enrollment;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.sorrisinho.sorrisinhoapi.business.discipline.Discipline;
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
public class Enrollment {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(nullable = false)
    private Long id;

    @Column(nullable = false)
    private String ra;

    @ManyToOne(fetch = FetchType.LAZY)
    private Discipline discipline;

    private Boolean madeByUser = false;

    @Column(nullable = false)
    private Integer quarterYear;

    @Column(nullable = false)
    private Integer quarterNumber;

    private Date createdAt = Date.from(Instant.now());

    public Enrollment (Integer id) { this.id = Long.valueOf(id); }
}
