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
@Table(name="tasks")
public class Tasks {
	
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private Integer taskId;
	
	@Column( nullable = false )
	private String taskName;
	
	@Column( nullable = false )
	private String taskDescription;
	
	@Column( nullable = false )
	@JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
	private LocalDateTime taskEstimatedDate;
	
	@Column( nullable = true )
	@JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
	private LocalDateTime taskRealDateTime;
	
}
