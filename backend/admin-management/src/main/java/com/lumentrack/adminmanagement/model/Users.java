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
@Table(name="users")
public class Users {
	
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private Integer userId;
	
	@Column( nullable = false )
	private String userName;
	
	@Column( nullable = false )
	private String userLastName;
	
	@Column( nullable = false )
	private String userMail;
	
	@Column( nullable = true )
	private String userPhoneNumber;
	
	@Column( nullable = false )
	private Integer userRoleId;

	@Transient
	private String roleDisplayName;
	
}
