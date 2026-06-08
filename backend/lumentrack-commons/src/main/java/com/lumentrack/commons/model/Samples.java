package com.lumentrack.commons.model;

import java.time.LocalDate;
import java.util.List;

import com.fasterxml.jackson.annotation.JsonFormat;
// import com.fasterxml.jackson.annotation.JsonIgnore; // Eliminado

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
@Table(name="samples")
public class Samples {
	
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private Integer sampleId;
	
	// Relación ManyToOne con Orders
	@ManyToOne
	@JoinColumn(name = "order_id", nullable = false) // Columna en la tabla 'samples' que referencia a 'orders'
	private Orders order;
	
	// Eliminado: @Transient private String orderName; (se accede via order.getOrderName())
	
	@Column( nullable = false )
	private String sampleName;
	
	@Column( nullable = false )
	private String samplePhotoUrl;
	
	@Column( nullable = false )
	private String samplePhotoId;
	
	@Column( nullable = false )
	@JsonFormat(pattern = "yyyy-MM-dd")
	private LocalDate estimatedDeliveryDate;
	
	@Column( nullable = true )
	@JsonFormat(pattern = "yyyy-MM-dd")
	private LocalDate realDeliveryDate;
	
	// Relación OneToMany con Components
	// @JsonIgnore // ELIMINADO
	@OneToMany(mappedBy = "sample", cascade = CascadeType.ALL, orphanRemoval = true)
	private List<Components> components; // Renombrado de componentList a components
}