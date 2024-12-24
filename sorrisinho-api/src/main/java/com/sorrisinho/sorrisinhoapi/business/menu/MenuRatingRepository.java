package com.sorrisinho.sorrisinhoapi.business.menu;

import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Date;
import java.util.List;

public interface MenuRatingRepository extends JpaRepository<MenuRating, Long> {
    List<MenuRating> findByDateAndType(Date date, MenuRatingType type);
}
