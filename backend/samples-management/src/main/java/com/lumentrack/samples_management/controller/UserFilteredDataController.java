package com.lumentrack.samples_management.controller;

import com.lumentrack.commons.model.Components;
import com.lumentrack.commons.model.Samples;
import com.lumentrack.commons.model.Tasks;
import com.lumentrack.samples_management.requestors.OrderDetailsResponse;
import com.lumentrack.samples_management.service.UserFilteredDataService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/user-filtered-data")
@CrossOrigin(origins = "*")
public class UserFilteredDataController {

    private final UserFilteredDataService userFilteredDataService;

    @Autowired
    public UserFilteredDataController(UserFilteredDataService userFilteredDataService) {
        this.userFilteredDataService = userFilteredDataService;
    }

    /**
     * Endpoint para obtener Orders con sus Samples, Components y Tasks
     * filtrados por un User específico.
     *
     * @param userId El ID del usuario para filtrar los datos.
     * @return Una lista de OrderDetailsResponse con los datos filtrados.
     */
    @GetMapping("/orders/{userId}")
    @PreAuthorize("hasAnyAuthority('DESIGN')")
    public ResponseEntity<List<OrderDetailsResponse>> getFilteredOrdersForUser(@PathVariable Integer userId) {
        List<OrderDetailsResponse> filteredOrders = userFilteredDataService.getOrdersWithFilteredDetailsForUser(userId);
        if (filteredOrders.isEmpty()) {
            return ResponseEntity.noContent().build();
        }
        return ResponseEntity.ok(filteredOrders);
    }

    @GetMapping("/samples/{userId}")
    @PreAuthorize("hasAnyAuthority('DESIGN')")
    public ResponseEntity<List<Samples>> getFilteredSamplesForUser(@PathVariable Integer userId) {
        List<Samples> filteredSamples = userFilteredDataService.getSamplesForUserOrders(userId);
        if (filteredSamples.isEmpty()) {
            return ResponseEntity.noContent().build();
        }
        return ResponseEntity.ok(filteredSamples);
    }

    @GetMapping("/components/{userId}")
    @PreAuthorize("hasAnyAuthority('DESIGN')")
    public ResponseEntity<List<Components>> getFilteredComponentsForUser(@PathVariable Integer userId) {
        List<Components> filteredComponents = userFilteredDataService.getComponentsForUser(userId);
        if (filteredComponents.isEmpty()) {
            return ResponseEntity.noContent().build();
        }
        return ResponseEntity.ok(filteredComponents);
    }

    @GetMapping("/tasks/{userId}")
    @PreAuthorize("hasAnyAuthority('DESIGN')")
    public ResponseEntity<List<Tasks>> getFilteredTasksForUser(@PathVariable Integer userId) {
        List<Tasks> filteredTasks = userFilteredDataService.getTasksForUserComponents(userId);
        if (filteredTasks.isEmpty()) {
            return ResponseEntity.noContent().build();
        }
        return ResponseEntity.ok(filteredTasks);
    }
}
