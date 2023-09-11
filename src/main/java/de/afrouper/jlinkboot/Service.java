package de.afrouper.jlinkboot;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import java.time.LocalDateTime;

@RestController
public class Service {

    @GetMapping("/")
    public String hello() {
        return "Hello from Service at " + LocalDateTime.now();
    }
}
