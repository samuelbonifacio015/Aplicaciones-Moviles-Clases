# Semana 02 — Sesión 1: Introducción a Android Studio y Estructura del Proyecto

| Campo | Detalle |
|-------|---------|
| **Curso** | Desarrollo de Aplicaciones Móviles |
| **Fecha** | 2025-04-04 |
| **Sesión** | 1 (Semana 2) |
| **Duración** | ~18 min |
| **Profesor** | Jefferson Ernesto Castro Pariona |
| **Stack** | Kotlin + Jetpack Compose + SQLite |

---

## 1. Entornos de Desarrollo Android: Jetpack Compose vs XML

**[00:54]** El profesor introduce los dos enfoques para desarrollar apps Android:

- **Jetpack Compose** → enfoque moderno, declarativo, con Kotlin. Es el que se usará en el curso.
- **XML** → enfoque tradicional con layouts XML. Mencionado como referencia histórica.

> **Concepto clave:** Jetpack Compose permite construir la UI directamente desde código Kotlin, sin archivos XML de layout. Es el estándar actual recomendado por Google.

---

## 2. Descarga e Instalación de Android Studio

**[01:29]** El profesor muestra que Android Studio se descarga desde la página oficial.

**[01:44]**
- Peso del instalador: ~1.3 GB - 1.4 GB aproximado.
- Se necesita espacio libre en disco para la instalación.

**[02:07]**
- La instalación es simple: "Next, Next, Next, Next, Install".
- No hay configuración especial durante la instalación inicial.

> **⚠️ Pitfall común:** Al instalar Android Studio por primera vez, asegúrate de tener al menos 10-15 GB libres en disco solo para Android Studio y sus SDKs iniciales.

---

## 3. Creación de un Nuevo Proyecto

**[02:18]** Una vez instalado Android Studio:

1. Abrir Android Studio → aparece la pantalla de bienvenida.
2. Click en **"New Project"** (nuevo proyecto).
3. Se muestran las plantillas disponibles.

**[02:40]** El profesor explica las plantillas:

| Plantilla | Uso |
|-----------|-----|
| **Empty Views Activity** (cubo dentro de cubo) | Jetpack Compose ✅ **Esta usaremos** |
| Empty Activity / basic activity | XML tradicional (para referencia) |

> **Nota:** El icono de Jetpack Compose es un cubo pequeño dentro de otro cubo más grande.

**[02:57]**
- Seleccionar **Empty Compose Activity**.
- Click en **"Next"**.

**[03:07]** Configurar el proyecto:
- **Name:** `semana 01` (el profesor lo nombra así para este ejemplo).
- **Package name:** se genera automáticamente (por defecto `com.example.semana01`).
- **Save location:** dejarlo por defecto.
- **Minimum SDK:** API 24 o superior (luego se discute en detalle).

**[03:14]** Click en **"Finish"** → Android Studio comienza a crear el proyecto.

**[03:55]** **Primera carga:** La primera vez que abres un proyecto, Android Studio descarga múltiples librerías y dependencias. Puede tardar varios minutos dependiendo de la conexión a internet.

---

## 4. Estructura del Proyecto (Desglose)

**[04:41]** Una vez cargado el proyecto, el profesor desglosa la estructura de carpetas desde el panel izquierdo (Project view).

### 4.1 AndroidManifest.xml

**[05:09]**

```xml
<?xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:tools="http://schemas.android.com/tools">

    <!-- Aquí van los permisos -->
    <uses-permission android:name="android.permission.INTERNET" />

    <application
        android:allowBackup="true"
        android:icon="@mipmap/ic_launcher"
        android:label="@string/app_name"
        android:roundIcon="@mipmap/ic_launcher_round"
        android:supportsRtl="true"
        android:theme="@style/Theme.Semana01"
        tools:targetApi="31">
        
        <activity
            android:name=".MainActivity"
            android:exported="true"
            android:theme="@style/Theme.Semana01">
            <intent-filter>
                <action android:name="android.intent.action.MAIN" />
                <category android:name="android.intent.category.LAUNCHER" />
            </intent-filter>
        </activity>
        
    </application>

</manifest>
```

**[05:14]** **¿Qué contiene el Manifest?**
- Información principal del proyecto (nombre, icono, tema).
- La **primera actividad** o pantalla que se ejecuta al abrir la app (`MainActivity`).
- Los **permisos** que la aplicación necesita.

**[05:24]** **Permisos en Android (tema crucial):**

**[05:47]** Sintaxis para declarar permisos:
```xml
<uses-permission android:name="android.permission.INTERNET" />
```

**[05:53]** Ejemplos de permisos comunes:

| Permiso | Recurso | Código en Manifest |
|---------|---------|-------------------|
| Internet | Conexión a red | `android.permission.INTERNET` |
| Bluetooth | Conexión Bluetooth | `android.permission.BLUETOOTH` |
| WiFi | Red WiFi | `android.permission.ACCESS_WIFI_STATE` |
| Cámara | Cámara frontal/posterior | `android.permission.CAMERA` |
| Audio/Micrófono | Grabación de audio | `android.permission.RECORD_AUDIO` |
| Contactos | Agenda telefónica | `android.permission.READ_CONTACTS` |
| Almacenamiento | Leer/grabar archivos | `android.permission.READ_EXTERNAL_STORAGE` |

**[06:59]** **⚠️ Regla obligatoria de Google Play Store:**
No puedes usar ningún recurso del dispositivo (cámara, contactos, micrófono) sin **solicitar permiso explícitamente**. Si lo haces:
- Google Play Store elimina tu cuenta de desarrollador.
- Viola los términos y condiciones.

**[07:35]** **Doble capa de permisos:**
1. **Declarar en Manifest** (lo que se ve en el XML).
2. **Solicitar en código** (permisos en tiempo de ejecución, con `ActivityResultContracts`).

**[07:54]** Resumen del Manifest → lugar donde declaras qué recursos usará tu app.

### 4.2 MainActivity.kt

**[08:13]** Archivo principal donde se programa la lógica de la primera pantalla.

Estructura típica que genera el template Empty Compose Activity:

```kotlin
package com.example.semana01

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.tooling.preview.Preview
import com.example.semana01.ui.theme.Semana01Theme

class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContent {
            Semana01Theme {
                // A surface container using the 'background' color from the theme
                Surface(
                    modifier = Modifier.fillMaxSize(),
                    color = MaterialTheme.colorScheme.background
                ) {
                    Greeting("Android")
                }
            }
        }
    }
}

@Composable
fun Greeting(name: String, modifier: Modifier = Modifier) {
    Text(
        text = "Hello $name!",
        modifier = modifier
    )
}

@Preview(showBackground = true)
@Composable
fun GreetingPreview() {
    Semana01Theme {
        Greeting("Android")
    }
}
```

> **Explicación línea por línea:**
> - `ComponentActivity` → clase base para actividades con Compose.
> - `setContent { }` → bloque que define la UI con funciones Composable.
> - `Semana01Theme { }` → tema personalizado aplicado a toda la UI.
> - `Surface { }` → contenedor visual con color de fondo del tema.
> - `Greeting("Android")` → función **Composable** que renderiza texto.
> - `@Composable` → annotation que marca una función como UI declarativa.
> - `@Preview` → permite ver el componente en el panel de preview sin ejecutar la app.

### 4.3 Carpeta `res/` (Resources)

**[08:26]** `res` = **Resources** → aquí se almacenan todos los recursos estáticos.

**[08:35]**

```
res/
├── drawable/          # Imágenes fijas (logos, iconos personalizados)
│   └── ic_launcher_background.xml
├── mipmap/            # Iconos de la aplicación (distintas densidades)
│   ├── mipmap-hdpi/
│   ├── mipmap-mdpi/
│   ├── mipmap-xhdpi/
│   ├── mipmap-xxhdpi/
│   └── mipmap-xxxhdpi/
├── values/            # Colores, strings, temas
│   ├── colors.xml
│   ├── strings.xml
│   ├── themes.xml
│   └── ...
└── xml/               # Archivos XML de recursos adicionales
```

**[08:50]** **drawable/** → imágenes locales que siempre estarán en la app (logos, backgrounds). Si la imagen se consume desde internet, no necesita estar aquí.

**[09:05]** **mipmap/** → íconos del launcher en diferentes densidades (hdpi, mdpi, xhdpi, xxhdpi, xxxhdpi).

**[09:15]** **values/** → archivos de configuración:
- `colors.xml` → paleta de colores personalizada.
- `strings.xml` → cadenas de texto (para soporte multi-idioma).
- `themes.xml` → definición del tema visual.

> **Concepto importante:** Los recursos se referencian desde código con la sintaxis `@tipo/nombre` (ej: `@string/app_name`, `@color/primary`).

### 4.4 Gradle (Archivos de Configuración)

**[09:48]** **Gradle** es el sistema de build de Android. Archivos principales:

#### `build.gradle.kts` (nivel de módulo — app/)

**[09:55]**

```kotlin
plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android")
}

android {
    namespace = "com.example.semana01"
    compileSdk = 34

    defaultConfig {
        applicationId = "com.example.semana01"
        minSdk = 24
        targetSdk = 34
        versionCode = 1
        versionName = "1.0"
    }

    buildTypes {
        release {
            isMinifyEnabled = false
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }
    
    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }
    
    kotlinOptions {
        jvmTarget = "17"
    }
    
    buildFeatures {
        compose = true
    }
    
    composeOptions {
        kotlinCompilerExtensionVersion = "1.5.4"
    }
    
    packaging {
        resources {
            excludes += "/META-INF/{AL2.0,LGPL2.1}"
        }
    }
}

dependencies {
    implementation("androidx.core:core-ktx:1.12.0")
    implementation("androidx.lifecycle:lifecycle-runtime-ktx:2.6.2")
    implementation("androidx.activity:activity-compose:1.8.1")
    
    implementation(platform("androidx.compose:compose-bom:2024.01.00"))
    implementation("androidx.compose.ui:ui")
    implementation("androidx.compose.ui:ui-graphics")
    implementation("androidx.compose.ui:ui-tooling-preview")
    implementation("androidx.compose.material3:material3")
    
    // Dependencias que se agregarán en clases futuras
    // implementation("androidx.room:room-runtime:2.6.1")
    // implementation("com.squareup.retrofit2:retrofit:2.9.0")
    // implementation("com.github.bumptech.glide:glide:4.16.0")
    
    debugImplementation("androidx.compose.ui:ui-tooling")
    debugImplementation("androidx.compose.ui:ui-test-manifest")
}
```

**[10:14]** **Secciones clave de Gradle:**

| Sección | Función |
|---------|---------|
| `compileSdk` | Versión de Android con la que se compila el código |
| `minSdk` | Versión mínima de Android que soportará la app |
| `targetSdk` | Versión objetivo para la que se diseñó la app |
| `dependencies { }` | Aquí se agregan todas las librerías externas |

**[10:21]** **Dependencias que se usarán en el curso (mencionadas):**
- **Glide** → carga de imágenes desde URL.
- **Retrofit** → consumo de servicios web (APIs REST).
- **Room** → base de datos local SQLite (ORM).
- **Drift** → otra alternativa para SQLite en Kotlin.

> **⚠️ Pitfall común:** Cada vez que agregues una dependencia, sincroniza Gradle (aparece un banner "Sync Now" en la esquina superior derecha). No hacerlo puede causar errores de compilación.

---

## 5. SDK Manager y Configuración de API Mínima

**[11:07]** **SDK Manager** se accede desde el ícono de **tuerca ⚙️** en la esquina superior derecha de Android Studio.

**[11:19]** Click en la tuerca → se abre el SDK Manager.

**[11:30]** SDKs instalados en la PC del laboratorio:
- API 16 (Android 4.1 Jelly Bean)
- API 15 (Android 4.0.3 Ice Cream Sandwich)
- API 11 (Android 3.0 Honeycomb)
- API 10 (Android 2.3 Gingerbread)
- Versiones 2.1 en adelante

**[12:12]** El profesor pregunta: **"Si quiero llegar a la mayor cantidad de personas, ¿qué versión API elijo?"**

**[13:08]** **Respuesta: NO las últimas versiones.**

**Razonamiento:**
- Las últimas versiones solo están en celulares comprados recientemente.
- No todas las personas compran celular cada año.
- Muchos usuarios tienen celulares de 2 o 3 años atrás.

### 5.1 Cómo Elegir el Minimum SDK

**[13:37]** Pasos:

1. Abrir **New Project**.
2. En la pantalla de configuración, hacer click en el dropdown de **Minimum SDK**.

**[14:05]** Android Studio muestra una tabla con:

| API Level | Versión Android | Cobertura global |
|-----------|----------------|------------------|
| **API 21** | **Lollipop (5.0)** | **~99.9%** ← RECOMENDADO |
| API 29 | Android 10 | ~90% |
| API 33 | Android 13 | ~50% |
| API 34 | Android 14 | ~20% |
| **API 35 / 36** | **Android 15/16** | **~7.5%** ← Muy bajo |

**[14:21]** **Conclusión del profesor:**
- **API 21 (Lollipop)** llega al **99.9%** de dispositivos → ideal si quieres máxima cobertura.
- Conforme subes de API, pierdes mercado.
- API 16 (Android 15) → solo **7.5%** del mercado mundial.

**[15:03]** **Regla práctica:** Elige la versión mínima más pequeña que cubra tu mercado objetivo, pero que sea compatible con las librerías modernas que usarás.

**[15:39]** Versiones obsoletas (Android 4.0 y anteriores) ya no se consideran — es muy raro encontrar dispositivos con más de 10 años de antigüedad.

---

## 6. Almacenamiento de SDKs en Disco

**[16:07]** Los SDKs se guardan en una ruta local en el disco.

**[16:21]** Ruta típica (en macOS/Linux):
```
~/Android/Sdk/
```

En Windows:
```
C:\Users\[Usuario]\AppData\Local\Android\Sdk\
```

**[17:01]** **Peso en disco:**
- Solo las versiones 10, 11 y 15 → **11 GB**.
- Si tuvieras todas las versiones desde API 5 hasta API 36, fácilmente **200 GB o más**.

**[17:37]** **¿Por qué necesitas múltiples versiones de SDK?**

**[17:50]** **Regla importante:**
- Si tu `minSdk` es API 21 (Lollipop), debes tener instalados **desde API 21 en adelante**.
- **¿Por qué?** Porque si programas todo con herramientas de API 36 y un usuario con API 21 abre la app, pueden ocurrir **crash** porque no reconoce APIs modernas.
- Debes probar y programar pensando en la versión mínima que elegiste.

**[18:23]** Esta es una práctica de **entornos laborales reales**.

---

## Resumen de Conceptos Clave

| Concepto | Explicación |
|----------|-------------|
| **Jetpack Compose** | Framework declarativo de UI para Android con Kotlin |
| **Android Manifest** | Archivo XML con info del proyecto + permisos |
| **Permisos** | Obligatorios para acceder a recursos del dispositivo |
| **Resources (res/)** | Imágenes, colores, strings, temas |
| **Gradle** | Build system, configuración y dependencias |
| **Minimum SDK** | Versión mínima de Android que soporta tu app |
| **SDK Manager** | Herramienta para instalar/actualizar versiones de SDK |

## Próximos Pasos (para la siguiente clase)

A partir de la Semana 9 se introducirá **Flutter** (mencionado brevemente en [02:25]).

Las próximas clases cubrirán:
- Programación de la UI con Jetpack Compose
- Integración con bases de datos SQLite usando Room
- Consumo de APIs REST con Retrofit
- Navegación entre pantallas
- Manejo de permisos en tiempo de ejecución

---

> *Nota: Esta clase fue transcrita y resumida del video "video1" de Jefferson Ernesto Castro Pariona. La transcripción se realizó de forma manual debido a restricciones de YouTube desde redes cloud.*
