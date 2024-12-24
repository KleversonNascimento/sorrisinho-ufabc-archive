package com.sorrisinho.sorrisinhoapi.api;


import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class TestApi {

    @RequestMapping("/")
    public String home() {
        return "Sorrisinho API Q3.2024 - Work in progress...";
    }

}
