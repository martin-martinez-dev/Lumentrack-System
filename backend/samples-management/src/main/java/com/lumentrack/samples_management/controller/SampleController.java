package com.lumentrack.samples_management.controller;

import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;

import com.lumentrack.commons.model.Samples;
import com.lumentrack.samples_management.service.SampleService;
import com.lumentrack.samples_management.requestors.SampleRequest;
import com.lumentrack.samples_management.requestors.SampleDetailsResponse;

@RestController
@RequestMapping("/samples")
@CrossOrigin(origins = "*")
public class SampleController {
	
	private final static Logger logger = LoggerFactory.getLogger(SampleController.class);
	
	@Autowired
	private SampleService sampleService;
	
	@PostMapping("/save")
	public ResponseEntity<Samples> saveSample( @RequestBody SampleRequest sampleRequest ) {
		logger.info( "Start saving for sample: " + sampleRequest.getSampleName() );
		
	    Samples savedSample = sampleService.saveSample(sampleRequest);
		
	    return new ResponseEntity<>(savedSample, HttpStatus.CREATED);
	}
	
	@GetMapping("/list")
	public List<Samples> retrieveAllSamples() {
		logger.info( "Listing all samples" );
		
		return sampleService.getAllSamples();
	}

	@GetMapping("/list/user/{userId}")
	public List<Samples> retrieveSamplesByUserId(@PathVariable("userId") Integer userId) {
		logger.info("Listing samples for userId: " + userId);
		return sampleService.getSamplesByUserId(userId);
	}

	// NUEVO: Endpoint para listar detalles de muestras por userId
	@GetMapping("/list/details/user/{userId}")
	public List<SampleDetailsResponse> retrieveSampleDetailsByUserId(@PathVariable("userId") Integer userId) {
		logger.info("Listing sample details for userId: " + userId);
		return sampleService.getSampleDetailsByUserId(userId);
	}
	
	@GetMapping("/search/{id}")
	public ResponseEntity<Samples> searchSampleById(@PathVariable("id") Integer id) {
		logger.info( "Search sample by id: " + id );
		
		return sampleService.getSampleById(id)
				.map(ResponseEntity::ok)
				.orElse(ResponseEntity.notFound().build());
	}
	
	@PostMapping("/update")
	public Samples updateSample(@RequestBody SampleRequest sampleRequest) {
		logger.info( "Update for sample: " + sampleRequest.getSampleName() );
		
		logger.info("Executing for object: " + sampleRequest.toString() );
		
		return sampleService.updateSample(sampleRequest);
	}
	
	@DeleteMapping("/delete/{id}")
	@ResponseStatus(HttpStatus.NO_CONTENT)
	public void deleteSample(@PathVariable("id") Integer id) {
		logger.info( "Delete sample for id: " + id );
		
		sampleService.deleteSample(id);
	}
	
	@GetMapping("/getSamplesDetailsList")
	public List<SampleDetailsResponse> getSamplesDetailsList() {
		logger.info("Getting the Samples Details for the Samples View");
		
		return sampleService.getAllSampleDetails(); // Usar el nuevo método optimizado
	}
	
	@GetMapping("/getSampleDetails/{id}")
	public SampleDetailsResponse getSampleDetails( @PathVariable("id") Integer id ) {
		logger.info("Getting the Details of the Sample with id: " + id);
		return sampleService.getSampleDetailsById(id); // Usar el nuevo método optimizado
	}
	
}