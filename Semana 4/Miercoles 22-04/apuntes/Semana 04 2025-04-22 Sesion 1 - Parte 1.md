# Semana 04 — Sesión 1 (Parte 1): Retrofit + MVVM — Configuración desde Cero

| Campo | Detalle |
|-------|---------|
| **Curso** | Desarrollo de Aplicaciones Móviles |
| **Fecha** | 2025-04-22 |
| **Sesión** | 1 (Semana 4) — Parte 1 |
| **Duración** | ~50 min |
| **Profesor** | Jefferson Ernesto Castro Pariona |
| **Stack** | Kotlin + Jetpack Compose + Retrofit + MVVM |
| **Video** | https://youtu.be/BgB6V1wLm94 |

---

> **Contexto:** Esta clase arranca desde **cero** — nuevo proyecto en Android Studio, configuración de dependencias, creación de la arquitectura MVVM con Retrofit para consumir una API REST. Es la base sobre la que se construyó el Home con LazyColumn de la Parte 2.

---

## 1. Nuevo Proyecto en Android Studio

**[00:10]** Se crea un nuevo proyecto Android con **Empty Compose Activity** (template con el cubito de Jetpack Compose).

**[00:29]** Template: "el que maneja Kotlin" → `Empty Compose Activity`.

**[02:39]** Se ejecuta el emulador de una vez (la primera carga siempre demora).

---

## 2. Android Manifest — Permiso de Internet

**[04:11]**

```xml
<uses-permission android:name="android.permission.INTERNET" />
```

> **⚠️ Obligatorio:** Sin este permiso, Retrofit no puede hacer peticiones HTTP a la API. Se coloca antes del `<application>` tag.

---

## 3. Estructura de Paquetes (MVVM)

**[04:52]** Se crean tres paquetes dentro de `com.example.semana2/`:

```
com.example.semana2/
├── model/           # Data classes + Retrofit client + WebService
├── views/           # Composables (Home, Login, etc.)
└── viewmodel/       # ViewModel (SitesViewModel)
```

**[05:07]** [05:28]

```
model/
├── Sites.kt              # Data class del sitio turístico
├── WebService.kt         # Interface con métodos HTTP (Retrofit)
├── RetrofitClient.kt     # Objeto singleton que construye Retrofit
└── (beans/)              # Opcional, para objetos adicionales
```

views/ → `Home.kt`

viewmodel/ → `SitesViewModel.kt`

> **Explicación de capas:**
> - **Model** → datos y acceso a red (Retrofit, API, data classes).
> - **ViewModel** → intermediario: recibe datos del Model y los expone a la View.
> - **View** → UI (Composables) que observa los cambios del ViewModel.

---

## 4. Gradle — Dependencias

**[10:22]** [16:00] Se agregan las bibliotecas necesarias al `build.gradle.kts` (`:app`):

```kotlin
dependencies {
    // Retrofit 2.11.0 — cliente HTTP
    implementation("com.squareup.retrofit2:retrofit:2.11.0")

    // Gson Converter — convierte JSON automáticamente a objetos Kotlin
    implementation("com.squareup.retrofit2:converter-gson:2.11.0")

    // Coil — carga de imágenes desde URL
    implementation("io.coil-kt:coil-compose:2.6.0")

    // Otras dependencias del template estándar
    implementation("androidx.core:core-ktx:1.12.0")
    implementation("androidx.lifecycle:lifecycle-runtime-ktx:2.6.2")
    implementation("androidx.activity:activity-compose:1.8.1")
    implementation(platform("androidx.compose:compose-bom:2024.01.00"))
    implementation("androidx.compose.ui:ui")
    implementation("androidx.compose.ui:ui-tooling-preview")
    implementation("androidx.compose.material3:material3")
}
```

**[10:57]** **Retrofit** — se obtiene desde la página oficial `square.github.io/retrofit`.

**[11:08]** URL: `https://square.github.io/retrofit/` → sección de descargas.

**[12:00]** Versión usada: **2.11.0** (la más reciente al momento de la clase).

**[12:11]** **Converter Gson** — necesario para que Retrofit convierta automáticamente el JSON en objetos Kotlin.

**[13:19]** **Coil** — para cargar imágenes desde URLs.

**[14:19]** Después de agregar las dependencias → click en **Sync Now** para que Gradle descargue las librerías.

> **⚠️ Pitfall clave (31:06):** La versión de `converter-gson` DEBE coincidir con la versión de `retrofit`. Ambas `2.11.0`. Si versiones distintas, el converter no se reconoce y `GsonConverterFactory` no importa.

**[16:14]** El profesor comparte las dependencias en el chat del aula para los alumnos.

---

## 5. API Endpoint

**[16:44]** El profesor comparte la URL de la API REST a consumir:

```
https://[servidor]/api/sitios.php
```

**[17:22]** Ejecutando esa URL en un navegador, devuelve JSON con esta estructura:

```json
[
    {
        "idSitio": "1",
        "nombre": "Machu Picchu",
        "descripcion": "Tierra de los Incas",
        "pais": "Perú",
        "imagen": "https://ejemplo.com/machu.jpg"
    },
    {
        "idSitio": "2",
        "nombre": "Chichén Itzá",
        "descripcion": "Corazón del Imperio Maya",
        "pais": "México",
        "imagen": "https://ejemplo.com/chichen.jpg"
    }
]
```

> **⚠️ Regla estricta (17:53):** Las mayúsculas y minúsculas del JSON deben coincidir EXACTAMENTE con las propiedades de la data class. `idSitio` (con S mayúscula), no `idsitio` ni `id_sitio`. Un error de mayúscula/minúscula rompe toda la comunicación.

---

## 6. Sites.kt — Data Class

**[18:27]**

```kotlin
package com.example.semana2.model

data class Sites(
    val idSitio: String?,       // ← notar la S mayúscula (coincide con JSON)
    val nombre: String?,
    val descripcion: String?,
    val pais: String?,
    val imagen: String?         // ← URLs también son String (están entre comillas)
)
```

> **Explicación:**
> - `data class` → genera automáticamente `toString()`, `equals()`, `hashCode()`, `copy()`.
> - `String?` → nullable, por si algún campo llega null desde la API.
> - Los nombres de las propiedades deben coincidir **exactamente** con las claves del JSON.

---

## 7. WebService.kt — Interface con Métodos HTTP

**[21:06]** [21:36]

```kotlin
package com.example.semana2.model

import com.example.semana2.model.Sites
import retrofit2.Response
import retrofit2.http.GET

interface WebService {

    @GET("sitios.php")                          // ← endpoint (sin barra inicial)
    suspend fun getSites(): Response<List<Sites>>  // ← función suspend (corrutina)
}
```

> **Explicación línea por línea:**
> - `@GET("sitios.php")` → anotación que define el método HTTP GET y el endpoint.
> - `suspend fun` → función de corrutina de Kotlin. Se ejecuta en segundo plano sin bloquear la UI.
> - `Response<List<Sites>>` → envoltorio de Retrofit que contiene la respuesta HTTP más la lista de objetos.
> - **⚠️:** Usar `retrofit2.Response`, NO `okhttp3.Response`.

**[23:18]** Si hubiera más endpoints (POST, PUT, DELETE), simplemente se agregan más métodos aquí:

```kotlin
interface WebService {
    @GET("sitios.php")
    suspend fun getSites(): Response<List<Sites>>

    @POST("sitios.php")
    suspend fun createSite(@Body site: Sites): Response<Sites>

    // etc.
}
```

---

## 8. RetrofitClient.kt — Cliente Singleton

**[25:25]** [25:42] Clase que construye y provee la instancia de Retrofit:

```kotlin
package com.example.semana2.model

import retrofit2.Retrofit
import retrofit2.converter.gson.GsonConverterFactory

object RetrofitClient {
    // API base URL — sin el endpoint (solo hasta el último slash)
    private const val BASE_URL = "https://[servidor]/api/"

    val webService: WebService by lazy {
        Retrofit.Builder()
            .baseUrl(BASE_URL)
            .addConverterFactory(GsonConverterFactory.create())
            .build()
            .create(WebService::class.java)
    }
}
```

> **Explicación:**
> - `object` → singleton de Kotlin (una sola instancia en toda la app).
> - `BASE_URL` → URL base de la API, **sin el endpoint**. El endpoint va en la anotación `@GET`.
> - `by lazy` → el WebService se inicializa solo cuando se usa por primera vez.
> - `.baseUrl(BASE_URL)` → establece la URL base.
> - `.addConverterFactory(GsonConverterFactory.create())` → registra el converter que transforma JSON → objetos Kotlin automágicamente.
> - `.build()` → construye la instancia de Retrofit.
> - `.create(WebService::class.java)` → crea la implementación de la interface.
>
> **¿Por qué GsonConverterFactory es tan importante?**
> Sin el converter, tendrías que parsear manualmente el JSON con `JSONObject` o similar. Con el converter, Retrofit + Gson hacen todo el trabajo: el JSON se convierte directamente en `List<Sites>`.

---

## 9. SitesViewModel.kt — Capa Intermedia

**[39:02]** [39:13]

```kotlin
package com.example.semana2.viewmodel

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.example.semana2.model.RetrofitClient
import com.example.semana2.model.Sites
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch

class SitesViewModel : ViewModel() {

    // Lista observable — "los ojitos de la vista" [40:02]
    var listaSitios = mutableStateListOf<Sites>()
        private set   // ← la vista solo puede leer, no modificar

    // Función que obtiene los sitios desde la API
    fun getSites() {
        viewModelScope.launch(Dispatchers.IO) {
            val response = RetrofitClient.webService.getSites()

            if (response.body() != null) {
                listaSitios.clear()
                listaSitios.addAll(response.body()!!)
            }
        }
    }
}
```

### 9.1 Variable observable — "los ojitos de la vista"

**[39:52]** [40:14]

```kotlin
var listaSitios = mutableStateListOf<Sites>()
    private set
```

> **Explicación:**
> - `mutableStateListOf<Sites>()` → lista mutable que **notifica cambios** a la UI cuando se modifica.
> - `private set` → la vista puede leer (`get`) pero solo el ViewModel puede modificar (`set`).
> - Cuando `listaSitios` cambia, Compose automáticamente re-renderiza los componentes que la observan.

### 9.2 Función getSites()

**[41:48]**

```kotlin
fun getSites() {
    viewModelScope.launch(Dispatchers.IO) {
        val response = RetrofitClient.webService.getSites()
        if (response.body() != null) {
            listaSitios.clear()
            listaSitios.addAll(response.body()!!)
        }
    }
}
```

> **Explicación paso a paso:**
> 1. `viewModelScope.launch(Dispatchers.IO)` → lanza una corrutina en el hilo de I/O (red, archivos).
>    - `viewModelScope` → ámbito ligado al ciclo de vida del ViewModel. Se cancela automáticamente cuando el ViewModel se destruye.
>    - `Dispatchers.IO` → hilo optimizado para operaciones de red/archivos.
> 2. `RetrofitClient.webService.getSites()` → llama al WebService para obtener la lista.
> 3. `response.body()` → extrae el cuerpo de la respuesta (el JSON convertido a `List<Sites>`).
> 4. `listaSitios.clear()` + `listaSitios.addAll(...)` → actualiza la lista observable.

> **⚠️ Pitfall:** Toda la lógica de red debe ir dentro de `Dispatchers.IO` o al menos dentro de una corrutina. Si se llama en el hilo principal (Main Thread), la app se congela.

---

## 10. Resumen del Flujo Completo (MVVM + Retrofit)

```
[API REST] ──JSON──> [RetrofitClient]
                         │
                         ▼
                   [WebService.getSites()]
                         │
                         ▼
              [GsonConverterFactory] ──convierte JSON a List<Sites>──┐
                                                                     │
                     ┌─────────────────────────────────────────┐     │
                     │           SitesViewModel                │◄────┘
                     │  getSites() → listaSitios (observable)  │
                     └───────────────────┬─────────────────────┘
                                         │
                                         ▼
                     ┌─────────────────────────────────────────┐
                     │           Home.kt (View)                │
                     │  LazyColumn { items(listaSitios) }      │
                     │  AsyncImage(site.imagen)                │
                     └─────────────────────────────────────────┘
```

---

## 11. Llamado de Lista (Final de Clase)

**[47:59]** El profesor pasa lista antes del receso.

---

## 12. Resumen de Conceptos Nuevos

| Concepto | Archivo | Explicación |
|----------|---------|-------------|
| `Retrofit` | build.gradle | Cliente HTTP para consumir APIs REST |
| `converter-gson` | build.gradle | Convierte JSON a objetos Kotlin automáticamente |
| `Coil` | build.gradle | Librería para cargar imágenes desde URL |
| `@GET("sitios.php")` | WebService.kt | Define un endpoint GET con Retrofit |
| `suspend fun` | WebService.kt | Función de corrutina (no bloqueante) |
| `Response<List<Sites>>` | WebService.kt | Tipo de respuesta de Retrofit |
| `Retrofit.Builder()` | RetrofitClient.kt | Construye la instancia de Retrofit |
| `GsonConverterFactory.create()` | RetrofitClient.kt | Registra el parseador JSON |
| `object RetrofitClient` | RetrofitClient.kt | Singleton (una instancia global) |
| `by lazy` | RetrofitClient.kt | Inicialización perezosa |
| `data class Sites` | Sites.kt | Modelo de datos con fields nullable |
| `mutableStateListOf<>()` | SitesViewModel.kt | Lista observable por la UI |
| `viewModelScope.launch()` | SitesViewModel.kt | Corrutina ligada al ciclo de vida |
| `Dispatchers.IO` | SitesViewModel.kt | Hilo para operaciones de red |
| `response.body()` | SitesViewModel.kt | Extrae el cuerpo de la respuesta HTTP |

---

> *Nota: Transcripción proporcionada manualmente. Esta clase configura toda la infraestructura Retrofit + MVVM; la Parte 2 (misma fecha) construye la UI con LazyColumn + AsyncImage.*
