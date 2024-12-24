package com.sorrisinho.sorrisinhoapi.business.bus;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import javax.persistence.*;
import java.sql.Time;

@Entity
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@JsonIgnoreProperties(value={"hibernateLazyInitializer","handler"})
public class Bus {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(nullable = false)
    private Long id;

    @Column(nullable = false)
    private String departure;

    @Column(nullable = false)
    private Time departureTime;

    @Column(nullable = false)
    private String arrival;

    @Column(nullable = false)
    private Time arrivalTime;

    @Column(nullable = false)
    private int lineNumber;

    @Column(nullable = false)
    private BusFrequency frequency;
}
