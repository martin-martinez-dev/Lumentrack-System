package com.lumentrack.samples_management.model;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.Data;

@Entity
@Data
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
