package com.sorrisinho.sorrisinhoapi.api;

import com.sorrisinho.sorrisinhoapi.business.menu.MenuService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.io.IOException;
import java.text.ParseException;

@RestController
@RequestMapping("/restaurant")
public class MenuApi {

    @Autowired
    MenuService menuService;

    @RequestMapping("/menu/all")
    public ResponseEntity<Object> getAllMenus() throws IOException {
        return ResponseEntity.ok(menuService.getNextMenus());
    }

    @RequestMapping("/fill")
    public ResponseEntity<String> fill() throws IOException, ParseException, org.json.simple.parser.ParseException {
        menuService.fill();
        return ResponseEntity.ok("OK");
    }

    @PostMapping("/comment/{rating}")
    public ResponseEntity<String> addComment(@PathVariable("rating") int rating, @RequestBody(required = false) String comment) {
        menuService.addComment(rating, comment);
        return ResponseEntity.ok("OK");
    }

    @RequestMapping("/comment/all")
    public ResponseEntity<Object> getComments() {
        return ResponseEntity.ok(menuService.getRestaurantComments());
    }
}
