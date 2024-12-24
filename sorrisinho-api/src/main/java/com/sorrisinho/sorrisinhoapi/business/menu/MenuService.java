package com.sorrisinho.sorrisinhoapi.business.menu;

import java.io.FileReader;
import java.io.IOException;
import java.sql.Date;
import java.time.Instant;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.time.temporal.ChronoField;
import java.time.temporal.TemporalAccessor;
import java.time.temporal.TemporalAmount;
import java.util.List;
import java.util.Locale;
import java.util.Optional;
import java.util.stream.Collectors;

import lombok.extern.slf4j.Slf4j;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.ClassPathResource;
import org.springframework.stereotype.Service;

import javax.transaction.Transactional;

@Service
@Slf4j
public class MenuService {

    @Autowired
    private MenuRepository menuRepository;

    @Autowired
    private MenuRatingRepository menuRatingRepository;

    public List<Menu> getNextMenus() {
        return menuRepository.findByRawDateGreaterThanEqual(java.util.Date.from(Instant.now().minusSeconds(172800L)));
    }

    @Transactional
    public void fill() throws IOException, ParseException {
        JSONParser parser = new JSONParser();
        Object obj = parser.parse(new FileReader(new ClassPathResource("ru_24_06.json").getFile()));
        final JSONArray menusArray = (JSONArray) obj;

        for (Object menu : menusArray) {
            JSONObject objectMenu = (JSONObject) menu;
            lunch(objectMenu);
            dinner(objectMenu);
        }
    }

    @Transactional
    public void addComment(final int rating, final String comment) {
        final MenuRating newMenuRating = new MenuRating();
        newMenuRating.setRating(rating);
        newMenuRating.setComment(comment);
        newMenuRating.setDate(Date.valueOf(LocalDate.now(ZoneId.of("America/Sao_Paulo"))));
        newMenuRating.setType(LocalDateTime.now(ZoneId.of("America/Sao_Paulo")).getHour() < 17 ? MenuRatingType.LUNCH : MenuRatingType.DINNER);

        menuRatingRepository.save(newMenuRating);
    }

    public List<MenuRating> getRestaurantComments() {
        final MenuRatingType ratingType = LocalDateTime.now(ZoneId.of("America/Sao_Paulo")).getHour() < 17 ? MenuRatingType.LUNCH : MenuRatingType.DINNER;
        final List<MenuRating> list = menuRatingRepository.findByDateAndType(Date.valueOf(LocalDate.now(ZoneId.of("America/Sao_Paulo"))), ratingType);
        list.forEach(comment -> comment.setComment(null));

        return list;
    }

    public void updateMenusIfNecessary(JSONObject jsonObject) {
        final JSONArray menusArray = (JSONArray) jsonObject.get("cardapios");

        for (Object menu : menusArray) {
            JSONObject objectMenu = (JSONObject) menu;
            lunch(objectMenu);
            dinner(objectMenu);
        }
    }

    private void lunch(JSONObject object) {
        final Menu createdLunch = createLunch(object);

        if (createdLunch.getPrincipal() != null && !createdLunch.getPrincipal().isEmpty() && createdLunch.getDate() != null && !createdLunch.getDate().isEmpty()) {
            createOrUpdateMenu(createdLunch);
        }
    }

    private void dinner(JSONObject object) {
        final Menu createdDinner = createDinner(object);

        if (createdDinner.getPrincipal() != null && !createdDinner.getPrincipal().isEmpty() && createdDinner.getDate() != null && !createdDinner.getDate().isEmpty()) {
            createOrUpdateMenu(createdDinner);
        }
    }

    private Menu createLunch(JSONObject object) {
        final Menu lunch = new Menu();

        lunch.setPrincipal(getStringCarefully(((JSONObject)object.get("lunch")).get("name")));
        lunch.setVegan(getStringCarefully(((JSONObject)object.get("vegan")).get("name")));
        lunch.setSideDish(getStringCarefully(((JSONObject)object.get("sidedish")).get("name")));
        lunch.setSalads(getStringCarefully(((JSONObject)object.get("salad")).get("list")));
        lunch.setDesserts(getStringCarefully(((JSONObject)object.get("dessert")).get("list")));
        lunch.setDate(getStringCarefully(object.get("date")));
        lunch.setRawDate(Date.valueOf(getStringCarefully(object.get("date"))));
        lunch.setType("lunch");

        return lunch;
    }

    private Menu createDinner(JSONObject object) {
        final Menu dinner = new Menu();

        dinner.setPrincipal(getStringCarefully(((JSONObject)object.get("dinner")).get("name")));
        dinner.setVegan(getStringCarefully(((JSONObject)object.get("vegan_dinner")).get("name")));
        dinner.setSideDish(getStringCarefully(((JSONObject)object.get("sidedish_dinner")).get("name")));
        dinner.setSalads(getStringCarefully(((JSONObject)object.get("salad")).get("list")));
        dinner.setDesserts(getStringCarefully(((JSONObject)object.get("dessert")).get("list")));
        dinner.setDate(getStringCarefully(object.get("date")));
        dinner.setRawDate(Date.valueOf(getStringCarefully(object.get("date"))));
        dinner.setType("dinner");

        return dinner;
    }

    private String getStringCarefully(Object object) {
        if (object == null) {
            return "";
        }

        return object.toString();
    }

    private void createOrUpdateMenu(Menu menu) {
        final Optional<Menu> optionalMenu = menuRepository.findOneByDateAndType(menu.getDate(), menu.getType());

        if (optionalMenu.isPresent()){
            final Menu currentMenu = optionalMenu.get();

            currentMenu.setPrincipal(menu.getPrincipal());
            currentMenu.setVegan(menu.getVegan());
            currentMenu.setSideDish(menu.getSideDish());
            currentMenu.setSalads(menu.getSalads());
            currentMenu.setDesserts(menu.getDesserts());

            menuRepository.save(currentMenu);
        } else {
            menuRepository.save(menu);
        }
    }
}
