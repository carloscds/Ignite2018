package com.vscode.demo;

import java.util.Objects;
import java.util.stream.Stream;

public class Main {

    public static void main(String[] args) {
        System.out.println("Hello VS Code Debugging at Ignite!");

        Stream.of("React", "Angular", "VSCode","Cool Editor")
            .filter(x -> Objects.equals(x, "VSCode"))
            .forEach(System.out::println);
    }

}