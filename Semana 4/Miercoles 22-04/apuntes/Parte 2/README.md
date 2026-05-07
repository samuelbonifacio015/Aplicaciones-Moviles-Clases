# Semana 04 — Sesión 2: MVVM + LazyColumn + Coil (Carga de Imágenes)

| Campo | Detalle |
|-------|---------|
| **Curso** | Desarrollo de Aplicaciones Móviles |
| **Fecha** | 2025-04-22 |
| **Sesión** | 2 (Semana 4) |
| **Duración** | ~20 min |
| **Profesor** | Jefferson Ernesto Castro Pariona |
| **Stack** | Kotlin + Jetpack Compose + SQLite + MVVM |
| **Video** | https://youtu.be/WbqZZlK732k |

---

> **Contexto:** Esta clase asume que ya existe el **modelo `Sites`**, el **`SitesViewModel`** con su lógica de obtención de datos y la inyección del **viewModel** desde `MainActivity`. El profesor se enfoca en construir la **vista Home** que consume ese ViewModel.

---

## 1. Arquitectura MVVM en Uso

```
MainActivity
  └── viewModel = SitesViewModel()
        ├── viewModel.getSites()     ← carga datos
        └── viewModel.listaSitios    ← ArrayList<Sites>
              │
              ▼
Home(listaSitios, viewModel)
  └── LazyColumn
        └── Card → AsyncImage + Text(site.nombre, site.descripcion)
```

---

## 2. Home.kt — Pantalla de Lista de Sitios Turísticos

### 2.1 Firma de la función

**[00:33]** [00:49]

```kotlin
@Composable
fun Home(
    listaSitios: ArrayList<Sites>,  // ← datos del ViewModel
    viewModel: SitesViewModel       // ← ViewModel para acciones
) {
    // ...
}
```

> **Explicación:**
> - `listaSitios` → `ArrayList<Sites>` con los sitios turísticos a mostrar.
> - `viewModel` → el ViewModel completo, necesario para operaciones futuras.

### 2.2 Contenedor principal

**[01:51]** [02:05]

```kotlin
@Composable
fun Home(listaSitios: ArrayList<Sites>, viewModel: SitesViewModel) {
    Column(
        modifier = Modifier
            .fillMaxSize()
            .padding(20.dp)
    ) {
        // contenido
    }
}
```

> - `fillMaxSize()` → ocupa toda la pantalla.
> - `padding(20.dp)` → margen interior para que el contenido no esté pegado a los bordes.

### 2.3 LazyColumn para lista scrolleable

**[02:42]** Se necesita una columna que permita **scroll vertical**. Una `Column` normal no hace scroll, así que se usa **`LazyColumn`**:

```kotlin
LazyColumn(
    contentPadding = PaddingValues(
        horizontal = 15.dp,
        vertical = 5.dp
    )
) {
    items(listaSitios) { site ->   // ← itera sobre cada sitio
        SiteCard(site = site)       // ← tarjeta por cada sitio
    }
}
```

> **Explicación:**
> - `LazyColumn` → versión eficiente de `Column` que solo renderiza los ítems visibles en pantalla.
> - `contentPadding` → espaciado horizontal (15.dp) y vertical (5.dp) alrededor del contenido.
> - `items(listaSitios) { site -> ... }` → función que itera sobre cada elemento de la lista.
> - El parámetro `site` es cada objeto `Sites` individual.

**[04:26]** [04:35] **⚠️ Pitfall:** `items` no se importa automáticamente. Hay que importarlo manualmente:

```kotlin
import androidx.compose.foundation.lazy.items
```

**[05:27]** Sin este import, `items(listaSitios)` marcará error.

### 2.4 SiteCard — Tarjeta individual

Se extrae la lógica de cada tarjeta a un composable separado para claridad (aunque el profesor lo escribe inline dentro del `LazyColumn`).

#### Card con elevación

**[06:16]**

```kotlin
Card(
    modifier = Modifier
        .fillMaxWidth()
        .padding(vertical = 8.dp),
    elevation = CardDefaults.cardElevation(defaultElevation = 8.dp)
) {
    Column(
        modifier = Modifier
            .fillMaxWidth()
            .padding(10.dp),
        // ← los hijos van aquí
    ) {
        AsyncImage(site)   // ← imagen (secciòn 2.5)
        TextInfo(site)      // ← textos (sección 2.6)
    }
}
```

> **Explicación de propiedades:**
> - `fillMaxWidth()` → la tarjeta ocupa todo el ancho disponible.
> - `padding(vertical = 8.dp)` → separación vertical entre tarjetas.
> - `cardElevation(8.dp)` → sombra/elevación de la tarjeta (efecto 3D).

### 2.5 AsyncImage (Coil) — Cargar imagen desde URL

**[09:03]** Se usa la librería **Coil** para cargar imágenes desde internet de forma asíncrona.

**[09:09]** **Requisito:** Tener la dependencia de Coil en `build.gradle.kts`:

```kotlin
// build.gradle.kts (:app) - dependencia necesaria
implementation("io.coil-kt:coil-compose:2.6.0")
```

**[09:19]** Código de AsyncImage:

```kotlin
AsyncImage(
    model = ImageRequest.Builder(LocalContext.current)
        .data(site.imagen)          // ← URL de la imagen desde el modelo
        .build(),
    contentDescription = null,
    modifier = Modifier
        .fillMaxWidth()
        .height(200.dp)
)
```

> **Explicación línea por línea:**
> - `AsyncImage` → componente de Coil que carga imágenes de forma asíncrona (en segundo plano).
> - `ImageRequest.Builder(LocalContext.current)` → constructor de la petición de imagen. Necesita el contexto actual.
> - `.data(site.imagen)` → la URL de la imagen viene del campo `imagen` del objeto `Sites`.
> - `.build()` → construye la petición.
> - `contentDescription = null` → descripción para accesibilidad (null por ahora).
> - `fillMaxWidth()` + `height(200.dp)` → la imagen ocupa todo el ancho y tiene 200dp de alto fijo.

> **¿Cómo funciona Coil?**
> 1. Toma la URL (`site.imagen`).
> 2. Descarga la imagen en segundo plano.
> 3. La almacena en caché local.
> 4. La muestra en el `AsyncImage` cuando está lista.
> 5. Mientras carga, muestra un placeholder (por defecto nada).

### 2.6 Textos informativos

**[11:37]** Debajo de la imagen, se muestran los datos del sitio:

```kotlin
Text(
    text = "Sitio ID: ${site.id}",
    style = MaterialTheme.typography.bodyLarge,
    modifier = Modifier.padding(top = 8.dp)
)

Text(
    text = site.nombre ?: "",
    style = MaterialTheme.typography.titleMedium,
    fontWeight = FontWeight.Bold
)

Text(
    text = site.descripcion ?: "",
    style = MaterialTheme.typography.bodyMedium,
    color = Color.Gray
)
```

**[19:08]** El profesor agrega también `site.nombre` para mostrar el nombre del lugar:

```kotlin
Text(text = site.nombre ?: "")
```

### 2.7 Código completo de Home.kt

```kotlin
package com.example.semana2.views

import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.material3.*
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.unit.dp
import coil.compose.AsyncImage
import coil.request.ImageRequest
import androidx.compose.ui.platform.LocalContext
import com.example.semana2.model.Sites
import com.example.semana2.viewmodel.SitesViewModel

@Composable
fun Home(listaSitios: ArrayList<Sites>, viewModel: SitesViewModel) {
    Column(
        modifier = Modifier
            .fillMaxSize()
            .padding(20.dp)
    ) {
        LazyColumn(
            contentPadding = PaddingValues(
                horizontal = 15.dp,
                vertical = 5.dp
            )
        ) {
            items(listaSitios) { site ->
                Card(
                    modifier = Modifier
                        .fillMaxWidth()
                        .padding(vertical = 8.dp),
                    elevation = CardDefaults.cardElevation(
                        defaultElevation = 8.dp
                    )
                ) {
                    Column(
                        modifier = Modifier
                            .fillMaxWidth()
                            .padding(10.dp)
                    ) {
                        AsyncImage(
                            model = ImageRequest.Builder(LocalContext.current)
                                .data(site.imagen)
                                .build(),
                            contentDescription = null,
                            modifier = Modifier
                                .fillMaxWidth()
                                .height(200.dp)
                        )

                        Text(
                            text = "Sitio ID: ${site.id}",
                            style = MaterialTheme.typography.bodyLarge,
                            modifier = Modifier.padding(top = 8.dp)
                        )

                        Text(
                            text = site.nombre ?: "",
                            style = MaterialTheme.typography.titleMedium,
                            fontWeight = FontWeight.Bold
                        )

                        Text(
                            text = site.descripcion ?: "",
                            style = MaterialTheme.typography.bodyMedium,
                            color = Color.Gray
                        )
                    }
                }
            }
        }
    }
}
```

---

## 3. MainActivity.kt — Punto de entrada con ViewModel

**[14:49]** Se modifica `MainActivity` para instanciar el ViewModel y pasarlo a Home.

### 3.1 Antes (estructura con composables inline)

**[15:10]** Se eliminan los composables de preview y el `setContent` original.

### 3.2 Después — Instanciar ViewModel y conectar con Home

**[15:17]**

```kotlin
package com.example.semana2

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import com.example.semana2.model.SitesViewModel  // ← importar ViewModel
import com.example.semana2.views.Home            // ← importar Home

class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        val viewModel = SitesViewModel()  // ← instanciar ViewModel

        setContent {
            viewModel.getSites()  // ← cargar datos

            Home(
                listaSitios = viewModel.listaSitios,
                viewModel = viewModel
            )
        }
    }
}
```

> **Explicación del flujo:**
> 1. Se crea `viewModel = SitesViewModel()`.
> 2. Se llama `viewModel.getSites()` para iniciar la carga de datos.
> 3. Se pasa `viewModel.listaSitios` (la lista de sitios) a Home.
> 4. Se pasa también el `viewModel` completo por si Home necesita ejecutar acciones.

> **⚠️ Pitfall:** No olvidar importar `Home` desde `com.example.semana2.views.Home`. Sin el import, la referencia a `Home(...)` marcará error.

---

## 4. Sitios Turísticos Mostrados

**[19:08]** Los datos que carga la app incluyen sitios turísticos famosos:

| Sitio | Descripción |
|-------|-------------|
| Machu Picchu | Tierra de los Incas |
| Ayacucho | Ciudad de las 33 iglesias |
| Chichén Itzá | Corazón del Imperio Maya |
| Cristo Redentor | — |
| Islas Malvinas | — |
| Muralla China | — |

---

## 5. Problema del Firewall (Imágenes no cargan)

**[18:01]** [18:44]

El laboratorio de la universidad tiene un **firewall** que bloquea las conexiones a servidores externos de imágenes.

**Síntomas:**
- Los textos (ID, nombre, descripción) **sí se cargan** correctamente.
- Las imágenes de Coil **no se muestran** (quedan en blanco).
- La app **reconoce** la URL y el AsyncImage está bien configurado, pero el firewall impide la descarga.

**Solución:**
- Probar en casa con datos móviles o red sin restricciones.
- Usar una laptop con datos compartidos del celular.
- En el emulador con red local, las imágenes cargan sin problema.

---

## 6. Estructura Final del Proyecto

```
app/src/main/java/com/example/semana2/
├── MainActivity.kt            # Entry point → viewModel.getSites() → Home
├── model/
│   └── Sites.kt               # Data class del sitio turístico
├── viewmodel/
│   └── SitesViewModel.kt      # ViewModel con getSites() y listaSitios
├── views/
│   ├── Login.kt               # Login (clases anteriores)
│   └── Home.kt                # Home con LazyColumn + AsyncImage ← NUEVO
├── components/
│   ├── TopBar.kt
│   ├── NavigationBar.kt
│   └── Drawer.kt
└── ui/theme/
```

---

## 7. Resumen de Conceptos Nuevos

| Concepto | Archivo | Explicación |
|----------|---------|-------------|
| `LazyColumn` | Home.kt | Lista scrolleable eficiente que solo renderiza items visibles |
| `items(lista)` | Home.kt | Función de LazyColumn para iterar sobre la lista |
| `Card` | Home.kt | Tarjeta con elevación para agrupar imagen + texto |
| `CardDefaults.cardElevation()` | Home.kt | Controla la sombra/elevación de la tarjeta |
| `AsyncImage` (Coil) | Home.kt | Carga imágenes desde URL de forma asíncrona |
| `ImageRequest.Builder` | Home.kt | Construye la petición de imagen con contexto + URL |
| `LocalContext.current` | Home.kt | Obtiene el contexto actual de Compose |
| Content padding | Home.kt | Espaciado interno del LazyColumn |
| `viewModel.getSites()` | MainActivity | Inicia la carga de datos desde el ViewModel |
| `viewModel.listaSitios` | MainActivity | Lista expuesta por el ViewModel para la vista |

---

> *Nota: Transcripción proporcionada manualmente. Los timestamps indican posición en el video (~20 min).*
