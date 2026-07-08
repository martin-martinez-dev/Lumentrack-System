package com.lumentrack.authmanagement.security;

import com.lumentrack.commons.model.Roles;
import com.lumentrack.commons.model.Users;
import com.lumentrack.commons.repository.RolesRepository;
import com.lumentrack.commons.repository.UsersRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@Service
public class UserDetailsServiceImpl implements UserDetailsService {

    private final UsersRepository usersRepository;
    private final RolesRepository rolesRepository;

    @Autowired
    public UserDetailsServiceImpl(UsersRepository usersRepository, RolesRepository rolesRepository) {
        this.usersRepository = usersRepository;
        this.rolesRepository = rolesRepository;
    }

    @Override
    public UserDetails loadUserByUsername(String userMail) throws UsernameNotFoundException {
        Users user = usersRepository.findByUserMail(userMail)
                .orElseThrow(() -> new UsernameNotFoundException("User not found with email: " + userMail));

        Optional<Roles> roleOptional = rolesRepository.findById(user.getUserRoleId());
        String roleName = roleOptional.map(Roles::getRoleName).orElse("ROLE_UNKNOWN"); // Prefijo ROLE_ para Spring Security

        List<GrantedAuthority> authorities = new ArrayList<>();
        authorities.add(new SimpleGrantedAuthority(roleName));

        return new org.springframework.security.core.userdetails.User(
                user.getUserMail(),
                user.getPassword(),
                authorities
        );
    }
}
