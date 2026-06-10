package com.lumentrack.commons.model;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor; // Añadido
import lombok.Builder; // Añadido
import lombok.Data;
import lombok.NoArgsConstructor; // Añadido

@Entity
@Data
@NoArgsConstructor // Añadido
@AllArgsConstructor // Añadido
@Builder(toBuilder = true) // Añadido
@Table(name="clients")
public class Clients {
	
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private Integer clientId;
	
	@Column( nullable = false )
	private String clientName;
	
	@Column( nullable = false )
	private String companyName;
	
	@Column( nullable = false )
	private String clientContactName;
	
	@Column( nullable = false )
	private String clientPhoneNumber;
	
	@Column( nullable = false )
	private String clientMail;
	
	@Column( nullable = false )
	private String ulaLightEmployee;
	
}