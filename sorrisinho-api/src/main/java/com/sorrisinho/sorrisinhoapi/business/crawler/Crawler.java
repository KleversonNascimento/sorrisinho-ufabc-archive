package com.sorrisinho.sorrisinhoapi.business.crawler;

import com.sorrisinho.sorrisinhoapi.business.menu.MenuService;
import lombok.extern.slf4j.Slf4j;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.*;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import javax.transaction.Transactional;
import java.util.Collections;
import org.springframework.scheduling.annotation.Scheduled;

@Component
@Service
@Slf4j
public class Crawler {

    @Autowired
    MenuService menuService;

    @Scheduled(fixedRate = 300000)
    @Transactional
    public void main() throws ParseException {
        menuService.updateMenusIfNecessary(getMenuInfos());
    }

    public JSONObject getMenuInfos() throws ParseException {
        RestTemplate restTemplate = new RestTemplate();

        String uri = "https://proap.ufabc.edu.br/index.php?option=com_cardapio&format=ajax&lang=en&view=cardapio&task=getData";

        HttpHeaders headers = new HttpHeaders();
        headers.setAccept(Collections.singletonList(MediaType.APPLICATION_JSON));
        headers.add("user-agent", "Mozilla/5.0 (iPhone; CPU iPhone OS 13_2_3 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.0.3 Mobile/15E148 Safari/604.1");

        HttpEntity<String> entity = new HttpEntity<>("parameters", headers);
        ResponseEntity<?> result =
                restTemplate.exchange(uri, HttpMethod.GET, entity, String.class);

        JSONParser parser = new JSONParser();

        return (JSONObject) parser.parse((String) result.getBody());
    }
}
