package com.lumentrack.authmanagement.controller;

import com.lumentrack.authmanagement.request.LoginRequest;
import com.lumentrack.authmanagement.response.AuthResponse;
import com.lumentrack.authmanagement.service.AuthService;
import com.lumentrack.authmanagement.security.JwtUtil; // Importar JwtUtil
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/auth")
@CrossOrigin(origins = "*") // Permitir CORS para el frontend
public class AuthController {

    private final static Logger logger = LoggerFactory.getLogger(AuthController.class);

    private final AuthService authService;
    private final JwtUtil jwtUtil; // Declarar JwtUtil

    @Autowired
    public AuthController(AuthService authService, JwtUtil jwtUtil) { // Inyectar JwtUtil
        this.authService = authService;
        this.jwtUtil = jwtUtil;
    }

    @PostMapping("/login")
    public ResponseEntity<AuthResponse> login(@RequestBody LoginRequest loginRequest) {
        logger.info("Login attempt for user: {}", loginRequest.getUserMail());
        AuthResponse authResponse = authService.authenticateUser(loginRequest);
        return ResponseEntity.ok(authResponse);
    }
}