package com.lumentrack.adminmanagement.model;

import jakarta.persistence.*;
import lombok.Data;

@Entity
@Data
@Table(name="materials")
public class Materials {
	
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private Integer materialId;
	
	@Column( nullable = false )
	private String materialName;
	
}
