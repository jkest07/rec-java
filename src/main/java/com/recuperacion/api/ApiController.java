package com.recuperacion.api;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;
import java.util.Map;

@RestController
public class ApiController {

    @GetMapping("/")
    public Map<String, String> inicio() {
        return Map.of(
                "estado", "Operativo",
                "mensaje", "API Java ejecutándose en producción."
        );
    }

    @GetMapping("/datos")
    public Map<String, Object> datos() {
        return Map.of(
                "data", List.of(
                        "ADSO",
                        "DevOps",
                        "Seguridad",
                        "Java"
                )
        );
    }

    @GetMapping("/api/crash")
    public void crash() {

        System.err.println(
                "[FATAL ERROR] Fallo simulado. El sistema ha finalizado inesperadamente."
        );

        System.err.flush();

        System.exit(1);
    }
}