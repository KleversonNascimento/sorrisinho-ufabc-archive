package com.sorrisinho.sorrisinhoapi.business.menu;

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
public class Menu {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(nullable = false)
    private Long id;

    @Column(nullable = false)
    private String date;

    @Column(nullable = false)
    private String type;

    @Column(nullable = false)
    private String principal;

    @Column(nullable = false)
    private String vegan;

    @Column(nullable = false)
    private String sideDish;

    @Column(nullable = false)
    private String salads;

    @Column(nullable = false)
    private String desserts;

    @Column(nullable = false)
    private Date rawDate;

    @Column(nullable = false)
    private Date createdAt = Date.from(Instant.now());
}
