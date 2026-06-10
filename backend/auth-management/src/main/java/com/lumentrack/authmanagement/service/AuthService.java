package com.lumentrack.authmanagement.service;

import com.lumentrack.authmanagement.request.LoginRequest;
import com.lumentrack.authmanagement.response.AuthResponse;
import com.lumentrack.authmanagement.security.JwtUtil;
import com.lumentrack.authmanagement.security.UserDetailsServiceImpl;
import com.lumentrack.commons.model.Roles;
import com.lumentrack.commons.model.Users;
import com.lumentrack.commons.repository.RolesRepository;
import com.lumentrack.commons.repository.UsersRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

@Service
public class AuthService {

    private final static Logger logger = LoggerFactory.getLogger(AuthService.class);

    private final AuthenticationManager authenticationManager;
    private final UserDetailsServiceImpl userDetailsService;
    private final JwtUtil jwtUtil;
    private final UsersRepository usersRepository;
    private final RolesRepository rolesRepository;

    @Autowired
    public AuthService(AuthenticationManager authenticationManager,
                       UserDetailsServiceImpl userDetailsService,
                       JwtUtil jwtUtil,
                       UsersRepository usersRepository,
                       RolesRepository rolesRepository) {
        this.authenticationManager = authenticationManager;
        this.userDetailsService = userDetailsService;
        this.jwtUtil = jwtUtil;
        this.usersRepository = usersRepository;
        this.rolesRepository = rolesRepository;
    }

    public AuthResponse authenticateUser(LoginRequest loginRequest) {
        logger.info("Attempting to authenticate user: {}", loginRequest.getUserMail());

        try {
            Authentication authentication = authenticationManager.authenticate(
                    new UsernamePasswordAuthenticationToken(loginRequest.getUserMail(), loginRequest.getPassword())
            );
            // Si la autenticación es exitosa, el objeto Authentication contendrá los detalles del usuario
            // y se puede usar para generar el token.
        } catch (Exception e) {
            logger.error("Authentication failed for user {}: {}", loginRequest.getUserMail(), e.getMessage());
            throw new UsernameNotFoundException("Invalid credentials");
        }

        final UserDetails userDetails = userDetailsService.loadUserByUsername(loginRequest.getUserMail());
        final String jwt = jwtUtil.generateToken(userDetails);

        Users user = usersRepository.findByUserMail(loginRequest.getUserMail())
                .orElseThrow(() -> new UsernameNotFoundException("User not found after authentication. This should not happen."));

        Roles role = rolesRepository.findById(user.getUserRoleId())
                .orElseThrow(() -> new RuntimeException("Role not found for user: " + user.getUserMail()));

        logger.info("User {} authenticated successfully. Role: {}", user.getUserMail(), role.getRoleDisplayName());

        return AuthResponse.builder()
                .jwt(jwt)
                .userId(user.getUserId())
                .userName(user.getUserName())
                .userLastName(user.getUserLastName())
                .roleId(role.getRoleId())
                .roleName(role.getRoleName())
                .roleDisplayName(role.getRoleDisplayName())
                .build();
    }
}
