package com.lumentrack.adminmanagement.model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity
@Data
@NoArgsConstructor // Genera el constructor vacío obligatorio para Jackson
@AllArgsConstructor // Genera el constructor con todos los campos
@Builder // Te permite mapear y construir este objeto de forma fluida
@Table(name="roles")
public class Roles {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer roleId;

    @Column( nullable = false )
    private String roleDisplayName;

    @Column( nullable = false )
    private String roleName;

    @Column( nullable = true )
    private String roleDescription;

}
