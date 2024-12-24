package com.sorrisinho.sorrisinhoapi.business.menu;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import javax.persistence.*;
import java.time.*;
import java.util.Date;

@Entity
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@JsonIgnoreProperties(value={"hibernateLazyInitializer","handler"})
public class MenuRating {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(nullable = false)
    private Long id;

    @Column(nullable = false)
    private Date date;

    @Column(nullable = false)
    private int rating;

    @Column
    private String comment;

    @Column(nullable = false)
    private MenuRatingType type;

    @Column(nullable = false)
    private Date createdAt = Date.from(Instant.now(Clock.system(ZoneId.of("America/Sao_Paulo"))));
}
