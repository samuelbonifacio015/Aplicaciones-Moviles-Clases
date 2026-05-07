# Semana 03 — Sesión 1: Login con Jetpack Compose + Navegación

| Campo | Detalle |
|-------|---------|
| **Curso** | Desarrollo de Aplicaciones Móviles |
| **Fecha** | 2025-04-15 |
| **Sesión** | 1 (Semana 3) |
| **Duración** | ~49:30 min |
| **Profesor** | Jefferson Ernesto Castro Pariona |
| **Stack** | Kotlin + Jetpack Compose + SQLite |
| **Video** | "shared screen 2" (grabación de pantalla, sin audio) |

---

> **Nota:** Esta clase fue reconstruida mediante OCR de frames extraídos cada 4 minutos, ya que el video es una grabación de pantalla sin audio y YouTube bloquea IPs cloud. Los timestamps indican la posición en el video.

---

## 1. Estructura del Proyecto

**[04:00]** El proyecto se llama **`semana2`** con paquete base `com.example.semana2`.

```
app/src/main/java/com/example/semana2/
├── MainActivity.kt
├── views/
│   ├── Login.kt          # Pantalla de login
│   └── Home.kt           # Pantalla de inicio tras login
├── components/
│   ├── TopBar.kt          # Barra superior reutilizable
│   └── NavigationBar.kt   # Barra de navegación inferior
└── ui/theme/             # Tema de Material3
```

**[04:00]** Dispositivo de preview: **Medium Phone API 36.1**.

**[08:00]** Fecha/hora del sistema durante la grabación: **Wed Apr 15, 8:42 PM → 9:26 PM**.

---

## 2. Configuración de Gradle (build.gradle.kts)

**[08:00]** El profesor muestra el archivo `build.gradle.kts` del módulo `:app`:

```kotlin
android {
    // ...
    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    buildFeatures {
        compose = true
    }
}

dependencies {
    // Navegación
    val nav_version = "2.9.7"
    implementation("androidx.navigation:navigation-compose:$nav_version")

    // Iconos extendidos de Material
    implementation("androidx.compose.material:material-icons-extended")

    // Otras dependencias del template estándar
    implementation("androidx.core:core-ktx:1.12.0")
    implementation("androidx.lifecycle:lifecycle-runtime-ktx:2.6.2")
    implementation("androidx.activity:activity-compose:1.8.1")
    implementation(platform("androidx.compose:compose-bom:2024.01.00"))
    implementation("androidx.compose.ui:ui")
    implementation("androidx.compose.ui:ui-graphics")
    implementation("androidx.compose.ui:ui-tooling-preview")
    implementation("androidx.compose.material3:material3")
}
```

> **⚠️ Pitfall:** AGP (Android Gradle Plugin) versión 9.1.0 — Android Studio muestra notificación de actualización disponible. Siempre revisar compatibilidad antes de actualizar.

---

## 3. MainActivity.kt

**[04:00]** Archivo principal que arranca la app con el tema y la primera pantalla (Login):

```kotlin
package com.example.semana2

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Surface
import androidx.compose.ui.Modifier
import com.example.semana2.ui.theme.Semana2Theme
// ... imports de navegación

class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContent {
            Semana2Theme {
                Surface(
                    modifier = Modifier.fillMaxSize(),
                    color = MaterialTheme.colorScheme.background
                ) {
                    // Aquí se configura la navegación
                }
            }
        }
    }
}
```

---

## 4. Login.kt — Pantalla de Login

**[04:00]** Archivo principal de la clase. Es una pantalla de inicio de sesión con:
- Campo de **Usuario**
- Campo de **Contraseña**
- Botón **"Iniciar Sesión"**
- **Diálogo de error** si las credenciales son incorrectas
- Validación contra credenciales quemadas en código (hardcoded)

### 4.1 Imports

**[12:00]** [40:00]

```kotlin
package com.example.semana2.views

import androidx.compose.foundation.layout.*
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.width
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.CheckCircle
import androidx.compose.material.icons.filled.Lock
import androidx.compose.material.icons.filled.Person
import androidx.compose.material3.ButtonDefaults
import androidx.compose.material3.ElevatedButton
import androidx.compose.material3.Icon
import androidx.compose.material3.OutlinedTextField
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Modifier
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.input.PasswordVisualTransformation
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.compose.ui.window.Dialog
import androidx.navigation.NavHostController
import com.example.semana2.R
import com.example.semana2.components.TopBar
```

### 4.2 Función Composable Login

**[04:00]** [40:00]

```kotlin
@SuppressLint("UnusedMaterial3ScaffoldPaddingParameter")
@Composable
fun Login(nav: NavHostController) {
    var txtUsu by remember { mutableStateOf("jose@gmail.com") }
    var txtPas by remember { mutableStateOf("") }
    var isDisplay by remember { mutableStateOf(false) }

    Scaffold(
        modifier = Modifier.fillMaxSize(),
        topBar = { TopBar() }
    ) {
        Column(
            modifier = Modifier
                .fillMaxSize()
                .padding(all = 20.dp),
            verticalArrangement = Arrangement.Center,
            horizontalAlignment = Alignment.CenterHorizontally
        ) {
            // Título
            Text(
                text = "LOGIN USERS",
                fontSize = 24.sp,
                fontWeight = FontWeight.Bold
            )

            // Campo Usuario
            OutlinedTextField(
                value = txtUsu,
                onValueChange = { txtUsu = it },
                modifier = Modifier.padding(vertical = 10.dp),
                label = { Text("Usuario") },
                placeholder = { Text("Ingrese Usuario") },
                // iconos se configuran abajo
            )

            // Campo Contraseña
            OutlinedTextField(
                value = txtPas,
                onValueChange = { txtPas = it },
                modifier = Modifier.padding(vertical = 10.dp),
                label = { Text("Password") },
                placeholder = { Text("Ingrese Password") },
                visualTransformation = PasswordVisualTransformation(),
                // iconos se configuran abajo
            )

            // Botón Iniciar Sesión
            ElevatedButton(
                onClick = {
                    if (txtUsu == "jose@gmail.com" && txtPas == "123123") {
                        nav.navigate(route = "View2")
                    } else {
                        isDisplay = true
                    }
                },
                colors = ButtonDefaults.buttonColors(containerColor = Color.Blue),
                modifier = Modifier
                    .padding(all = 10.dp)
                    .width(300.dp)
            ) {
                Text(
                    text = "Iniciar Sesion",
                    fontSize = 20.sp,
                    color = Color.White
                )
            }
        }

        // Diálogo de error
        if (isDisplay) {
            Dialog(onDismissRequest = { isDisplay = false }) {
                Card(
                    modifier = Modifier.height(300.dp),
                    shape = RoundedCornerShape(size = 15.dp)
                ) {
                    Column(
                        modifier = Modifier
                            .fillMaxSize()
                            .padding(all = 20.dp),
                        verticalArrangement = Arrangement.Center,
                        horizontalAlignment = Alignment.CenterHorizontally
                    ) {
                        Text(
                            text = "ERROR",
                            fontSize = 24.sp,
                            fontWeight = FontWeight.Bold,
                            color = Color.Red
                        )
                        Text("Credenciales incorrectas")
                    }
                }
            }
        }
    }
}
```

### 4.3 Detalle: OutlinedTextField con Iconos Personalizados

**[16:00]** El profesor configura los OutlinedTextField con iconos y colores personalizados:

```kotlin
OutlinedTextField(
    // ... props básicas
    leadingIcon = {
        Icon(
            imageVector = Icons.Default.Person,
            contentDescription = null,
            tint = Color.Blue
        )
    },
    trailingIcon = {
        Icon(
            imageVector = Icons.Default.CheckCircle,
            contentDescription = null,
            tint = Color.Blue
        )
    },
    colors = TextFieldDefaults.colors(
        focusedTextColor = Color.Yellow,
        unfocusedTextColor = Color.Red,
        focusedContainerColor = Color.Red,
        unfocusedContainerColor = Color.Yellow
    )
)
```

> **Explicación de colores:**
> - `focusedTextColor`: color del texto cuando el campo está seleccionado.
> - `unfocusedTextColor`: color del texto cuando el campo no está seleccionado.
> - `focusedContainerColor`: color de fondo cuando el campo está seleccionado.
> - `unfocusedContainerColor`: color de fondo cuando el campo no está seleccionado.

**[32:00]** Para el campo de contraseña se agrega:

```kotlin
visualTransformation = PasswordVisualTransformation()
```

Esto convierte el texto en puntos (••••) para ocultar la contraseña.

### 4.4 Detalle: Diálogo de Error (Dialog + Card)

**[24:00]** [28:00]

```kotlin
var isDisplay by remember { mutableStateOf(false) }

if (isDisplay) {
    Dialog(onDismissRequest = { isDisplay = false }) {
        Card(
            modifier = Modifier.height(300.dp),
            shape = RoundedCornerShape(size = 15.dp)
        ) {
            Column(
                modifier = Modifier
                    .fillMaxSize()
                    .padding(all = 20.dp),
                verticalArrangement = Arrangement.Center,
                horizontalAlignment = Alignment.CenterHorizontally
            ) {
                Text(
                    text = "ERROR",
                    fontSize = 24.sp,
                    fontWeight = FontWeight.Bold,
                    color = Color.Red
                )
                // Más contenido del diálogo...
            }
        }
    }
}
```

> **Explicación:**
> - `Dialog` es un componente de Compose que abre una ventana modal.
> - `onDismissRequest` → se ejecuta cuando el usuario toca fuera del diálogo.
> - `Card` con `height(300.dp)` y `RoundedCornerShape(15.dp)` → tarjeta con bordes redondeados.
> - `Arrangement.Center` + `Alignment.CenterHorizontally` → centra el contenido.

### 4.5 Detalle: Botón ElevatedButton

**[36:00]**

```kotlin
ElevatedButton(
    onClick = {
        if (txtUsu == "jose@gmail.com" && txtPas == "123123") {
            nav.navigate(route = "View2")
        } else {
            isDisplay = true
        }
    },
    colors = ButtonDefaults.buttonColors(containerColor = Color.Blue),
    modifier = Modifier
        .padding(all = 10.dp)
        .width(300.dp)
) {
    Text(
        text = "Iniciar Sesion",
        fontSize = 20.sp,
        color = Color.White
    )
}
```

> **Lógica de autenticación:**
> - Usuario hardcodeado: `jose@gmail.com`
> - Contraseña hardcodeada: `123123`
> - Si coinciden → navega a la ruta `"View2"` (Home).
> - Si no coinciden → muestra el diálogo de error (`isDisplay = true`).

> **⚠️ Pitfall:** Esta es una validación temporal para pruebas. En producción se usa autenticación contra backend (API REST, Firebase Auth, etc.).

---

## 5. TopBar.kt — Barra Superior Reutilizable

**[20:00]** Componente de barra superior con título "UPC Movil" y menú de navegación:

```kotlin
package com.example.semana2.components

import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Menu
import androidx.compose.material3.*
import androidx.compose.runtime.Composable
import androidx.compose.ui.graphics.Color

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun TopBar() {
    TopAppBar(
        title = {
            Text(text = "UPC Movil")
        },
        navigationIcon = {
            IconButton(onClick = { /* menú lateral */ }) {
                Icon(
                    imageVector = Icons.Default.Menu,
                    contentDescription = null,
                    tint = Color.White
                )
            }
        },
        colors = TopAppBarDefaults.topAppBarColors(
            containerColor = Color.Blue,
            titleContentColor = Color.White
        )
    )
}
```

> **Explicación:**
> - `TopAppBar` → componente Material3 para barra superior.
> - `navigationIcon` → ícono de menú (tres líneas), típicamente abre un Drawer.
> - `colors` → personaliza color de fondo (azul) y texto (blanco).
> - Se usa `@OptIn(ExperimentalMaterial3Api::class)` porque algunas APIs de Material3 aún son experimentales.

---

## 6. NavigationBar.kt — Barra de Navegación Inferior

**[44:00]** [48:00] Componente de barra inferior con elementos de navegación:

```kotlin
package com.example.semana2.components

import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Mail
import androidx.compose.material3.*
import androidx.compose.runtime.Composable
import androidx.navigation.NavHostController

@Composable
fun NavigationBar(nav: NavHostController) {
    NavigationBar {
        NavigationBarItem(
            selected = false,
            onClick = { /* navegar a Mail */ },
            icon = {
                Icon(
                    imageVector = Icons.Default.Mail,
                    contentDescription = null
                )
            },
            label = {
                Text(text = "Mail")
            }
        )
        // Más items: Calendar, Profile, etc.
    }
}
```

> **Explicación:**
> - `NavigationBar` → contenedor Material3 para barra inferior.
> - `NavigationBarItem` → cada elemento individual.
> - `selected` → controla si el item está activo (cambiando color/estado).
> - `Icons.Default.Mail` → ícono de Material Design incluido en `material-icons-extended`.

---

## 7. Home.kt — Pantalla de Inicio

**[44:00]** Pantalla que se muestra tras login exitoso. Muestra "Bienvenidos Sistema". Es el destino de la navegación `"View2"`.

Estructura esperada:

```kotlin
package com.example.semana2.views

import androidx.compose.foundation.layout.*
import androidx.compose.material3.*
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp
import androidx.navigation.NavHostController

@Composable
fun Home(nav: NavHostController) {
    Scaffold(
        topBar = { TopBar() },
        bottomBar = { NavigationBar(nav) }
    ) { paddingValues ->
        Column(
            modifier = Modifier
                .fillMaxSize()
                .padding(paddingValues),
            verticalArrangement = Arrangement.Center,
            horizontalAlignment = Alignment.CenterHorizontally
        ) {
            Text(
                text = "Bienvenidos Sistema",
                style = MaterialTheme.typography.headlineMedium
            )
        }
    }
}
```

---

## 8. Flujo Completo de la Aplicación

```
[Login] ──(credenciales correctas)──> [Home]
   │                                       │
   │                                       ├── TopAppBar "UPC Movil"
   │                                       └── NavigationBar (Mail, ...)
   │
   └──(credenciales incorrectas)──> [Dialog ERROR]
```

**Rutas de navegación:**
- `"View2"` → pantalla Home (destino tras login)

---

## 9. Resumen de Conceptos Aprendidos

| Concepto | Archivo | Explicación |
|----------|---------|-------------|
| `OutlinedTextField` | Login.kt | Campo de texto con borde, label y placeholder |
| `leadingIcon` / `trailingIcon` | Login.kt | Iconos decorativos dentro del campo |
| `PasswordVisualTransformation` | Login.kt | Oculta texto de contraseña con puntos |
| `TextFieldDefaults.colors()` | Login.kt | Personaliza colores del campo (focus/unfocus) |
| `ElevatedButton` | Login.kt | Botón con elevación 3D |
| `Dialog` + `Card` | Login.kt | Ventana modal con tarjeta estilizada |
| `Scaffold` | Login.kt | Layout principal con soporte para TopBar/BottomBar |
| `TopAppBar` | TopBar.kt | Barra superior con título y menú |
| `NavigationBar` | NavigationBar.kt | Barra inferior con items de navegación |
| `NavHostController.navigate()` | Login.kt | Navegación entre pantallas |
| `remember` + `mutableStateOf` | Login.kt | Estado local en Compose |

## 10. Próximos Pasos

Las siguientes clases probablemente cubran:
- Integración de **SQLite / Room** para persistencia local
- Consumo de **APIs REST** con Retrofit
- Navegación más compleja con múltiples rutas
- Manejo de estados de carga y error

---

> *Nota: Esta clase fue reconstruida mediante OCR de frames del video "shared screen 2" (sin audio). Los timestamps indican posición en el video de ~49 min.*
