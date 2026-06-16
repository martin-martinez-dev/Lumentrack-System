package com.lumentrack.samples_management.config;

import com.lumentrack.samples_management.security.JwtAuthenticationFilter;
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
                        .requestMatchers(HttpMethod.POST,
                                "/lumentrack/samples/components/update/**",
                                "/lumentrack/samples/tasks/update/**")
                        .hasAnyAuthority("SUPER_ADMIN", "ADMIN", "DESIGN")
                        .requestMatchers(HttpMethod.POST, "/lumentrack/samples/samples/**", "/lumentrack/samples/orders/**").hasAuthority("SUPER_ADMIN")
                        .requestMatchers(HttpMethod.DELETE, "/lumentrack/samples/samples/**", "/lumentrack/samples/orders/**").hasAuthority("SUPER_ADMIN")
                        .requestMatchers(HttpMethod.POST, "/**").hasAnyAuthority("SUPER_ADMIN", "ADMIN")
                        .requestMatchers(HttpMethod.PUT, "/**").hasAnyAuthority("SUPER_ADMIN", "ADMIN")
                        .requestMatchers(HttpMethod.PATCH, "/**").hasAnyAuthority("SUPER_ADMIN", "ADMIN")
                        .requestMatchers(HttpMethod.DELETE, "/**").hasAnyAuthority("SUPER_ADMIN", "ADMIN")
                        .requestMatchers(HttpMethod.GET, "/lumentrack/samples/orders/**", "/lumentrack/samples/samples/**").hasAnyAuthority("SUPER_ADMIN", "ADMIN", "SALES")
                        .requestMatchers(HttpMethod.GET, "/lumentrack/samples/user-filtered-data/**").hasAnyAuthority("SUPER_ADMIN", "ADMIN", "DESIGN")
                        .requestMatchers(HttpMethod.GET, "/**").hasAnyAuthority("SUPER_ADMIN", "ADMIN", "PRODUCTION", "DESIGN", "SALES")
                        .anyRequest().authenticated()
                )
                .addFilterBefore(jwtAuthenticationFilter, UsernamePasswordAuthenticationFilter.class);

        return http.build();
    }
}
