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
@Table(name="components")
public class Components {

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private Integer componentId;
	
	@Column( nullable = false )
	private Integer sampleId;
	
	@Transient
	private String sampleName;
	
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
	
	@JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
	private LocalDateTime deliveryDate;
	
	@Column( nullable = false )
	private Integer materialId;
	
	@Transient
	private String materialName;
	
	@Column( nullable = true )
	private String statusResume;
	
	@Column( nullable = false )
	private String ulaLightEmployee;
	
	@Transient
	List<Tasks> taskList;
	
}
