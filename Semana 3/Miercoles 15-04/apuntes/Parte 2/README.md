# Semana 03 — Sesión 1 (Parte 2): NavigationBar funcional + Drawer Lateral

| Campo | Detalle |
|-------|---------|
| **Curso** | Desarrollo de Aplicaciones Móviles |
| **Fecha** | 2025-04-15 |
| **Sesión** | 1 (Semana 3) — Continuación |
| **Duración** | ~40 min |
| **Profesor** | Jefferson Ernesto Castro Pariona |
| **Stack** | Kotlin + Jetpack Compose + SQLite |
| **Video** | https://youtu.be/DgOrNtsJHNg |

---

> Esta clase es la **continuación directa** de la Parte 1. Asume que ya tienes:
> - Proyecto `semana2` con `Login.kt`, `Home.kt`, `TopBar.kt`, `NavigationBar.kt`
> - Login funcional con navegación a Home (`nav.navigate("View2")`)
> - TopBar con icono de menú hamburguesa

---

## 1. Refinamiento del NavigationBar

**[00:05]** Se modifican los ítems del `NavigationBar` para tener tres opciones:

| Ítem | Texto | Icono | Timestamp |
|------|-------|-------|-----------|
| 1 | Mail | `Icons.Default.Mail` | [00:05] |
| 2 | Ajustes | `Icons.Default.Settings` | [00:18] |
| 3 | Salir | `Icons.Default.Close` | [00:52] |

```kotlin
@Composable
fun NavigationBar(nav: NavHostController) {
    NavigationBar {
        NavigationBarItem(
            selected = false,
            onClick = { /* navegar */ },
            icon = { Icon(imageVector = Icons.Default.Mail, contentDescription = null) },
            label = { Text("Mail") }
        )
        NavigationBarItem(
            selected = false,
            onClick = { /* navegar */ },
            icon = { Icon(imageVector = Icons.Default.Settings, contentDescription = null) },
            label = { Text("Ajustes") }
        )
        NavigationBarItem(
            selected = false,
            onClick = { /* navegar */ },
            icon = { Icon(imageVector = Icons.Default.Close, contentDescription = null) },
            label = { Text("Salir") }
        )
    }
}
```

---

## 2. Integración del NavigationBar en Home

**[01:39]** La barra de navegación inferior solo debe aparecer en **Home** (la segunda vista), no en Login.

**[01:58]** Se agrega `bottomBar` al `Scaffold` de `Home.kt`:

```kotlin
@Composable
fun Home(nav: NavHostController) {
    Scaffold(
        topBar = { TopBar() },
        bottomBar = { NavigationBar(nav) }  // <-- NUEVO
    ) { paddingValues ->
        // contenido actual...
    }
}
```

**[02:34]** Preview del resultado: en la parte inferior aparecen los botones **Mail, Ajustes, Salida**.

> **⚠️ Pitfall:** El `NavigationBar` recibe `nav` (NavHostController) como parámetro para poder navegar desde sus ítems.

---

## 3. Menu Drawer Lateral (ModalNavigationDrawer)

**[04:04]** Se introduce el **Drawer** — el menú lateral que se desliza desde la izquierda.

**[04:28]** Representación visual: imagen de perfil arriba, luego texto, luego iconos con opciones, y un botón de salir al final.

**[04:39]** **¿Quién activa el Drawer?** → El **menú hamburguesa** (el icono de tres líneas en el TopBar).

**[04:52]** **Regla de negocio:** El drawer solo debe poder abrirse **después de iniciar sesión**. En Login, el menú hamburguesa no debe hacer nada (está presente pero sin evento).

### 3.1 Creación del archivo Drawer.kt

**[05:33]** Se crea el archivo `Drawer.kt` dentro de `components/`:

```
app/src/main/java/com/example/semana2/components/
├── TopBar.kt
├── NavigationBar.kt
└── Drawer.kt              ← NUEVO
```

**[05:56]** Función Composable base:

```kotlin
package com.example.semana2.components

import androidx.compose.runtime.Composable
import androidx.navigation.NavHostController

@Composable
fun Drawer(nav: NavHostController) {
    // contenido del drawer
}
```

### 3.2 Imagen de Perfil

**[06:26]** Se descarga una imagen JPG de una persona y se coloca en `res/drawable/`.

**[06:53]** El profesor busca una imagen adecuada — importante que sea **.jpg** (no AVIF ni WebP).

**[08:20]** Archivo: `res/drawable/persona.jpg`

**[08:59]** Código para la imagen circular:

```kotlin
Box(
    modifier = Modifier
        .padding(10.dp)
        .size(180.dp)
) {
    Image(
        painter = PainterResource(id = R.drawable.persona),
        contentDescription = "Foto de perfil",
        modifier = Modifier
            .size(128.dp)
            .clip(CircleShape)
            .border(2.dp, Color.Gray, CircleShape)
    )
}
```

> **Explicación línea por línea:**
> - `PainterResource(id = R.drawable.persona)` → carga la imagen desde `res/drawable/persona.jpg`.
> - `.size(128.dp)` → tamaño de la imagen.
> - `.clip(CircleShape)` → recorta la imagen en forma circular.
> - `.border(2.dp, Color.Gray, CircleShape)` → borde gris alrededor de la imagen.

> **⚠️ Pitfall:** La `R` debe ser la del proyecto (`com.example.semana2.R`), no la de Android.

### 3.3 Texto debajo de la imagen

**[12:39]**

```kotlin
Text(
    text = "UPC Movil",
    fontSize = 25.sp,
    modifier = Modifier.padding(15.dp)
)
```

### 3.4 Línea divisoria (HorizontalDivider)

**[13:45]**

```kotlin
Spacer(modifier = Modifier.height(8.dp))
HorizontalDivider()
Spacer(modifier = Modifier.height(8.dp))
```

> `HorizontalDivider()` → dibuja una línea horizontal separadora.
> Los `Spacer` evitan que la línea quede pegada al contenido de arriba y abajo.

### 3.5 NavigationDrawerItem (Opciones del Drawer)

**[15:25]** Cada opción del menú lateral es un `NavigationDrawerItem`:

```kotlin
NavigationDrawerItem(
    icon = {
        Icon(
            imageVector = Icons.Rounded.AccountCircle,
            contentDescription = null
        )
    },
    label = {
        Text(
            text = "Account",
            fontSize = 16.sp,
            modifier = Modifier.padding(15.dp)
        )
    },
    selected = false,
    onClick = { /* navegar */ }
)
```

**[21:06]** Se crean **4 opciones + 1 opción de salida** (5 en total):

| # | Icono | Texto | Timestamp |
|---|-------|-------|-----------|
| 1 | `Icons.Rounded.AccountCircle` | Account | [16:14] |
| 2 | `Icons.Rounded.Person` | Datos Personales | [21:45] |
| 3 | `Icons.Rounded.Settings` | Ajustes | [22:16] |
| 4 | `Icons.Default.CloudDownload` | Descargas | [22:41] |
| — | *(HorizontalDivider)* | *(línea separadora)* | [22:54] |
| 5 | `Icons.Default.Close` | Salir | [23:16] |

> Cada `NavigationDrawerItem` se copia (Ctrl+C, Ctrl+V) y se personaliza el icono y texto.

---

## 4. Activación del Drawer desde el TopBar

### 4.1 Parámetro openDrawer en TopBar

**[25:20]** El TopBar necesita un evento para abrir el drawer. Se agrega un parámetro `openDrawer` de tipo `()` -> `Unit`:

```kotlin
@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun TopBar(openDrawer: () -> Unit = {}) {  // ← NUEVO parámetro
    TopAppBar(
        title = { Text(text = "UPC Movil") },
        navigationIcon = {
            IconButton(onClick = { openDrawer() }) {  // ← se ejecuta el evento
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

> **Explicación:** `openDrawer: () -> Unit` es una **lambda** (función como parámetro). Cuando se hace clic en el icono de menú, se ejecuta `openDrawer()`. Quien llame al TopBar decide qué hacer.

### 4.2 Login recibe openDrawer vacío

**[27:28]** En Login, el TopBar recibe `openDrawer = {}` (lambda vacía — no hace nada):

```kotlin
Scaffold(
    topBar = { TopBar(openDrawer = {}) }  // ← no pasa nada al hacer clic
) { ... }
```

**[28:00]** Verificación: al hacer clic en el menú hamburguesa en la pantalla Login, **no pasa nada**.

### 4.3 Home recibe openDrawer funcional (con corrutina)

**[28:17]** En Home, el drawer debe abrirse. Para eso se necesita:

1. **`DrawerState`** — controla el estado del drawer (abierto/cerrado).
2. **`CoroutineScope`** — para animar la apertura/cierre en un hilo separado.
3. **`ModalNavigationDrawer`** — el contenedor que envuelve el Scaffold.

**[29:44]** El drawer debe trabajar en un **hilo diferente** al principal para que la animación no bloquee la UI.

#### 4.3.1 DrawerState y CoroutineScope

**[30:01]**

```kotlin
val drawerState = rememberDrawerState(initialValue = DrawerValue.Closed)
val scope = rememberCoroutineScope()
```

> - `rememberDrawerState(DrawerValue.Closed)` → estado inicial: cerrado.
> - `rememberCoroutineScope()` → ámbito de corrutina para lanzar la animación.

#### 4.3.2 ModalNavigationDrawer envuelve al Scaffold

**[31:21]**

```kotlin
ModalNavigationDrawer(
    drawerState = drawerState,
    drawerContent = {
        ModalDrawerSheet {
            Drawer(nav = recordarPantalla)  // ← el contenido del drawer que creamos
        }
    }
) {
    // Aquí va el Scaffold con el contenido principal
    Scaffold(
        topBar = { TopBar(openDrawer = { /* abrir/cerrar */ }) },
        bottomBar = { NavigationBar(nav) }
    ) { ... }
}
```

**[32:43]** **Importante:** `ModalNavigationDrawer` debe **envolver** al `Scaffold`. No al revés.

#### 4.3.3 Lógica de apertura/cierre

**[33:21]**

```kotlin
TopBar(
    openDrawer = {
        scope.launch {
            if (drawerState.isClosed) {
                drawerState.open()
            } else {
                drawerState.close()
            }
        }
    }
)
```

> **Explicación:**
> - `scope.launch { }` → inicia una corrutina (hilo secundario).
> - `drawerState.isClosed` → pregunta si el drawer está cerrado.
> - `drawerState.open()` → anima la apertura.
> - `drawerState.close()` → anima el cierre.
> - Esto permite que el drawer se abra y cierre con el mismo botón (toggle).

### 4.4 Código completo de Home.kt con Drawer

```kotlin
package com.example.semana2.views

import androidx.compose.foundation.layout.*
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp
import androidx.navigation.NavHostController
import com.example.semana2.components.Drawer
import com.example.semana2.components.NavigationBar
import com.example.semana2.components.TopBar
import kotlinx.coroutines.launch

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun Home(nav: NavHostController) {
    val drawerState = rememberDrawerState(initialValue = DrawerValue.Closed)
    val scope = rememberCoroutineScope()

    ModalNavigationDrawer(
        drawerState = drawerState,
        drawerContent = {
            ModalDrawerSheet {
                Drawer(nav = nav)
            }
        }
    ) {
        Scaffold(
            topBar = {
                TopBar(
                    openDrawer = {
                        scope.launch {
                            if (drawerState.isClosed) drawerState.open()
                            else drawerState.close()
                        }
                    }
                )
            },
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
}
```

---

## 5. Estructura Final del Proyecto

Después de esta clase, la estructura completa es:

```
app/src/main/java/com/example/semana2/
├── MainActivity.kt              # Entry point + navegación
├── views/
│   ├── Login.kt                 # Login con validación
│   └── Home.kt                  # Home con TopBar + BottomNav + Drawer
├── components/
│   ├── TopBar.kt                # Barra superior (recibe openDrawer)
│   ├── NavigationBar.kt         # Barra inferior (Mail, Ajustes, Salir)
│   └── Drawer.kt                # Drawer lateral con perfil + opciones
└── ui/theme/
```

---

## 6. Verificación Final

**[35:37]** Ejecución de la app:

1. Aparece **Login** → el menú hamburguesa no hace nada.
2. Ingresar credenciales (`jose@gmail.com` / `123123`).
3. Navega a **Home**.
4. El menú hamburguesa ahora **abre el drawer lateral** con:
   - Foto de perfil circular
   - Texto "UPC Movil"
   - Línea divisoria
   - Opciones: Account, Datos Personales, Ajustes, Descargas
   - Línea divisoria
   - Salir

---

## 7. Resumen de Conceptos Nuevos

| Concepto | Archivo | Explicación |
|----------|---------|-------------|
| `NavigationDrawerItem` | Drawer.kt | Cada opción del menú lateral (icono + texto + onClick) |
| `ModalNavigationDrawer` | Home.kt | Contenedor del drawer que envuelve al Scaffold |
| `ModalDrawerSheet` | Home.kt | Hoja donde se renderiza el contenido del drawer |
| `rememberDrawerState` | Home.kt | Estado del drawer (abierto/cerrado) |
| `DrawerValue.Closed/Open` | Home.kt | Valores posibles del estado del drawer |
| `rememberCoroutineScope` | Home.kt | Ámbito para lanzar animaciones en hilo separado |
| `scope.launch { }` | Home.kt | Inicia una corrutina para animación sin bloquear UI |
| `drawerState.open()/close()` | Home.kt | Funciones para animar apertura/cierre |
| `HorizontalDivider` | Drawer.kt | Línea horizontal separadora |
| `.clip(CircleShape)` | Drawer.kt | Recorta una imagen en forma circular |
| `PainterResource` | Drawer.kt | Carga imágenes desde `res/drawable/` |
| Lambda como parámetro | TopBar.kt | `openDrawer: () -> Unit` para pasar eventos |

---

## 8. Próximos Pasos (mencionados por el profe)

**[36:57]** Controles que aún faltan por ver:
- **FloatingActionButton** (FAB)
- **TopBar** con acciones adicionales
- Más configuraciones de layout

---

> *Nota: Esta transcripción fue proporcionada manualmente por el estudiante. Timestamps corresponden al video https://youtu.be/DgOrNtsJHNg (~40 min).*
