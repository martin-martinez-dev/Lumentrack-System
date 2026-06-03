package com.lumentrack.commons.model;

import java.time.LocalDate;
import java.util.List;

import com.fasterxml.jackson.annotation.JsonFormat;

import jakarta.persistence.CascadeType; // Nueva importación
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn; // Nueva importación
import jakarta.persistence.ManyToOne; // Nueva importación
import jakarta.persistence.OneToMany; // Nueva importación
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
@Table(name="components")
public class Components {

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private Integer componentId;

	// Relación ManyToOne con Samples
	@ManyToOne
	@JoinColumn(name = "sample_id", nullable = false) // Columna en la tabla 'components' que referencia a 'samples'
	private Samples sample;

	// Eliminado: @Transient private String sampleName; (se accede via sample.getSampleName())

	@Column( nullable = false )
	private String componentName;

	@Column( nullable = false )
	private String componentType;

	@Column( nullable = false )
	private String componentDescription;

	@Column( nullable = false )
	private String componentPhotoUrl;

	@Column( nullable = false )
	private String componentPhotoId;

	@Column( nullable = false )
	private Boolean isExternal;

	@JsonFormat(pattern = "yyyy-MM-dd")
	private LocalDate deliveryDate;

	@Column( nullable = false )
	private Integer materialId;

	@Transient
	private String materialName;

	@Column( nullable = true )
	private String statusResume;

	@Column( nullable = false )
	private String ulaLightEmployee;

	@Column( nullable = true )
	private Integer userId;

	// Relación OneToMany con Tasks
	@OneToMany(mappedBy = "component", cascade = CascadeType.ALL, orphanRemoval = true)
	private List<Tasks> tasks; // Renombrado de taskList a tasks

}