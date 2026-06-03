package com.lumentrack.samples_management.service;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.stream.Collectors;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.lumentrack.samples_management.exception.ResourceNotFoundException;
import com.lumentrack.commons.model.Components;
import com.lumentrack.commons.model.Orders;
import com.lumentrack.commons.model.Samples;
import com.lumentrack.commons.repository.ComponentsRepository;
import com.lumentrack.commons.repository.OrdersRepository;
import com.lumentrack.commons.repository.SamplesRepository;

@Service
public class SampleService {
	
	// La clase Service es la que se debe de encargar de la lógica del negocio
	
	private final static Logger logger = LoggerFactory.getLogger(SampleService.class);
	
	@Autowired
	private SamplesRepository repository;
	
	@Autowired
	private OrdersRepository orderRepository;
	
	@Autowired
	private ComponentsRepository componentsRepository;
	
	public Samples saveSample( Samples sample ) {
		logger.info( "Saving sample on service: " + sample.getSampleName() );
		
		return repository.save(sample);
	}
	
	public List<Samples> getAllSamples() {
		logger.info( "Getting all the samples" );
		
		return repository.findAll();
	}
	
	// Nuevo método para obtener muestras por userId de sus componentes
	public List<Samples> getSamplesByUserId(Integer userId) {
		logger.info("Retrieving samples for userId: " + userId);
		return repository.findByComponentsUserId(userId);
	}
	
	public Optional<Samples> getSampleById(Integer id) {
		logger.info( "Get a single sample by id: " + id );
		
		return repository.findById(id);
	}
	
	@Transactional
	public Samples updateSampleDeliveryDate(Samples updatedSample) {
		logger.info( "Updating information for the sample: " + updatedSample.getSampleName() );
		
		return repository.findById(updatedSample.getSampleId()).map(sample -> {
			sample.setSampleName( updatedSample.getSampleName() );
			sample.setSamplePhotoId( updatedSample.getSamplePhotoId() );
			sample.setSamplePhotoUrl( updatedSample.getSamplePhotoUrl() );
			sample.setRealDeliveryDate( updatedSample.getRealDeliveryDate() );
			// Asegúrate de actualizar también la relación con Order si es parte de la actualización
			// sample.setOrder(updatedSample.getOrder()); 
			return repository.save( sample );
		}).orElseThrow( () -> new RuntimeException("Muestra no encontrada") );
	}
	
	public void deleteSample( Integer id ) {
		// Verifying that the Sample exists
		Samples sample = repository.findById(id).orElseThrow(() -> new RuntimeException("Muestra no encontrada con id: " + id));
		
		logger.info( "Sample with id: " + id + " has been found!" );
		logger.info( "Deleting information for sample: " + sample.getSampleName() );
		repository.deleteById( sample.getSampleId() );
	}
	
	public List<Samples> getSampleDetailsList() {
		logger.info("Getting the Samples Details");
		
		List<Samples> allSamples = repository.findAll();
		
		// Ahora que Samples tiene una relación ManyToOne con Orders, podemos acceder directamente
        return allSamples.stream().map(sample -> {
            Orders associatedOrder = sample.getOrder(); // Acceder directamente a la relación
            
            String orderName = (associatedOrder != null) ? associatedOrder.getOrderName() : "Orden No Encontrada";

            return Samples.builder()
                    .sampleId(sample.getSampleId())
                    .sampleName(sample.getSampleName())
                    .order(sample.getOrder()) // Usar la entidad completa
                    //.orderName(orderName) // <--- Aquí inyectamos el cruce de datos
                    .samplePhotoUrl(sample.getSamplePhotoUrl())
                    .samplePhotoId(sample.getSamplePhotoId())
                    .estimatedDeliveryDate(sample.getEstimatedDeliveryDate())
                    .realDeliveryDate(sample.getRealDeliveryDate())
                    .build();
        }).collect(Collectors.toList());
		
	}
	
	public Samples getSampleDetails( Integer sampleId ) {
		logger.info("Starting the service for the extraction of the Sample Details");
		Samples sample = repository.findById(sampleId).orElseThrow(() -> new ResourceNotFoundException(
                "La muestra con id " + sampleId + " no existe."
            ));
		
		// Acceder directamente a la relación Order
		Orders order = sample.getOrder();
		
		// Acceder directamente a la relación Components
		List<Components> componentList = sample.getComponents();
		List<Components> safeComponents = ( componentList != null ) ? componentList : Collections.emptyList();
		
		return Samples.builder()
				.sampleId( sample.getSampleId() )
				.sampleName( sample.getSampleName() )
				.order(sample.getOrder()) // Usar la entidad completa
				//.orderName( order != null ? order.getOrderName() : null ) // Acceder al nombre a través de la relación
				.samplePhotoUrl( sample.getSamplePhotoUrl() )
				.samplePhotoId( sample.getSamplePhotoId() )
				.estimatedDeliveryDate( sample.getEstimatedDeliveryDate() )
				.realDeliveryDate( sample.getRealDeliveryDate() )
				.components( safeComponents ) // Usar la lista de componentes de la relación
				.build();
		
	}
	
}