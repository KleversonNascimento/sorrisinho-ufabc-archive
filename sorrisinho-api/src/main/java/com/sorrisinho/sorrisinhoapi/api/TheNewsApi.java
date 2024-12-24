package com.sorrisinho.sorrisinhoapi.api;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/the-news")
public class TheNewsApi {
    @RequestMapping()
    public ResponseEntity<Boolean> get() {
        return ResponseEntity.ok(false);
    }
}
