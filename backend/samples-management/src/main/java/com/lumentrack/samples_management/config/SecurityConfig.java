package com.lumentrack.samples_management.config;

import com.lumentrack.samples_management.security.JwtAuthenticationFilter;
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

                        // 2. Permisos específicos para ROLE_DESIGN en POST (actualización)
                        //    ROLE_DESIGN puede hacer POST para actualizar en ComponentController y TaskController.
                        //    Esto debe ir antes de las restricciones generales de POST.
                        .requestMatchers(HttpMethod.POST,
                                "/lumentrack/samples/components/update/**",
                                "/lumentrack/samples/tasks/update/**")
                        .hasAnyRole("SUPER_ADMIN", "ADMIN", "DESIGN")

                        // 3. Restricciones para operaciones de administración de Samples/Orders (solo SUPER_ADMIN)
                        //    ROLE_ADMIN no tiene acceso a estas operaciones de creación/eliminación.
                        .requestMatchers(HttpMethod.POST, "/lumentrack/samples/samples/**", "/lumentrack/samples/orders/**").hasRole("SUPER_ADMIN")
                        .requestMatchers(HttpMethod.DELETE, "/lumentrack/samples/samples/**", "/lumentrack/samples/orders/**").hasRole("SUPER_ADMIN")

                        // 4. Restricciones generales para POST/PUT/PATCH/DELETE
                        //    Solo SUPER_ADMIN y ADMIN pueden realizar estas operaciones en general.
                        //    Esto restringe a PRODUCTION, SALES, y DESIGN (excepto sus POST de actualización específicos ya definidos).
                        .requestMatchers(HttpMethod.POST, "/**").hasAnyRole("SUPER_ADMIN", "ADMIN")
                        .requestMatchers(HttpMethod.PUT, "/**").hasAnyRole("SUPER_ADMIN", "ADMIN")
                        .requestMatchers(HttpMethod.PATCH, "/**").hasAnyRole("SUPER_ADMIN", "ADMIN")
                        .requestMatchers(HttpMethod.DELETE, "/**").hasAnyRole("SUPER_ADMIN", "ADMIN")

                        // 5. Permisos específicos para GET
                        //    ROLE_SALES: Acceso exclusivo a GET en Orders y Samples.
                        .requestMatchers(HttpMethod.GET, "/lumentrack/samples/orders/**", "/lumentrack/samples/samples/**").hasAnyRole("SUPER_ADMIN", "ADMIN", "SALES")

                        //    ROLE_DESIGN: Acceso exclusivo a GET en UserFilteredDataController.
                        .requestMatchers(HttpMethod.GET, "/lumentrack/samples/user-filtered-data/**").hasAnyRole("SUPER_ADMIN", "ADMIN", "DESIGN")

                        // 6. Regla general para cualquier GET restante
                        //    Todos los roles que tienen permiso de lectura general.
                        .requestMatchers(HttpMethod.GET, "/**").hasAnyRole("SUPER_ADMIN", "ADMIN", "PRODUCTION", "DESIGN", "SALES")

                        // 7. Cualquier otra solicitud requiere autenticación (ROLE_NONE será denegado por defecto aquí)
                        .anyRequest().authenticated()
                )
                // Añadir JwtAuthenticationFilter antes de UsernamePasswordAuthenticationFilter
                .addFilterBefore(jwtAuthenticationFilter, UsernamePasswordAuthenticationFilter.class);

        return http.build();
    }
}