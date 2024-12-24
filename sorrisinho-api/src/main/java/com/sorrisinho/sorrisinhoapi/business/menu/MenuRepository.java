package com.sorrisinho.sorrisinhoapi.business.menu;

import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Date;
import java.util.List;
import java.util.Optional;

public interface MenuRepository extends JpaRepository<Menu, Long> {
    Optional<Menu> findOneByDateAndType(String date, String type);

    List<Menu> findByRawDateGreaterThanEqual(Date rawDate);
}
