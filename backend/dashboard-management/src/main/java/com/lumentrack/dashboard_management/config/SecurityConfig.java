package com.lumentrack.dashboard_management.config;

import com.lumentrack.dashboard_management.security.JwtAuthenticationFilter;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpMethod;
import org.springframework.security.config.Customizer;
import org.springframework.security.config.annotation.method.configuration.EnableMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configurers.AbstractHttpConfigurer;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;

@Configuration
@EnableWebSecurity
@EnableMethodSecurity
public class SecurityConfig {

    private final JwtAuthenticationFilter jwtAuthenticationFilter;

    public SecurityConfig(JwtAuthenticationFilter jwtAuthenticationFilter) {
        this.jwtAuthenticationFilter = jwtAuthenticationFilter;
    }

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        http
            .cors(Customizer.withDefaults())
            .csrf(AbstractHttpConfigurer::disable)
            // Deshabilitar la autenticación HTTP básica por defecto
            .httpBasic(AbstractHttpConfigurer::disable) // Añadido
            // Deshabilitar el formulario de login por defecto
            .formLogin(AbstractHttpConfigurer::disable) // Añadido
            .sessionManagement(session -> session.sessionCreationPolicy(SessionCreationPolicy.STATELESS))
            .authorizeHttpRequests(authorize -> authorize
                .requestMatchers("/public/**").permitAll()
                .requestMatchers("/lumentrack/dashboard/admin/**").hasAuthority("SUPER_ADMIN")
                .requestMatchers(HttpMethod.GET, "/lumentrack/dashboard/getData/user/**").hasAnyAuthority("SUPER_ADMIN", "ADMIN", "DESIGN")
                .requestMatchers(HttpMethod.GET, "/lumentrack/dashboard/**").hasAnyAuthority("SUPER_ADMIN", "ADMIN", "PRODUCTION", "DESIGN")
                .requestMatchers(HttpMethod.POST, "/lumentrack/dashboard/**").hasAnyAuthority("SUPER_ADMIN", "ADMIN")
                .requestMatchers(HttpMethod.PUT, "/lumentrack/dashboard/**").hasAnyAuthority("SUPER_ADMIN", "ADMIN")
                .requestMatchers(HttpMethod.PATCH, "/lumentrack/dashboard/**").hasAnyAuthority("SUPER_ADMIN", "ADMIN")
                .requestMatchers(HttpMethod.DELETE, "/lumentrack/dashboard/**").hasAnyAuthority("SUPER_ADMIN", "ADMIN")
                .anyRequest().authenticated()
            )
            .addFilterBefore(jwtAuthenticationFilter, UsernamePasswordAuthenticationFilter.class);

        return http.build();
    }
}
