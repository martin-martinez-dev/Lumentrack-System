package com.lumentrack.samples_management.controller;

import com.lumentrack.samples_management.model.CloudinaryResponse;
import com.lumentrack.samples_management.service.CloudinaryService;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MaxUploadSizeExceededException;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.Map;

@RestController
@RequestMapping("/images")
@CrossOrigin(origins = "*")
public class ImageController {
	
	private final static Logger logger = LoggerFactory.getLogger(ImageController.class);
	
	@Autowired
	CloudinaryService cloudinaryService;
	
//	@PostMapping("/upload")
//	public ResponseEntity<String> upload(@RequestParam("file") MultipartFile multipartFile) throws IOException {
//		try {
//	        String url = cloudinaryService.upload(multipartFile);
//	        return new ResponseEntity<>(url, HttpStatus.OK);
//		}catch (IOException e) {
//			return new ResponseEntity<>(e.getMessage(), HttpStatus.BAD_REQUEST);
//		}
//    }
	@PostMapping("/upload")
    public ResponseEntity<?> upload(@RequestParam("file") MultipartFile multipartFile,
    		@RequestParam(value = "folder", defaultValue = "general") String folder) {
		
		logger.info("Starting cloudinary upload process");
		
        try {
            CloudinaryResponse response = cloudinaryService.upload(multipartFile, "lumentrack/" + folder);
            return ResponseEntity.ok(response);
        } catch (IOException e) {
        	logger.info("There was an exception during the image upload process");
            return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                    .body(Map.of("error", e.getMessage()));
        }
    }
	
	@DeleteMapping("/delete/{id}")
    public ResponseEntity<?> delete(@PathVariable("id") String publicId) {
        try {
        	logger.info("Deleting image " + publicId);
            Map<?, ?> result = cloudinaryService.delete(publicId);
            
            // Cloudinary devuelve "not found" en el campo result si el ID no existe
            if ("ok".equals(result.get("result"))) {
            	logger.info("Image deleted successfully");
                return ResponseEntity.ok(Map.of("message", "Imagen eliminada con éxito"));
            } else {
            	logger.info("Image not found");
                return ResponseEntity.status(HttpStatus.NOT_FOUND)
                        .body(Map.of("error", "No se encontró el archivo con ID: " + publicId));
            }
        } catch (IOException e) {
        	logger.error("There was an error while trying to delete the image");
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(Map.of("error", "Error en la conexión con Cloudinary"));
        }
    }
	
	// Captura el error si el archivo es más grande de lo permitido en el YAML
    @ExceptionHandler(MaxUploadSizeExceededException.class)
    public ResponseEntity<String> handleMaxSizeException(MaxUploadSizeExceededException exc) {
    	logger.info("File is too big to being processed");
        return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                .body("El archivo es demasiado grande. El límite es de 5MB.");
    }
    
}
