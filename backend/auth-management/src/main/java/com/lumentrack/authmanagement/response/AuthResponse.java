package com.lumentrack.authmanagement.response;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class AuthResponse {
    private String jwt;
    private Integer userId;
    private String userName;
    private String userLastName;
    private Integer roleId;
    private String roleName; // Asumiendo que la entidad Users o Roles tiene un campo para el nombre del rol
    private String roleDisplayName; // Asumiendo que la entidad Users o Roles tiene un campo para el nombre de visualización del rol
}
