# Rol: Technical Director / Lead Programmer
**Proyecto:** El Destello Escarlata

Este documento establece la arquitectura de software, las decisiones técnicas clave y las directrices de programación para "El Destello Escarlata". Como Technical Director, el objetivo es proporcionar soluciones escalables y eficientes en Godot Engine 4 que soporten el diseño de juego táctico, el tono narrativo de fantasía marítima y el estilo visual HD-2D.

---

## 1. Arquitectura Base y Motor del Juego

### 1.1 Enfoque de Desarrollo: Patrones Limpios en Godot 4
La arquitectura de "El Destello Escarlata" se centrará en la modularidad y el desacoplamiento de componentes. Se usarán dos patrones de diseño principales:

*   **State Machine (Máquina de Estados):** Utilizado primordialmente para el flujo de combate y el comportamiento de la IA. Implementaremos un nodo base `StateMachine` y nodos hijos para cada estado (`CombatState`, `PlayerTurn`, `EnemyTurn`, etc.). Esto permite transiciones limpias y controladas en el combate táctico.
*   **Observer (Patrón Observador):** Godot maneja esto de forma nativa a través de **Señales (Signals)**. Todo el sistema narrativo (eventos de historia, triggers de diálogo) y de UI debe estar desacoplado de la lógica core de gameplay. Por ejemplo, al morir un enemigo, emitirá una señal `enemy_died` en lugar de llamar directamente a la interfaz o al gestor de misiones.

#### Ejemplo Estructural de un State Machine (GDScript):
```gdscript
# state_machine.gd
extends Node
class_name StateMachine

@export var initial_state : State
var current_state : State

func _ready():
    for child in get_children():
        if child is State:
            child.state_machine = self

    if initial_state:
        transition_to(initial_state.name)

func transition_to(state_name: String, msg: Dictionary = {}):
    if not has_node(state_name):
        return

    var next_state = get_node(state_name)
    if current_state:
        current_state.exit()

    current_state = next_state
    current_state.enter(msg)

func _process(delta):
    if current_state:
        current_state.update(delta)
```

### 1.2 Estilo HD-2D: Configuración en Godot
Para lograr la estética HD-2D (como dicta el Art Director), trabajaremos en un **entorno 3D** dentro de Godot 4, integrando sprites 2D con billboarding.

*   **Sprites en el Mundo 3D:** Los personajes y enemigos utilizarán el nodo `Sprite3D`. Se activará la propiedad `Billboard` (modo Y-Billboard) para que los sprites siempre miren a la cámara pero mantengan su anclaje en el suelo (Eje Y).
*   **Sombreado e Iluminación:**
    *   Los `Sprite3D` tendrán activada la opción `Cast Shadows` en sus flags.
    *   Utilizaremos luces `OmniLight3D` y `SpotLight3D` para las fogatas y efectos mágicos (Aura), asegurando que el motor de renderizado proyecte sombras sobre la topografía 3D (Level Design).
*   **Cámara:** Emplearemos una `Camera3D` con la propiedad `Projection` en **Orthogonal** (ortográfica) y un ángulo de 45 grados (vista isométrica top-down). Esto aplana la perspectiva, preservando la nitidez del pixel art 32-bit mientras navegamos en un entorno 3D.
*   **Rendimiento:** Mantendremos una baja cuenta de polígonos en el entorno y delegaremos la carga visual al sistema de iluminación (Deferred Rendering en Godot 4) y post-procesamiento (Bloom ligero para magias arcana y corrupción oscura).

## 2. Lógica del Sistema de Combate Evolutivo

### 2.1 Grid Táctico y NavMesh
El juego depende enormemente del posicionamiento táctico en un entorno de casillas. Para esto, integraremos la clase `AStarGrid2D` o un sistema análogo si trabajamos puramente en topología 3D (`AStar3D`).
Dado que el juego transcurre en 3D pero la lógica es 2D top-down, la solución óptima es mantener la lógica de pathfinding en un plano 2D abstracto y mapear las coordenadas al espacio 3D.

*   **Implementación de Grid:** Se instanciará una clase abstracta `TacticalGrid` que envuelva `AStarGrid2D`. Este grid se inicializará leyendo los obstáculos físicos de las capas del nivel (ej. usando un `RayCast3D` hacia abajo al inicio del nivel para detectar zonas transitables).
*   **Línea de Visión (LoS) y Áreas de Efecto (AoE):**
    *   **LoS:** Se calculará trazando una línea (Algoritmo de Bresenham en el grid o `PhysicsDirectSpaceState3D.intersect_ray` en 3D) entre la casilla del atacante y el objetivo. Si intersecta un obstáculo (ej. pilar de piedra), se bloquea.
    *   **AoE:** Para hechizos arcanos de Aura, se calcularán sumando el rango (Radio o Manhatan distance) desde la celda objetivo en la instancia de `AStarGrid2D`.

### 2.2 Gestor de Estados (Party Manager) y Las 3 Fases
Para permitir una transición fluida entre las etapas del juego, crearemos un `PartyManager` autoloader (Singleton) que actúe de fuente de verdad sobre el estado actual del grupo y modifique el comportamiento del combate.

*   **Fase 1 (Dúo: Zantyr + Aura):**
    *   **Sistema de Aggro:** A cada personaje se le asignará una estadística oculta de "Generación de Amenaza". Zantyr tendrá habilidades (Provocar, Control de Terreno) que multipliquen temporalmente su valor de amenaza, forzando a la IA enemiga a priorizar la ruta hacia él (sobreescribiendo el cálculo de ruta óptima al objetivo más frágil).
    *   **Lógica Cooperativa:** La IA enemiga debe lidiar con los "cuellos de botella" diseñados en Level Design.

*   **Fase 2 (Solitario: Aura):**
    *   **Rebalanceo Dinámico:** Tras un flag narrativo del sacrificio de Zantyr, el `PartyManager` retira la entidad de Zantyr.
    *   **Mecánicas Ambientales (Kiting):** Los nodos de trampas y entorno (columnas destructibles) serán de clase `InteractableEntity`. Aura tendrá acceso a un conjunto de habilidades (ej. magia de retroceso) para activarlos en combate y compensar la pérdida de control de terreno físico de Zantyr.

*   **Fase 3 (Retorno de Zantyr Pasivo):**
    *   **Zantyr como Entidad Autónoma/Buff:** Zantyr volverá como una entidad (Node3D/Sprite3D) en el mapa, controlada por una IA simple (`AuraFollowState`). No tendrá turno de ataque en el gestor de turnos, pero emitirá áreas de efecto circulares.
    *   **Buffs por Proximidad:** Mediante un `Area3D` (esfera superpuesta en Zantyr), si Aura termina su movimiento táctico dentro de su rango, el script de Zantyr aplicará pasivamente un modificador de defensa/escudo, cumpliendo la directriz narrativa de protección instintiva.

## 3. Programación de IA y Mascotas (Orfeo y Choco)

Las mascotas son herramientas tácticas activas y no pueden estorbar al jugador. Su lógica debe ser fluida y no intrusiva en el Pathfinding de combate.

### 3.1 Sistema de Seguimiento (Pathfinding sin bloqueos)
Para evitar que Orfeo o Choco bloqueen puertas o pasillos, no serán considerados como colisionadores (KinematicBody) rígidos en el layer de "Obstáculos Tácticos".
*   Se utilizará un nodo `CharacterBody3D` para ellos con máscara de colisión exclusiva para el suelo y paredes perimetrales.
*   Su estado de "Follow" se calculará tomando la posición de Aura, guardando las últimas N posiciones (Breadcrumb pathfinding) o usando `NavigationAgent3D` interpolado suavemente (`lerp()`) para que siempre mantengan una distancia mínima (ej. 2 unidades) y se aparten dinámicamente si el jugador camina hacia ellos.

### 3.2 Lógica de Interacción: Orfeo (Sistema de Detección)
Orfeo funciona como un sistema de alerta temprana (Navi).
*   **Implementación:** Orfeo tendrá un nodo `Area3D` (Overlap Sphere o Raycasting periódico) con un radio amplio que escanee el entorno buscando objetos en el layer de física `HiddenTraps`.
*   **Ejecución (Feedback Visual):** Cuando una trampa entra en el área, el script de Orfeo emite una señal. No desactivará la trampa ni revelará toda el área de peligro, simplemente activará un efecto de partículas, un sonido direccional o cambiará el shader de Orfeo (emisión de luz cian como indica el Art Director) apuntando hacia la dirección general, dando al jugador la oportunidad de ser cauto.

### 3.3 Lógica de Interacción: Choco (Sistema de Puzzles)
Choco es clave para la exploración topográfica e interactiva.
*   **Triggers Contextuales:** Ciertos interruptores inaccesibles o zonas con tierra removida serán nodos interactivos (ej. `SmallDuctTrigger`).
*   **Validación de Grupo:** El nodo trigger verificará mediante el `PartyManager.has_member("Choco")`. Si retorna `true`, mostrará un prompt de interacción.
*   **Ejecución de Puzzle:** Al presionar interactuar, el jugador enviará temporalmente a Choco a un estado `PuzzleSolvingState`, usando el sistema de NavMesh para cruzar a través del conducto (ignorando las colisiones perimetrales convencionales con una máscara específica), pulsar un interruptor (`Signal: door_opened`) y luego volver corriendo al lado de Aura.

## 4. Pipeline de Assets y Herramientas Externas

El uso de spritesheets generados (LPC Generator u otras herramientas automáticas con fondo Chroma Green) requiere un flujo de trabajo optimizado para no sobrecargar el proceso de importación y animación manual.

### 4.1 Guía de Integración LPC (Procesamiento de Spritesheets)
1.  **Limpieza del Chroma:** Recomendamos procesar las hojas generadas con una herramienta en lote (ImageMagick o script de Python) para convertir el color `#00FF00` puro a Transparencia (Alpha = 0) antes de importarlas a Godot.
2.  **Importación en Godot:**
    *   Al colocar la hoja de sprites procesada en el proyecto, seleccionarla.
    *   En el panel **Import**, asegurar que "Filter" está **Apagado (Nearest)** para preservar la nitidez (crispness) del pixel art 32-bit.
    *   Hacer clic en "Reimport".
3.  **Configuración del Nodo:**
    *   Asignar el archivo `.png` a la textura del `Sprite3D`.
    *   En la sección de `Animation` del inspector del sprite, configurar adecuadamente `Hframes` (columnas) y `Vframes` (filas) para que encajen con la grilla del LPC.

### 4.2 Controladores de Animación
Dado que el combate por turnos y los estados de los personajes (Idle, Walk, Attack, Hit, Death) requieren transiciones precisas alineadas al sistema de combate, configuraremos lo siguiente:
*   **AnimationPlayer:** Se crearán animaciones básicas modificando la propiedad `frame` del sprite. Se utilizarán pistas de método (Method Tracks) en los fotogramas clave de animación para emitir señales exactas al sistema de combate (ej. señal `hit_landed` en el frame exacto de impacto de la espada, para calcular el daño visualmente sincronizado).
*   **AnimationTree (State Machine Node):** Para los personajes, conectaremos un `AnimationTree` al `AnimationPlayer`. Usaremos un nodo `AnimationNodeStateMachine` dentro de Godot para manejar las transiciones automáticas entre animaciones direccionales (arriba, abajo, izquierda, derecha) combinadas con variables `blend_position` vinculadas a la dirección del NavMesh en la fase de exploración.

## 5. Gestión de Datos y Guardado (Persistencia)

Dada la estructura narrativa (hitos de progreso y pérdida de personajes) y la necesidad de eficiencia, el sistema de guardado no utilizará JSON genérico, sino el sistema nativo de `Resource` de Godot, que es altamente performante, seguro de tipos y fácilmente manipulable desde el Editor.

### 5.1 Arquitectura de Guardado con Resources
Crearemos un script que extienda de `Resource` llamado `SaveData`.

```gdscript
# save_data.gd
extends Resource
class_name SaveData

@export var current_level : String
@export var player_position : Vector3
@export var inventory : Array[String] = []

# Diccionario para flags narrativos
@export var narrative_flags : Dictionary = {
    "zantyr_sacrificed": false,
    "zantyr_rescued": false,
    "first_seal_broken": false
}

# Estado del mundo
@export var cleared_dungeons : Array[String] = []
```

### 5.2 Lógica de Guardado y Carga
*   **Gestor de Guardado (Autoload `SaveManager`):** Se encargará de serializar este recurso utilizando `ResourceSaver.save(save_data, "user://savegame.tres")` para guardar la partida.
*   **Banderas Narrativas (Flags):** El diccionario `narrative_flags` será consultado por el `PartyManager` y el Level Design al inicio de cada escena. Si `zantyr_sacrificed` es `true`, el juego automáticamente ajustará el sistema de combate (deshabilitando el turno de Zantyr) y el gestor de IA instanciará a los enemigos correspondientes a la "Fase 2", sin importar si el jugador vuelve a visitar un área anterior.
*   **Seguridad:** Al utilizar formato binario (`.res`) o texto estructurado (`.tres`) en la carpeta `user://`, aseguramos un proceso de I/O de disco rápido y nativo sin la sobrecarga de un analizador JSON en cada hito narrativo.

---
## Registro de Cambios (Changelog)

- **[2026-06-19T14:26:00] - Antigravity (Technical Director):**
  - Refactorizado el sistema de personajes (`GameManager.gd` y `Level.gd`) para usar un `party_members` dinámico (Array), cumpliendo la Directiva 1.1 (Party System Modular).
  - Creada la clase base `Pet.gd` con la Máquina de Estados básica (`FOLLOW`, `IDLE`) para seguimiento dinámico de mascotas, cumpliendo la Directiva 1.2.
  - Añadida lógica preliminar al `HUD.gd` para manejar visualmente la pérdida de miembros de la party en el menú de pausa.
