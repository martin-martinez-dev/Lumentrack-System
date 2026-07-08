package com.lumentrack.samples_management.service;

import com.lumentrack.commons.model.Components;
import com.lumentrack.commons.model.Orders;
import com.lumentrack.commons.model.Samples;
import com.lumentrack.commons.model.Tasks;
import com.lumentrack.commons.repository.ComponentsRepository;
import com.lumentrack.commons.repository.OrdersRepository;
import com.lumentrack.commons.repository.SamplesRepository;
import com.lumentrack.commons.repository.TasksRepository;
import com.lumentrack.samples_management.requestors.ComponentDetailsResponse;
import com.lumentrack.samples_management.requestors.OrderDetailsResponse;
import com.lumentrack.samples_management.requestors.SampleDetailsResponse;
import com.lumentrack.samples_management.requestors.TaskDetailsResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.stream.Collectors;

@Service
public class UserFilteredDataService {

    private final OrdersRepository ordersRepository;
    private final SamplesRepository samplesRepository;
    private final ComponentsRepository componentsRepository;
    private final TasksRepository tasksRepository;

    @Autowired
    public UserFilteredDataService(OrdersRepository ordersRepository,
                                   SamplesRepository samplesRepository,
                                   ComponentsRepository componentsRepository,
                                   TasksRepository tasksRepository) {
        this.ordersRepository = ordersRepository;
        this.samplesRepository = samplesRepository;
        this.componentsRepository = componentsRepository;
        this.tasksRepository = tasksRepository;
    }

    /**
     * Carga los Orders que estén relacionados con un User específico.
     * Un Order está relacionado si al menos uno de sus Components está asociado al userId.
     *
     * @param userId El ID del usuario.
     * @return Una lista de Orders relacionados con el usuario.
     */
    public List<Orders> getOrdersRelatedToUser(Integer userId) {
        return ordersRepository.findByComponentsUserId(userId);
    }

    /**
     * Carga los Samples relacionados a los Orders de un usuario,
     * pero solo los Samples que tienen Components relacionados al User.
     *
     * @param userId El ID del usuario.
     * @return Una lista de Samples filtrados por usuario y sus Orders.
     */
    public List<Samples> getSamplesForUserOrders(Integer userId) {
        return samplesRepository.findByComponentsUserId(userId);
    }

    /**
     * Carga los Components que están relacionados con un User específico.
     *
     * @param userId El ID del usuario.
     * @return Una lista de Components relacionados con el usuario.
     */
    public List<Components> getComponentsForUser(Integer userId) {
        return componentsRepository.findByUserId(userId);
    }

    /**
     * Carga los Tasks relacionados a los Components, pero solo de los Components relacionados al User.
     *
     * @param userId El ID del usuario.
     * @return Una lista de Tasks relacionadas con los Components del usuario.
     */
    public List<Tasks> getTasksForUserComponents(Integer userId) {
        return tasksRepository.findByComponentsUserIdWithComponent(userId); // CAMBIADO: Nombre del método
    }

    /**
     * Método combinado para obtener Orders con sus Samples, Components y Tasks
     * filtrados para que solo incluyan aquellos relacionados con un User específico,
     * utilizando DTOs para evitar el problema N+1 y proporcionar una estructura de respuesta limpia.
     *
     * @param userId El ID del usuario.
     * @return Una lista de OrderDetailsResponse, con sus colecciones anidadas filtradas por el usuario.
     */
    public List<OrderDetailsResponse> getOrdersWithFilteredDetailsForUser(Integer userId) {
        // Obtener todos los Orders que tienen al menos un Component asociado al userId.
        // Es crucial que esta consulta o las subsiguientes utilicen FETCH JOINs
        // para cargar Samples, Components y Tasks de forma eficiente y evitar N+1.
        // Por ejemplo, ordersRepository.findByComponentsUserIdWithDetails(userId) si se adapta para DTOs.
        List<Orders> orders = ordersRepository.findByComponentsUserId(userId);

        if (orders == null || orders.isEmpty()) {
            return Collections.emptyList();
        }

        return orders.stream()
                .map(order -> {
                    List<SampleDetailsResponse> filteredSampleDetails = order.getSamples().stream()
                            .filter(sample -> sample.getComponents() != null && sample.getComponents().stream()
                                    .anyMatch(component -> userId.equals(component.getUserId())))
                            .map(sample -> {
                                List<ComponentDetailsResponse> filteredComponentDetails = sample.getComponents().stream()
                                        .filter(component -> userId.equals(component.getUserId()))
                                        .map(component -> {
                                            List<TaskDetailsResponse> taskDetails = component.getTasks().stream()
                                                    .map(task -> TaskDetailsResponse.builder()
                                                            .taskId(task.getTaskId())
                                                            .taskName(task.getTaskName())
                                                            .taskDescription(task.getTaskDescription())
                                                            .taskPhotoUrl(task.getTaskPhotoUrl())
                                                            .taskPhotoId(task.getTaskPhotoId())
                                                            .taskEstimatedDate(task.getTaskEstimatedDate())
                                                            .taskRealDateTime(task.getTaskRealDateTime())
                                                            .componentId(component.getComponentId())
                                                            .componentName(component.getComponentName())
                                                            .build())
                                                    .collect(Collectors.toList());

                                            return ComponentDetailsResponse.builder()
                                                    .componentId(component.getComponentId())
                                                    .componentName(component.getComponentName())
                                                    .componentType(component.getComponentType())
                                                    .componentDescription(component.getComponentDescription())
                                                    .componentPhotoUrl(component.getComponentPhotoUrl())
                                                    .componentPhotoId(component.getComponentPhotoId())
                                                    .isExternal(component.getIsExternal())
                                                    .deliveryDate(component.getDeliveryDate())
                                                    .materialId(component.getMaterialId())
                                                    .materialName(component.getMaterialName())
                                                    .statusResume(component.getStatusResume())
                                                    .ulaLightEmployee(component.getUlaLightEmployee())
                                                    .userId(component.getUserId())
                                                    .sampleId(sample.getSampleId())
                                                    .sampleName(sample.getSampleName())
                                                    .tasks(taskDetails)
                                                    .build();
                                        })
                                        .collect(Collectors.toList());

                                return SampleDetailsResponse.builder()
                                        .sampleId(sample.getSampleId())
                                        .sampleName(sample.getSampleName())
                                        .samplePhotoUrl(sample.getSamplePhotoUrl())
                                        .samplePhotoId(sample.getSamplePhotoId())
                                        .estimatedDeliveryDate(sample.getEstimatedDeliveryDate())
                                        .realDeliveryDate(sample.getRealDeliveryDate())
                                        .orderId(order.getOrderId())
                                        .orderName(order.getOrderName())
                                        .components(filteredComponentDetails)
                                        .build();
                            })
                            .collect(Collectors.toList());

                    return OrderDetailsResponse.builder()
                            .orderId(order.getOrderId())
                            .orderNumber(order.getOrderNumber())
                            .orderName(order.getOrderName())
                            .clientId(order.getClientId())
                            .clientName(order.getClientName())
                            .estimatedDeliveryDate(order.getEstimatedDeliveryDate())
                            .realDeliveryDate(order.getRealDeliveryDate())
                            .samples(filteredSampleDetails)
                            .build();
                })
                .collect(Collectors.toList());
    }
}