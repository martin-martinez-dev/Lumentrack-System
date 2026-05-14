package com.lumentrack.dashboard_management.controller;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.lumentrack.dashboard_management.model.Dashboard;
import com.lumentrack.dashboard_management.service.DashboardService;

@RestController
@RequestMapping("/")
@CrossOrigin(origins = "*")
public class DashboardController {
	
	private final static Logger logger = LoggerFactory.getLogger(DashboardController.class);
	
	@Autowired
	DashboardService service;
	
	@GetMapping("/getData")
	public ResponseEntity<Dashboard> getDashboardData() {
		logger.info("Retrieving the Dashboard information");
		return ResponseEntity.ok(service.getDashboardData());
	}
	
}
