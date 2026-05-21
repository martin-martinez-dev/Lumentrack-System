package com.lumentrack.samples_management.service;

import com.cloudinary.Cloudinary;
import com.cloudinary.Transformation;
import com.cloudinary.utils.ObjectUtils;
import com.lumentrack.samples_management.model.CloudinaryResponse;
import com.lumentrack.samples_management.model.SavedImageLog;
import com.lumentrack.samples_management.repository.SavedImageLogRepository;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.nio.file.Files;
import java.time.LocalDateTime;
import java.util.Arrays;
import java.util.List;
import java.util.Map;
import java.util.Objects;

@Service
public class CloudinaryService {
	
	private final static Logger logger = LoggerFactory.getLogger(CloudinaryService.class);
	
	private final List<String> ALLOWED_EXTENSIONS = Arrays.asList("jpg", "jpeg", "png", "webp");
	
	@Autowired
	SavedImageLogRepository imageRepository;
	
	private final Cloudinary cloudinary;
	
    public CloudinaryService(Cloudinary cloudinary) {
        this.cloudinary = cloudinary;
    }
    
    public CloudinaryResponse upload(MultipartFile multipartFile, String folder) throws IOException {
    	logger.info("Cloudinary upload service executing...");
    	
        String fileName = Objects.requireNonNull(multipartFile.getOriginalFilename());
        String extension = fileName.substring(fileName.lastIndexOf(".") + 1).toLowerCase();
        
        if (!ALLOWED_EXTENSIONS.contains(extension)) {
        	logger.error("The extension " + extension + " is not allowed in this process");
            throw new IOException("Extensión no permitida: " + extension);
        }

        File file = convert(multipartFile);
        try {
        	logger.info("Preparing image for upload to folder: " + folder);
        	
            Map<?, ?> params = ObjectUtils.asMap(
            	"folder", folder, //Carpeta de destino
                "transformation", new Transformation<>()
                    .width(1200)
                    .height(1200)
                    .crop("limit")
                    .quality("auto")
                    .fetchFormat("webp")
            );

            logger.info("Image has been prepared for upload");
            
            Map<?, ?> result = cloudinary.uploader().upload(file, params);
            
            logger.info("The image has been uploaded to: " + result.get("public_id").toString() );
            
            //Tomamos los valores para guardarlos en la bitacora de imagenes
            SavedImageLog imageLog = new SavedImageLog();
            imageLog.setImageCloudinaryUrl(result.get("secure_url").toString());
            imageLog.setImageCloudinaryId(result.get("public_id").toString());
            imageLog.setSavedDateTime( LocalDateTime.now() );
            imageLog.setImageStatus("Saved");
            
            imageRepository.save(imageLog);
            
            // Retornamos el objeto con ambos valores
            return new CloudinaryResponse(
                result.get("secure_url").toString(),
                result.get("public_id").toString()
            );
        } finally {
            if (file.exists()) Files.delete(file.toPath());
        }
    }
    
    // NUEVO MÉTODO: Eliminar imagen
    public Map<?, ?> delete(String publicId) throws IOException {
        // Cloudinary devuelve un mapa con el resultado (ej: {result=ok})
    	logger.info("Executing delete image service");
    	
    	// Eliminamos la imagen de cloudinary pero guardamos en bitacora la eliminación
    	imageRepository.findByImageCloudinaryId(publicId).map( savedImageLog -> {
    		savedImageLog.setImageStatus("Deleted");
    		return imageRepository.save(savedImageLog);
    	}).orElseThrow( () -> new RuntimeException("Cloudinary Image not found") );
    	
        return cloudinary.uploader().destroy(publicId, ObjectUtils.emptyMap());
    }
    
    private File convert(MultipartFile multipartFile) throws IOException {
    	logger.info("Prearing image for convertion");
        File file = new File(Objects.requireNonNull(multipartFile.getOriginalFilename()));
        try (FileOutputStream fo = new FileOutputStream(file)) {
        	logger.info("Image is being converted");
            fo.write(multipartFile.getBytes());
            logger.info("Image has been converted");
        }
        return file;
    }
	
}
