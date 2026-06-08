# Lumentrack - Estado del Desarrollo (Fase Alpha)

**Progreso Actual:** 85%
**Última Actualización:** 26 de Mayo, 2026 (CDMX)
*   **AppBar Dinámico en MainWrapper:** El color del título y fondo de "Lumentrack" ahora cambia reactivamente según la pestaña seleccionada (Terracota para Proyectos, Verde para Muestras, Verde Pastel para Admin).
*   **Gestión de Roles Robusta:** Implementado catálogo de roles con validaciones técnicas estrictas (Mayúsculas/Guiones bajos) y sincronización dinámica con el formulario de usuarios.
*   **Auto-registro de Usuarios:** Implementada pantalla de registro con creación de contraseña y asignación automática silenciosa del rol `ROLE_NONE` (ID: 6) para nuevos usuarios.

## ✅ Implementado
- **Servicios Base:** `UsersService`, `MaterialService`, `OrdersService`, `SamplesService`, `ImagesService` (Cloudinary).
- **Modelos:** Estructura completa de `Client`, `Order`, `UserItem`, `Sample`, `Material` y `RoleItem`.
- **UI de Órdenes:** 
    - `OrderFormScreen`: Creación y edición preservando listas de muestras.
    - `OrderDetailScreen`: Vista detallada con selector de clientes (ComboBox) y lista de luminarias.
- **Core:** Configuración centralizada de API (`ApiConfig`).
- **Flexibilidad de Datos:** Migración exitosa de `orderNumber` de `int` a `String` para soportar folios alfanuméricos.
- **Módulo de Registro:** Pantalla de alta autónoma funcional con validación de campos y soporte para contraseñas en el modelo `UserItem`.

## 🛠️ En Proceso (El 20% Restante)
- [x] **Módulo de Administración:** Gestión de Clientes, Usuarios y Roles finalizada. Sincronización de IDs relacionales activa.
- [x] **Módulo de Administración:** Gestión de Clientes y Usuarios finalizada. Sincronización de "Representante de Ula" con catálogo de usuarios activa.
- [ ] **Manejo de Errores Global:** Implementar interceptores HTTP para gestionar sesiones y errores de red de forma uniforme.
- [ ] **Gestión de Estado:** Migrar de `setState` a un patrón más robusto (Provider/Riverpod) para escalabilidad.
- [ ] **Validaciones Avanzadas:** Pulido de UX en formularios de creación de muestras.
- [ ] **Pruebas:** Añadir Unit Tests a los servicios críticos.

## 📌 Notas de Arquitectura
- La comunicación con el backend (Spring Boot) está segmentada por puertos (8081, 8082, 8083).
- Terminología: Se actualizó el término "Modelos" por "Muestras" en el menú principal para mayor claridad con el cliente final.
*   **Inversión Visual:** Los AppBar ahora usan fondo de color sólido con texto e iconos en blanco para mayor legibilidad.
*   **Nueva Identidad de Administración:** Se implementó el color verde pastel (0xFFA8BCB1) como estándar para todo el módulo de Clientes y Usuarios.
*   **Sincronización Total de Acciones:** Se actualizaron todos los FloatingActionButtons y botones de guardado para que coincidan con el color de su respectivo módulo.
- Se prioriza la integridad de datos relacionales al editar órdenes, asegurando que `sampleList` no se pierda en los PUT/POST.
- **Hito Alpha:** Pruebas de función con el cliente final superadas con éxito.