package com.lumentrack.samples_management.security;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.ExpiredJwtException;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.MalformedJwtException;
import io.jsonwebtoken.UnsupportedJwtException;
import io.jsonwebtoken.io.Decoders;
import io.jsonwebtoken.security.Keys;
import io.jsonwebtoken.security.SignatureException;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpHeaders;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.web.authentication.WebAuthenticationDetailsSource;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

import javax.crypto.SecretKey;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@Component
public class JwtAuthenticationFilter extends OncePerRequestFilter {

    private static final Logger logger = LoggerFactory.getLogger(JwtAuthenticationFilter.class);

    @Value("${jwt.secret}")
    private String jwtSecret;

    @Override
    protected void doFilterInternal(HttpServletRequest request,
                                    HttpServletResponse response,
                                    FilterChain filterChain) throws ServletException, IOException {

        // --- AÑADIDO PARA DEPURACIÓN ---
        logger.debug("Processing request for URI: {}", request.getRequestURI());
        final String header = request.getHeader(HttpHeaders.AUTHORIZATION);
        // logger.debug("Authorization Header: {}", header); // Eliminado para no imprimir el token
        // --- FIN AÑADIDO PARA DEPURACIÓN ---

        // 1. Extraer el token del header Authorization: Bearer
        if (header == null || !header.startsWith("Bearer ")) {
            filterChain.doFilter(request, response);
            return;
        }

        final String token = header.substring(7); // Eliminar "Bearer "

        try {
            // Convertir el secreto Base64 a SecretKey
            SecretKey key = Keys.hmacShaKeyFor(Decoders.BASE64.decode(jwtSecret));

            // 2. Validar la firma utilizando la API moderna de JJWT 0.12.6
            Claims claims = Jwts.parser()
                    .verifyWith(key)
                    .build()
                    .parseSignedClaims(token)
                    .getPayload();

            // 3. Extraer el subject (email/usuario) y el claim "role"
            String username = claims.getSubject();
            String roleClaim = claims.get("role", String.class); // Extraer el claim "role" como String

            if (username != null && SecurityContextHolder.getContext().getAuthentication() == null) {
                List<SimpleGrantedAuthority> authorities = new ArrayList<>();
                if (roleClaim != null && roleClaim.startsWith("ROLE_")) {
                    // Limpiar el string eliminando el prefijo "ROLE_"
                    String cleanedRole = roleClaim.substring("ROLE_".length());
                    authorities.add(new SimpleGrantedAuthority(cleanedRole));
                } else if (roleClaim != null) {
                    // Si por alguna razón no tiene el prefijo, usarlo directamente
                    authorities.add(new SimpleGrantedAuthority(roleClaim));
                }

                // 5. Registrar al usuario en el contexto de seguridad
                UsernamePasswordAuthenticationToken authentication = new UsernamePasswordAuthenticationToken(
                        username, null, authorities
                );

                authentication.setDetails(new WebAuthenticationDetailsSource().buildDetails(request));
                SecurityContextHolder.getContext().setAuthentication(authentication);
                logger.debug("User '{}' authenticated with roles: {}", username, authorities); // Log de éxito
            }

        } catch (SignatureException ex) {
            logger.error("Firma JWT inválida: {}", ex.getMessage());
        } catch (MalformedJwtException ex) {
            logger.error("Token JWT inválido: {}", ex.getMessage());
        } catch (ExpiredJwtException ex) {
            logger.error("Token JWT expirado: {}", ex.getMessage());
        } catch (UnsupportedJwtException ex) {
            logger.error("Token JWT no soportado: {}", ex.getMessage());
        } catch (IllegalArgumentException ex) {
            logger.error("Cadena de claims JWT vacía: {}", ex.getMessage());
        } catch (Exception ex) {
            logger.error("Error al procesar el token JWT: {}", ex.getMessage());
        }

        filterChain.doFilter(request, response);
    }
}
