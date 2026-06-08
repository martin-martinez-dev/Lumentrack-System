package com.lumentrack.samples_management.service;

import java.util.Collections;
import java.util.List;
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
import com.lumentrack.samples_management.requestors.SampleRequest;
import com.lumentrack.samples_management.requestors.SampleDetailsResponse;
import com.lumentrack.samples_management.requestors.ComponentDetailsResponse;

@Service
public class SampleService {
	
	private final static Logger logger = LoggerFactory.getLogger(SampleService.class);
	
	@Autowired
	private SamplesRepository repository;
	
	@Autowired
	private OrdersRepository orderRepository;
	
	@Autowired
	private ComponentsRepository componentsRepository;

	@Autowired
	private ComponentService componentService;
	
	@Transactional
	public Samples saveSample( SampleRequest sampleRequest ) {
		logger.info( "Saving sample on service: " + sampleRequest.getSampleName() );
		
		Orders order = orderRepository.findById(sampleRequest.getOrderId())
				.orElseThrow(() -> new ResourceNotFoundException("Orden no encontrada con id: " + sampleRequest.getOrderId()));
		
		Samples sample = Samples.builder()
				.sampleName(sampleRequest.getSampleName())
				.order(order)
				.samplePhotoUrl(sampleRequest.getSamplePhotoUrl())
				.samplePhotoId(sampleRequest.getSamplePhotoId())
				.estimatedDeliveryDate(sampleRequest.getEstimatedDeliveryDate())
				.realDeliveryDate(sampleRequest.getRealDeliveryDate())
				.build();
		
		return repository.save(sample);
	}
	
	public List<Samples> getAllSamples() {
		logger.info( "Getting all the samples" );
		
		return repository.findAll();
	}
	
	public List<Samples> getSamplesByUserId(Integer userId) {
		logger.info("Retrieving samples for userId: " + userId);
		return repository.findByComponentsUserId(userId);
	}
	
	public Optional<Samples> getSampleById(Integer id) {
		logger.info( "Get a single sample by id: " + id );
		
		return repository.findById(id);
	}
	
	@Transactional
	public Samples updateSample(SampleRequest sampleRequest) {
		logger.info( "Updating information for the sample: " + sampleRequest.getSampleName() );
		
		return repository.findById(sampleRequest.getSampleId()).map(sample -> {
			sample.setSampleName( sampleRequest.getSampleName() );
			sample.setSamplePhotoId( sampleRequest.getSamplePhotoId() );
			sample.setSamplePhotoUrl( sampleRequest.getSamplePhotoUrl() );
			sample.setEstimatedDeliveryDate(sampleRequest.getEstimatedDeliveryDate());
			sample.setRealDeliveryDate( sampleRequest.getRealDeliveryDate() );
			
			if (!sample.getOrder().getOrderId().equals(sampleRequest.getOrderId())) {
				Orders newOrder = orderRepository.findById(sampleRequest.getOrderId())
						.orElseThrow(() -> new ResourceNotFoundException("Orden no encontrada con id: " + sampleRequest.getOrderId()));
				sample.setOrder(newOrder);
			}
			
			return repository.save( sample );
		}).orElseThrow( () -> new ResourceNotFoundException("Muestra no encontrada con id: " + sampleRequest.getSampleId()) );
	}
	
	public void deleteSample( Integer id ) {
		Samples sample = repository.findById(id).orElseThrow(() -> new ResourceNotFoundException("Muestra no encontrada con id: " + id));
		
		logger.info( "Sample with id: " + id + " has been found!" );
		logger.info( "Deleting information for sample: " + sample.getSampleName() );
		repository.deleteById( sample.getSampleId() );
	}
	
	// NUEVO: Método para obtener todas las muestras con detalles (eagerly fetched)
	public List<SampleDetailsResponse> getAllSampleDetails() {
		logger.info("Getting all Samples Details (eagerly fetched)");
		List<Samples> allSamples = repository.findAllWithOrderAndComponents();
        return allSamples.stream()
				.map(this::mapSampleToSampleDetailsResponse)
				.collect(Collectors.toList());
	}
	
	// NUEVO: Método para obtener los detalles de una muestra por ID (eagerly fetched)
	public SampleDetailsResponse getSampleDetailsById( Integer sampleId ) {
		logger.info("Starting the service for the extraction of the Sample Details by ID (eagerly fetched)");
		Samples sample = repository.findByIdWithOrderAndComponents(sampleId)
				.orElseThrow(() -> new ResourceNotFoundException(
                "La muestra con id " + sampleId + " no existe."
            ));
		return mapSampleToSampleDetailsResponse(sample);
	}

	// NUEVO: Método para obtener los detalles de muestras filtradas por userId (eagerly fetched)
	public List<SampleDetailsResponse> getSampleDetailsByUserId(Integer userId) {
		logger.info("Retrieving Samples Details for userId: " + userId + " (eagerly fetched)");
		List<Samples> samples = repository.findByComponentsUserIdWithOrderAndComponents(userId);
		return samples.stream()
				.map(this::mapSampleToSampleDetailsResponse)
				.collect(Collectors.toList());
	}

	// Cambiado de private a public para que OrderService pueda acceder a él
	public SampleDetailsResponse mapSampleToSampleDetailsResponse(Samples sample) {
		Orders associatedOrder = sample.getOrder();
		List<Components> sampleComponents = sample.getComponents();

		List<ComponentDetailsResponse> safeComponents = (sampleComponents != null) ?
				sampleComponents.stream()
						.map(componentService::mapComponentToComponentDetailsResponse) // Delegar el mapeo de Componentes
						.collect(Collectors.toList()) :
				Collections.emptyList();

		return SampleDetailsResponse.builder()
				.sampleId(sample.getSampleId())
				.sampleName(sample.getSampleName())
				.orderId(associatedOrder != null ? associatedOrder.getOrderId() : null)
				.orderName(associatedOrder != null ? associatedOrder.getOrderName() : null)
				.samplePhotoUrl(sample.getSamplePhotoUrl())
				.samplePhotoId(sample.getSamplePhotoId())
				.estimatedDeliveryDate(sample.getEstimatedDeliveryDate())
				.realDeliveryDate(sample.getRealDeliveryDate())
				.components(safeComponents)
				.build();
	}
	
}