package com.lumentrack.adminmanagement.model;

import jakarta.persistence.*;
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
