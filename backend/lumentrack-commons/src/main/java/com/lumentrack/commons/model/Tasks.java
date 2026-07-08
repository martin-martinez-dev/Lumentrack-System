package com.lumentrack.commons.model;

import java.time.LocalDate;

import com.fasterxml.jackson.annotation.JsonFormat;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn; // Nueva importación
import jakarta.persistence.ManyToOne; // Nueva importación
import jakarta.persistence.Table;
import jakarta.persistence.Transient;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity
@Data
@NoArgsConstructor // Genera el constructor vacío obligatorio para Jackson
@AllArgsConstructor // Genera el constructor con todos los campos
@Builder // Te permite mapear y construir este objeto de forma fluida
@Table(name="tasks")
public class Tasks {
	
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private Integer taskId;
	
	@Column( nullable = false )
	private String taskName;
	
	@Column( nullable = false )
	private String taskDescription;
	
	// Relación ManyToOne con Components
	@ManyToOne
	@JoinColumn(name = "component_id", nullable = false) // Columna en la tabla 'tasks' que referencia a 'components'
	private Components component;
	
	// Eliminado: @Transient private String componentName; (se accede via component.getComponentName())
	
	@Column( nullable = false )
	private String taskPhotoUrl;
	
	@Column( nullable = false )
	private String taskPhotoId;
	
	@Column( nullable = false )
	@JsonFormat(pattern = "yyyy-MM-dd")
	private LocalDate taskEstimatedDate;
	
	@Column( nullable = true )
	@JsonFormat(pattern = "yyyy-MM-dd")
	private LocalDate taskRealDateTime;
	
}