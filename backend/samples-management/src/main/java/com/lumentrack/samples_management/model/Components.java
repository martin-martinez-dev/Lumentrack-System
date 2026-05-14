package com.lumentrack.samples_management.model;

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
@Table(name="components")
public class Components {

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private Integer componentId;
	
	@Column( nullable = false )
	private Integer sampleId;
	
	@Column( nullable = false )
	private String componentName;
	
	@Column( nullable = false )
	private String componentType;
	
	@Column( nullable = false )
	private String componentDescription;
	
	@Column( nullable = false )
	private String photoUrl;
	
	@Column( nullable = false )
	private String photoId;
	
	@Column( nullable = false )
	private Boolean isExternal;
	
	@JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
	private LocalDateTime deliveryDate;
	
	@Column( nullable = false )
	private Integer materialId;
	
	@Column( nullable = true )
	private String statusResume;
	
	@Column( nullable = false )
	private String ulaLightEmployee;
	
	@Column( nullable = false )
	private Integer taskId;
	
}
