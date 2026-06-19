# Listado Maestro de Activos de Arte (Art Assets List)

Este documento contiene las sugerencias del **Art Director** respecto a los activos gráficos (Sprites, Animaciones, Tilesets y Props) necesarios para dar vida a las mecánicas, niveles y narrativa de "El Destello Escarlata". Está diseñado para alinear la producción artística con los requerimientos de Game Design y Level Design.

---

## 1. Animaciones de Personajes (Spritesheets HD-2D)

Para mantener la estética retro de 32-bit pero fluida (HD-2D), se sugiere trabajar en un estándar de **4 u 8 direcciones** (dependiendo de la capacidad de producción técnica, preferiblemente 8 para un movimiento táctico más orgánico) y a un promedio de **4 a 6 fotogramas (frames)** por animación básica, con excepciones para movimientos clave de combate.

### Protagonistas y Mascotas

#### Aura (Maga Arcana)
*   **Idle (Reposo):** 4 frames. Respiración sutil. Su ropa debe ondear levemente (efecto de brisa marítima/magia residual).
*   **Walk / Run (Caminar / Correr):** 6 frames. Movimiento ligero y rápido.
*   **Cast (Canalización Mágica):** 4 frames (Loop). Aura levanta su bastón/manos. Requiere acompañamiento de VFX limpio (brillo dorado/azulado).
*   **Attack (Ataque Mágico Básico):** 3 frames (Anticipación rápida, impacto, recuperación).
*   **Hit (Recibir Daño):** 2 frames. Retroceso abrupto. Color parpadeante en blanco/rojo vía shader.
*   **Death / Knockout:** 4 frames. Caída al suelo dramática pero no violenta ("grimdark").
*   **Special - Lead (Animación Exclusiva Acto 3):** Idle alternativo, postura más firme y líder, portando un recuerdo de Zantyr.

#### Zantyr (Tanque)
*   **Idle (Reposo):** 4 frames. Postura ancha, escudo plantado ligeramente en el suelo.
*   **Walk (Caminar):** 6 frames. Paso pesado. Su armadura no debe verse ágil.
*   **Block (Bloqueo Defensivo):** 3 frames (Loop). Levanta el escudo frente a sí. Silueta completamente cerrada para indicar la zona de embudo (Chokepoint).
*   **Attack (Golpe Pesado):** 5 frames (Larga anticipación, golpe devastador, recuperación lenta).
*   **Hit (Recibir Daño):** 2 frames. Mínimo retroceso, demostrando que es un muro físico.
*   **Special - Sacrifice (Evento Acto 2):** Animación única. Zantyr forzando el cierre de puertas/derrumbe mientras recibe daño continuo del Sello.

#### Orfeo (Gato - Interfaz "Navi")
*   **Idle / Walk:** 4 frames. Pequeño y fluido.
*   **Alert (Detección de Magia):** 4 frames. Animación donde se eriza, y sus marcas o los ojos brillan fuertemente en color cian (requiere textura emisiva para los shaders).

#### Choco (Perro - Resolución de Puzzles)
*   **Idle / Walk:** 4 frames. Trote alegre.
*   **Dig (Cavar):** 4 frames (Loop). Necesario para interactuar con las zonas de tierra (Level Design).
*   **Hold (Presionar):** 2 frames (Loop). Sentado firmemente sobre una placa de presión.

### Enemigos (Marineros Corrompidos / Base)
*   **Idle:** 4 frames. Movimiento espasmódico, encorvado.
*   **Walk:** 6 frames. Cojear arrastrando extremidades mutadas por coral/tentáculos.
*   **Attack:** 4 frames. Golpe torpe pero con alcance engañoso (tentáculos).
*   **Death:** 5 frames. Descomposición rápida o disolución en una mancha oscura (fango).

---

## 2. Arte de Niveles: Tilesets y Props

Según el `LEVEL_DESIGN.md`, los entornos necesitan comunicar misterio, opresión o calidez. Los Tilesets se organizarán en celdas de cuadrícula (ej. 32x32 px o 64x64 px).

### 2.1. Zonas Seguras (Hubs) - "Taberna de Elina"
*Tono: Cálido, acogedor, madera gastada por la sal.*

**Tilesets:**
*   Suelo de madera pulida pero rayada (variaciones de tablas sueltas).
*   Paredes de piedra cálida o estuco con vigas de madera gruesas.
*   Zonas de alfombras rústicas.

**Props (Accesorios):**
*   **Iluminación:** Hoguera principal, faroles colgados, velas en mesas (requieren partículas/luces dinámicas 2D naranjas en Godot).
*   **Ambiente:** Barriles de cerveza/agua dulce, mesas de madera redondas, taburetes.
*   **Narrativos:** Mapas de navegación enrollados, redes de pesca secándose.

### 2.2. Zonas de Exploración Acto I - "Puerto de Invernia / Ruinas Costeras"
*Tono: Aventura, brisa fresca, piedra erosionada, primeras señales sutiles de corrupción.*

**Tilesets:**
*   Suelo empedrado (limpio) vs. Suelo empedrado (con musgo/algas).
*   Muelles de madera (con transiciones a agua animada).
*   Paredes de piedra caliza o ruinas erosionadas.
*   Zonas de agua profunda (no transitable) vs. Aguas poco profundas (transitable, reduce velocidad).

**Props (Accesorios e Interacciones Tácticas):**
*   **Coberturas (Tactical Props):** Cajas de suministros mercantes (destructibles: 3 estados - entero, roto, destruido).
*   **Chokepoints:** Puertas de hierro oxidado, barricadas improvisadas por supervivientes.
*   **Mecánica de Choco:** "Montículo de Tierra Removida" (Prop visualmente distinto al suelo base, que indica dónde Choco puede cavar por botín/llaves).

### 2.3. Zonas Corruptas - "Bosques Corrompidos / El Foso del Sello"
*Tono: Opresivo, claustrofóbico, colores enfermos (Verdes tóxicos, violetas, carmesí oscuro).*

**Tilesets:**
*   Suelo de fango oscuro (afecta mecánicamente el movimiento).
*   Paredes formadas por raíces retorcidas masivas y coral negro fosilizado.
*   Zonas de agua contaminada (textura tipo alquitrán con burbujas estallando).

**Props (Accesorios e Interacciones Tácticas):**
*   **Trampas Ocultas (Mecánica de Orfeo):** Runas del Sello en el suelo. Invisibles hasta que Orfeo se acerca, momento en el cual deben cambiar a una textura brillante y amenazante (Decal rojo/violeta brillante).
*   **Obstáculos Interactivos:** Pilares de cristal oscuro / Raíces corruptas gigantes. Aura puede usar magia para destruirlos, o pueden ser colapsados para bloquear el avance de los enemigos en persecuciones (Acto 2).
*   **Narrativos:** Restos de naufragios varados *dentro* del bosque, esqueletos de grandes bestias marinas.
