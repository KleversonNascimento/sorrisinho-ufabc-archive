package com.sorrisinho.sorrisinhoapi.business.calendar;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
public class EventDTO {
    private String name;

    private String link;

    private String description;

    private String date;

    public EventDTO(final Event event) {
        this.name = event.getDescription();
        this.link = event.getLink();
        this.description = event.getDescription();
        this.date = event.getStartDate().toString().substring(0, 10);
    }
}
