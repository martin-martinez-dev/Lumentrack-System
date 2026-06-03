package com.lumentrack.dashboard_management;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.persistence.autoconfigure.EntityScan;
import org.springframework.data.jpa.repository.config.EnableJpaRepositories; // Nueva importación

@SpringBootApplication
@EntityScan("com.lumentrack.commons.model") // Añadido: Escanear entidades en el paquete commons
@EnableJpaRepositories("com.lumentrack.commons.repository") // Añadido: Habilitar repositorios JPA en el paquete commons
public class DashboardManagementApplication {

	public static final Logger logger = LoggerFactory.getLogger(DashboardManagementApplication.class);
	
	public static void main(String[] args) {
		System.out.println("   __                           _____                _    ");
		System.out.println("  / / _   _ _ __ ___   ___ _ __/__   \\_ __ __ _  ___| | __");
		System.out.println(" / / | | | | '_ ` _ \\ / _ \\ '_ \\ / /\\/ '__/ _` |/ __| |/ /");
		System.out.println("/ /__| |_| | | | | | |  __/ | | / /  | | | (_| | (__|   < ");
		System.out.println("\\____/\\__,_|_| |_| |_|\\___|_| |_\\/   |_|  \\__,_|\\___|_|\\_\\");
		System.out.println("                                                          ");
		System.out.println("                    Dashboard  Service                    ");
		System.out.println("                       __                                 ");
		System.out.println("                      / _| ___  _ __                      ");
		System.out.println("                     | |_ / _ \\| '__|                     ");
		System.out.println("                     |  _| (_) | |                        ");
		System.out.println("                     |_|  \\___/|_|                        ");
		System.out.println("                                                          ");
		System.out.println("                            _                             ");
		System.out.println("                      _   _| | __ _                       ");
		System.out.println("                     | | | | |/ _` |                      ");
		System.out.println("                     | |_| | | (_| |                      ");
		System.out.println("                      \\__,_|_|\\__,_|                      ");
		System.out.println("                                                          ");
		System.out.println("                                                          ");
		System.out.println("                Powered by ZBK Development                ");
		
		SpringApplication.run(DashboardManagementApplication.class, args);
	}
	
}