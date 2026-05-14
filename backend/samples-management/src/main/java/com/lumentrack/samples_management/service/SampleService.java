package com.lumentrack.samples_management.service;

import java.util.List;
import java.util.Optional;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.lumentrack.samples_management.model.Samples;
import com.lumentrack.samples_management.repository.SamplesRepository;

@Service
public class SampleService {
	
	// La clase Service es la que se debe de encargar de la lógica del negocio
	
	private final static Logger logger = LoggerFactory.getLogger(SampleService.class);
	
	@Autowired
	private SamplesRepository repository;
	
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
	
	public Samples updateSampleDeliveryDate(Samples updatedSample) {
		logger.info( "Updating information for the sample: " + updatedSample.getSampleName() );
		
		return repository.findById(updatedSample.getSampleId()).map(sample -> {
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
	
}
