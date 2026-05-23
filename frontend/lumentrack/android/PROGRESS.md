# Lumentrack - Estado del Desarrollo (Fase Alpha)

**Progreso Actual:** 80%
**Última Actualización:** Mayo 2024

## ✅ Implementado
- **Servicios Base:** `UsersService`, `MaterialService`, `OrdersService`, `SamplesService`, `ImagesService` (Cloudinary).
- **Modelos:** Estructura completa de `Client`, `Order`, `UserItem`, `Sample` y `Material`.
- **UI de Órdenes:** 
    - `OrderFormScreen`: Creación y edición preservando listas de muestras.
    - `OrderDetailScreen`: Vista detallada con selector de clientes (ComboBox) y lista de luminarias.
- **Core:** Configuración centralizada de API (`ApiConfig`).
- **Flexibilidad de Datos:** Migración exitosa de `orderNumber` de `int` a `String` para soportar folios alfanuméricos.

## 🛠️ En Proceso (El 20% Restante)
- [x] **Módulo de Administración:** Gestión de Clientes y Usuarios finalizada. Sincronización de "Representante de Ula" con catálogo de usuarios activa.
- [ ] **Manejo de Errores Global:** Implementar interceptores HTTP para gestionar sesiones y errores de red de forma uniforme.
- [ ] **Gestión de Estado:** Migrar de `setState` a un patrón más robusto (Provider/Riverpod) para escalabilidad.
- [ ] **Validaciones Avanzadas:** Pulido de UX en formularios de creación de muestras.
- [ ] **Pruebas:** Añadir Unit Tests a los servicios críticos.

## 📌 Notas de Arquitectura
- La comunicación con el backend (Spring Boot) está segmentada por puertos (8081, 8082, 8083).
- Terminología: Se actualizó el término "Modelos" por "Muestras" en el menú principal para mayor claridad con el cliente final.
- Se prioriza la integridad de datos relacionales al editar órdenes, asegurando que `sampleList` no se pierda en los PUT/POST.
- **Hito Alpha:** Pruebas de función con el cliente final superadas con éxito.