package com.lumentrack.dashboard_management.controller;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.webmvc.test.autoconfigure.AutoConfigureMockMvc;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;

@SpringBootTest
@AutoConfigureMockMvc
class DashboardControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @Test
    void shouldReturnDashboardData() throws Exception {
        // Ejecutamos la petición al endpoint base
        mockMvc.perform(get("/lumentrack/dashboard")
                .contentType(MediaType.APPLICATION_JSON))
                .andExpect(status().isOk()) // Verifica que devuelva 200 OK
                // Verifica que la estructura del JSON sea la correcta (según tu Record)
                .andExpect(jsonPath("$.sampleCount").exists())
                .andExpect(jsonPath("$.ordersCount").exists())
                .andExpect(jsonPath("$.samplesList").isArray());
    }
}