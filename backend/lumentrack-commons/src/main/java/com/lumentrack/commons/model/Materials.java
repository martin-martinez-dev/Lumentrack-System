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
@Table(name="materials")
public class Materials {
	
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private Integer materialId;
	
	@Column( nullable = false )
	private String materialName;
	
}