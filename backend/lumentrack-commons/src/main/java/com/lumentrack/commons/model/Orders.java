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
@Builder(toBuilder = true) // Te permite mapear y construir este objeto de forma fluida
@Table(name="orders")
public class Orders {

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private Integer orderId;
	
	@Column( nullable = false )
	private String orderNumber;
	
	@Column( nullable = false )
	private String orderName;
	
	@Column( nullable = false )
	private Integer clientId;
	
	@Transient
	private String clientName;
	
	@Column( nullable = false )
	@JsonFormat(pattern = "yyyy-MM-dd")
	private LocalDate estimatedDeliveryDate;
	
	@Column( nullable = true )
	@JsonFormat(pattern = "yyyy-MM-dd")
	private LocalDate realDeliveryDate;
	
	// Relación OneToMany con Samples
	// @JsonIgnore // ELIMINADO
	@OneToMany(mappedBy = "order", cascade = CascadeType.ALL, orphanRemoval = true)
	private List<Samples> samples; // Renombrado de sampleList a samples
	
}