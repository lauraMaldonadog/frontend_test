# Frontend Test

Una aplicación Flutter que muestra información de universidades utilizando una arquitectura limpia y las mejores prácticas de desarrollo.

## Características

- 🏛️ Listado de universidades con información detallada
- 📱 Diseño responsive adaptable a diferentes tamaños de pantalla
- 🎨 Interfaz de usuario moderna y limpia
- 🧪 Tests unitarios y de widgets

## Tecnologías

- **Flutter**: Framework de desarrollo
- **BLoC**: Gestión de estado
- **Freezed**: Generación de código para modelos inmutables
- **Get It**: Inyección de dependencias
- **Go Router**: Navegación
- **Dio/HTTP**: Cliente HTTP
- **Mockito**: Testing

## Requisitos

- Flutter SDK 3.9.2 o superior
- Dart 3.9.2 o superior

## Instalación

1. Clona el repositorio:
```bash
git clone <url-del-repositorio>
cd frontend_test
```

2. Instala las dependencias:
```bash
flutter pub get
```

3. Genera los archivos de código necesarios:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

4. Ejecuta la aplicación:
```bash
flutter run
```

## Estructura del Proyecto

```
lib/
├── core/                  # Funcionalidades base y compartidas
│   ├── api/              # Configuración de API
│   ├── either/           # Manejo de resultados
│   ├── environment/      # Variables de entorno
│   ├── failure/          # Manejo de errores
│   ├── http/             # Cliente HTTP
│   └── router/           # Configuración de rutas
├── features/             # Características de la aplicación
│   ├── home/            # Página de inicio
│   └── universities/    # Feature de universidades
│       ├── data/        # Fuentes de datos y repositorios
│       ├── domain/      # Entidades y contratos
│       └── presentation/# UI y BLoC
└── shared/              # Utilidades compartidas
```

## Testing

Ejecuta los tests con:

```bash
flutter test
```

Para generar un reporte de cobertura:

```bash
flutter test --coverage
```

## Generación de Código

Este proyecto utiliza generadores de código. Cuando modifiques archivos con anotaciones de Freezed o JSON Serializable, ejecuta:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

O para desarrollo continuo:

```bash
flutter pub run build_runner watch
```

## Notas

Los archivos generados (*.freezed.dart, *.g.dart, *.mocks.dart) están excluidos del control de versiones. Asegúrate de ejecutar `build_runner` después de clonar el repositorio.
