package com.lumentrack.dashboard_management.config;

import com.lumentrack.dashboard_management.security.JwtAuthenticationFilter;
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
                // 1. Rutas públicas (accesibles para todos sin autenticación)
                .requestMatchers("/public/**").permitAll()

                // 2. Restricciones para operaciones de administración (solo SUPER_ADMIN)
                // Asumiendo que /admin/** en dashboard-management son rutas de administración
                .requestMatchers("/lumentrack/dashboard/admin/**").hasRole("SUPER_ADMIN")

                // 3. ROLE_DESIGN: Acceso a los endpoints de DashboardUserFilteredService (GET)
                .requestMatchers(HttpMethod.GET, "/lumentrack/dashboard/getData/user/**").hasAnyRole("SUPER_ADMIN", "ADMIN", "DESIGN")

                // 4. ROLE_PRODUCTION: Acceso exclusivo a endpoints de consulta general (GET)
                .requestMatchers(HttpMethod.GET, "/lumentrack/dashboard/**").hasAnyRole("SUPER_ADMIN", "ADMIN", "PRODUCTION", "DESIGN")

                // 5. ROLE_SALES: Acceso exclusivo a endpoints de consulta general (GET) en rutas específicas
                // Asumiendo que no hay rutas específicas para SALES en dashboard-management,
                // se le dará acceso a los GET generales si es necesario, o se le puede denegar.
                // Por ahora, se incluirá en los GET generales si aplica.

                // 6. Restricciones generales para POST/PUT/PATCH/DELETE
                // Solo SUPER_ADMIN y ADMIN pueden realizar estas operaciones en general.
                .requestMatchers(HttpMethod.POST, "/lumentrack/dashboard/**").hasAnyRole("SUPER_ADMIN", "ADMIN")
                .requestMatchers(HttpMethod.PUT, "/lumentrack/dashboard/**").hasAnyRole("SUPER_ADMIN", "ADMIN")
                .requestMatchers(HttpMethod.PATCH, "/lumentrack/dashboard/**").hasAnyRole("SUPER_ADMIN", "ADMIN")
                .requestMatchers(HttpMethod.DELETE, "/lumentrack/dashboard/**").hasAnyRole("SUPER_ADMIN", "ADMIN")

                // 7. Cualquier otra solicitud requiere autenticación (ROLE_NONE será denegado por defecto aquí)
                .anyRequest().authenticated()
            )
            // Añadir JwtAuthenticationFilter antes de UsernamePasswordAuthenticationFilter
            .addFilterBefore(jwtAuthenticationFilter, UsernamePasswordAuthenticationFilter.class);

        return http.build();
    }
}
