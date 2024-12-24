package com.sorrisinho.sorrisinhoapi;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.scheduling.annotation.EnableScheduling;

import java.util.Locale;

@SpringBootApplication
@EnableScheduling
public class SorrisinhoApiApplication {

	public static void main(String[] args) {
		SpringApplication.run(SorrisinhoApiApplication.class, args);
	}

}
