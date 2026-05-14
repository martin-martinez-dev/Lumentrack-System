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

import com.lumentrack.samples_management.model.Samples;
import com.lumentrack.samples_management.service.SampleService;

@RestController
@RequestMapping("/samples")
@CrossOrigin(origins = "*")
public class SampleController {
	
	private final static Logger logger = LoggerFactory.getLogger(SampleController.class);
	
	@Autowired
	private SampleService sampleService;
	
	@PostMapping("/save")
	public ResponseEntity<Samples> saveSample( @RequestBody Samples sample ) {
		logger.info( "Start saving for sample: " + sample.getSampleName() );
		
		return new ResponseEntity<Samples>( sampleService.saveSample(sample), HttpStatus.CREATED );
	}
	
	@GetMapping("/list")
	public List<Samples> retrieveAllSamples() {
		logger.info( "Listing all samples" );
		
		return sampleService.getAllSamples();
	}
	
	@GetMapping("/search/{id}")
	public ResponseEntity<Samples> searchSampleById(@PathVariable("id") Integer id) {
		logger.info( "Search sample by id: " + id );
		
		return sampleService.getSampleById(id)
				.map(ResponseEntity::ok)
				.orElse(ResponseEntity.notFound().build());
	}
	
	@PostMapping("/update")
	public Samples updateSample(@RequestBody Samples sample) {
		logger.info( "Update for sample: " + sample.getSampleName() );
		
		return sampleService.updateSampleDeliveryDate(sample);
	}
	
	@DeleteMapping("/delete/{id}")
	@ResponseStatus(HttpStatus.NO_CONTENT)
	public void deleteSample(@PathVariable("id") Integer id) {
		logger.info( "Delete sample for id: " + id );
		
		sampleService.deleteSample(id);
	}
	
}