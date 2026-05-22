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
import com.lumentrack.samples_management.model.Components;
import com.lumentrack.samples_management.model.Orders;
import com.lumentrack.samples_management.model.Samples;
import com.lumentrack.samples_management.repository.ComponentsRepository;
import com.lumentrack.samples_management.repository.OrdersRepository;
import com.lumentrack.samples_management.repository.SamplesRepository;

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
		List<Orders> allOrders = orderRepository.findAll();
		
		Map<Integer, Orders> ordersMap = allOrders.stream().collect(Collectors.toMap(Orders::getOrderId, order -> order));
		
		// Cruzamos los datos usando la potencia de Java Streams y el @Builder de Lombok
        return allSamples.stream().map(sample -> {
            // Buscamos si existe la orden correspondiente en el mapa
            Orders associatedOrder = ordersMap.get(sample.getOrderId());
            
            // Si la orden existe, extraemos el nombre; si no, manejamos un valor por defecto seguro
            String orderName = (associatedOrder != null) ? associatedOrder.getOrderName() : "Orden No Encontrada";

            // Construimos el ViewModel de forma fluida gracias a Lombok
            return Samples.builder()
                    .sampleId(sample.getSampleId())
                    .sampleName(sample.getSampleName())
                    .orderId(sample.getOrderId())
                    .orderName(orderName) // <--- Aquí inyectamos el cruce de datos
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
		
		Optional<Orders> order = orderRepository.findById( sample.getOrderId() );
		
		List<Components> componentList = componentsRepository.findBySampleId(sampleId);
		List<Components> safeComponents = ( componentList != null ) ? componentList : Collections.emptyList();
		
		return Samples.builder()
				.sampleId( sample.getSampleId() )
				.sampleName( sample.getSampleName() )
				.orderId( sample.getOrderId() )
				.orderName( order.get().getOrderName() )
				.samplePhotoUrl( sample.getSamplePhotoUrl() )
				.samplePhotoId( sample.getSamplePhotoId() )
				.estimatedDeliveryDate( sample.getEstimatedDeliveryDate() )
				.realDeliveryDate( sample.getRealDeliveryDate() )
				.componentList( safeComponents )
				.build();
		
	}
	
}
