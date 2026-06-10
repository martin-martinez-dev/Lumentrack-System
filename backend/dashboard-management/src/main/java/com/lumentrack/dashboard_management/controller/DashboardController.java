package com.lumentrack.dashboard_management.controller;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.lumentrack.dashboard_management.model.Dashboard;
import com.lumentrack.dashboard_management.service.DashboardService;
import com.lumentrack.dashboard_management.service.DashboardUserFilteredService; // Nueva importación

@RestController
@RequestMapping("/")
@CrossOrigin(origins = "*")
public class DashboardController {
	
	private final static Logger logger = LoggerFactory.getLogger(DashboardController.class);
	
	private final DashboardService dashboardService; // Renombrado para mayor claridad
    private final DashboardUserFilteredService dashboardUserFilteredService; // Nueva dependencia

    @Autowired // Inyección por constructor
    public DashboardController(DashboardService dashboardService,
                               DashboardUserFilteredService dashboardUserFilteredService) {
        this.dashboardService = dashboardService;
        this.dashboardUserFilteredService = dashboardUserFilteredService;
    }
	
	@GetMapping("/getData")
	public ResponseEntity<Dashboard> getDashboardData() {
		logger.info("Retrieving the Dashboard information");
		return ResponseEntity.ok(dashboardService.getDashboardData());
	}

    /**
     * Endpoint para obtener los datos del Dashboard filtrados por un User específico.
     *
     * @param userId El ID del usuario para filtrar los datos del dashboard.
     * @return Un objeto Dashboard con los datos filtrados para el usuario.
     */
    @GetMapping("/getData/user/{userId}")
    public ResponseEntity<Dashboard> getDashboardDataForUser(@PathVariable Integer userId) {
        logger.info("Retrieving Dashboard information for user with ID: {}", userId);
        return ResponseEntity.ok(dashboardUserFilteredService.getDashboardDataForUser(userId));
    }
	
}