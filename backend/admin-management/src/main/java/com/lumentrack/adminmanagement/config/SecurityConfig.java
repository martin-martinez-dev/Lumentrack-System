package com.lumentrack.adminmanagement.config;

import com.lumentrack.adminmanagement.security.JwtAuthenticationFilter;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpMethod;
import org.springframework.security.config.annotation.method.configuration.EnableMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configurers.AbstractHttpConfigurer;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;

@Configuration
@EnableWebSecurity
@EnableMethodSecurity // Habilita la seguridad a nivel de métodos (ej. @PreAuthorize)
public class SecurityConfig {

    private final JwtAuthenticationFilter jwtAuthenticationFilter;

    public SecurityConfig(JwtAuthenticationFilter jwtAuthenticationFilter) {
        this.jwtAuthenticationFilter = jwtAuthenticationFilter;
    }

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        http
            // Deshabilitar CSRF (ya que usamos JWT stateless)
            .csrf(AbstractHttpConfigurer::disable)
            // Configurar la política de sesión como STATELESS
            .sessionManagement(session -> session.sessionCreationPolicy(SessionCreationPolicy.STATELESS))
            // Configurar las reglas de autorización de los endpoints
            .authorizeHttpRequests(authorize -> authorize
                // 1. Rutas públicas (si las hubiera, accesibles para todos sin autenticación)
                .requestMatchers("/public/**").permitAll()

                // 2. Permitir el registro de nuevos usuarios sin autenticación
                .requestMatchers(HttpMethod.POST, "/users/save").permitAll()

                // 3. Todos los demás endpoints requieren ROLE_SUPER_ADMIN o ROLE_ADMIN
                // Esto cubre todas las demás rutas del microservicio admin-management
                .anyRequest().hasAnyRole("SUPER_ADMIN", "ADMIN")
            )
            // Añadir JwtAuthenticationFilter antes de UsernamePasswordAuthenticationToken
            .addFilterBefore(jwtAuthenticationFilter, UsernamePasswordAuthenticationFilter.class);

        return http.build();
    }
}