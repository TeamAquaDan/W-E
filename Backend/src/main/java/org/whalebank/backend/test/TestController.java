package org.whalebank.backend.test;

import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RequestMapping("/api")
@RestController
@RequiredArgsConstructor
public class TestController {

    private final TestService service;

    @GetMapping("/hello")
    public String helloWorld() {
        return "Hello World!";
    }

    @PostMapping("/insert-test")
    public TestEntity test() {
        return service.insert("HELLO!");
    }
}
