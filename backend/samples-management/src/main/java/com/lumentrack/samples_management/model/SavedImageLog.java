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
@Table(name="savedimagelog")
public class SavedImageLog {
	
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private Integer imageId;
	
	@Column( nullable = false )
	private String imageCloudinaryUrl;
	
	@Column( nullable = false )
	private String imageCloudinaryId;
	
	@Column( nullable = false )
	@JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
	private LocalDateTime savedDateTime;
	
	@Column( nullable = false )
	private String imageStatus;
	
}
