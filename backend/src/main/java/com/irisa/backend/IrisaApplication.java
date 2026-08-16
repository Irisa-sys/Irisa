package com.irisa.backend;

import com.ctrip.framework.apollo.spring.annotation.EnableApolloConfig;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
@EnableApolloConfig
public class IrisaApplication {

    public static void main(String[] args) {
        SpringApplication.run(IrisaApplication.class, args);
    }
}
