# Primer Proyecto con Jetpack Compose

### Lenguaje: Kotlin

## ¿Qué es Jetpack Compose?
Jetpack Compose es el toolkit moderno de UI para Android, basado en el paradigma **declarativo**. En lugar de definir UIs con XML y modificarlas manualmente, describes cómo debe verse la interfaz y Compose se encarga del resto.

## Conceptos Fundamentales

### 1. Funciones Composables
- Se annotan con `@Composable`
- Son la unidad básica de construcción de UI
- Pueden recibir parámetros y emitir UI basada en ellos

```kotlin
@Composable
fun Greeting(name: String) {
    Text(text = "Hello $name!")
}
```

### 2. Componer y Recomponer
- **Composición inicial**: Compose llama a los composables para construir la UI
- **Recomposición**: Cuando cambia el estado, Compose vuelve a ejecutar solo los composables afectados
- Es automático y optimizado por el framework

### 3. State Management

#### `mutableStateOf`
```kotlin
var count by remember { mutableStateOf(0) }
```

#### `remember`
- Mantiene el estado entre recomposiciones
- Se pierde si el composable sale de la composición

#### `rememberSaveable`
- Similar a `remember`, pero sobrevive cambios de configuración y muerte de procesos

```kotlin
var text by rememberSaveable { mutableStateOf("") }
```

### 4. State Hoisting
Patrón donde el estado se mueve "hacia arriba" en la jerarquía de componentes:

```kotlin
@Composable
fun Counter(
    count: Int,
    onIncrement: () -> Unit,
    onDecrement: () -> Unit
) {
    Column {
        Text("Count: $count")
        Button(onClick = onIncrement) { Text("+") }
        Button(onClick = onDecrement) { Text("-") }
    }
}
```

**Beneficios**: Reutilizable, testeable, con fuente única de verdad.

### 5. Layouts Principales

#### `Column`
Elementos dispuestos verticalmente:
```kotlin
Column(
    modifier = Modifier.padding(16.dp),
    verticalArrangement = Arrangement.spacedBy(8.dp)
) {
    Text("Item 1")
    Text("Item 2")
}
```

#### `Row`
Elementos dispuestos horizontalmente:
```kotlin
Row(
    modifier = Modifier.fillMaxWidth(),
    horizontalArrangement = Arrangement.SpaceBetween
) {
    Text("Left")
    Text("Right")
}
```

#### `Box`
Elementos apilados (z-index):
```kotlin
Box {
    Image(...) // Fondo
    Text("Overlay") // Encima
}
```

### 6. Modifier
- Cadena de modificadores aplicada en orden
- Controla tamaño, padding, clics, scroll, etc.

```kotlin
Text(
    text = "Hello",
    modifier = Modifier
        .fillMaxWidth()
        .padding(16.dp)
        .clickable { /* acción */ }
        .background(Color.Blue)
)
```

**Importante**: El orden importa. `.padding().background()` ≠ `.background().padding()`

### 7. Lists con `LazyColumn` y `LazyRow`
Equivalente eficiente a `RecyclerView`:

```kotlin
@Composable
fun MessageList(messages: List<String>) {
    LazyColumn {
        items(messages) { message ->
            Text(message, modifier = Modifier.padding(8.dp))
        }
    }
}
```

### 8. Navegación
Usando Navigation Compose:

```kotlin
@Composable
fun AppNavigation() {
    val navController = rememberNavController()
    NavHost(navController, startDestination = "home") {
        composable("home") { HomeScreen(navController) }
        composable("detail/{id}") { backStackEntry ->
            val id = backStackEntry.arguments?.getString("id")
            DetailScreen(id, navController)
        }
    }
}
```

Navegar: `navController.navigate("detail/123")`  
Volver: `navController.popBackStack()`

### 9. Efectos Side-Effect

#### `LaunchedEffect`
Ejecuta coroutines cuando cambian las keys:
```kotlin
LaunchedEffect(key1) {
    // Se ejecuta cuando key1 cambia
}
```

#### `DisposableEffect`
Limpieza cuando el composable sale de la composición:
```kotlin
DisposableEffect(key) {
    // Setup
    onDispose {
        // Cleanup
    }
}
```

### 10. Temas y Estilos
- Usa `MaterialTheme` para consistencia
- Define colores, tipografía y formas en `Theme.kt`

```kotlin
@Composable
fun MyAppTheme(content: @Composable () -> Unit) {
    MaterialTheme(
        colorScheme = lightColorScheme(...),
        typography = Typography,
        content = content
    )
}
```

## Buenas Prácticas

✅ Composables pequeños y reutilizables  
✅ State hoisting para mejor testabilidad  
✅ Usa `Modifier` para personalización externa  
✅ Evita efectos secundarios en el cuerpo del composable  
✅ Usa `derivedStateOf` para estados calculados  
✅ Preview con `@Preview` para desarrollo rápido  

## Recursos Útiles
- [Documentación oficial](https://developer.android.com/jetpack/compose)
- [Pathway de aprendizaje](https://developer.android.com/courses/pathways/compose)
- [Samples oficiales](https://github.com/android/compose-samples)
