package org.whalebank.backend.test;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class TestService {

    private final TestRepository repository;

    public TestEntity insert(String value) {
        TestEntity entity = TestEntity.builder().value(value).build();
        return repository.save(entity);
    }

}
