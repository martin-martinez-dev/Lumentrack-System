package com.lumentrack.dashboard_management.model;

import java.time.LocalDateTime;

import com.fasterxml.jackson.annotation.JsonFormat;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.Data;

@Entity
@Data
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
	
	@Column( nullable = false )
	@JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
	private LocalDateTime estimatedDeliveryDate;
	
	@Column( nullable = true )
	@JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
	private LocalDateTime realDeliveryDate;
	
}
