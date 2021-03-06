package com.vscode.demo;

import java.util.Arrays;
import java.util.List;
import java.util.Objects;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Tag;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertEquals;

@Tag("main")
class MainTest {

    @Test
    @DisplayName("VS Code JUnit 5 test")
    void testMain() {

        // arrange
        final List<String> list = Arrays.asList("React", "Angular", "VSCode");

        // act
        final String actual = list.stream()
            .filter(x -> Objects.equals(x, "VSCode"))
            .findFirst()
            .orElseThrow(IllegalArgumentException::new);

        // assert
        assertEquals("VSCode", actual, () -> "Main Succeed");
    }

    
    @Test
    @DisplayName("VS Code JUnit 5 test")
    void testCount() {

        // arrange
        final List<String> list = Arrays.asList("React", "Angular", "VSCode");

        // act
        final String actual = list.stream()
            .filter(x -> Objects.equals(x, "React"))
            .findFirst()
            .orElseThrow(IllegalArgumentException::new);

        // assert
        assertEquals("React", actual, () -> "Main Succeed");
    }

    
    @Test
    @DisplayName("VS Code test not passing")
    void testNotPassing() {

        // arrange
        final List<String> list = Arrays.asList("React", "Angular", "VSCode");

        // act
        final String actual = list.stream()
            .filter(x -> Objects.equals(x, "VSCode"))
            .findFirst()
            .orElseThrow(IllegalArgumentException::new);

        // assert
        assertEquals("React", actual, () -> "Main Succeed");
    }

}
