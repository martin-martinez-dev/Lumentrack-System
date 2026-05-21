package com.lumentrack.samples_management.model;

import java.time.LocalDateTime;
import java.util.List;

import com.fasterxml.jackson.annotation.JsonFormat;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
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
@Table(name="orders")
public class Orders {

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private Integer orderId;
	
	@Column( nullable = false )
	private Integer orderNumber;
	
	@Column( nullable = false )
	private String orderName;
	
	@Column( nullable = false )
	private Integer clientId;
	
	@Transient
	private String clientName;
	
	@Column( nullable = false )
	@JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
	private LocalDateTime estimatedDeliveryDate;
	
	@Column( nullable = true )
	@JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
	private LocalDateTime realDeliveryDate;
	
	@Transient
	private List<Samples> sampleList;
	
}
