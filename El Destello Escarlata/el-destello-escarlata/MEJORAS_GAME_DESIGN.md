# Documento de Game Design (GDD): Psicología y Evolución de Mecánicas
**Proyecto: El Destello Escarlata (Alineado con el ROADMAP.md y lore base)**

Este documento traduce la narrativa épica marítima de El Destello Escarlata y la psicología del jugador en sistemas jugables interactivos dentro de Godot.

---

### 1. El Core Loop: Terrestre vs. Naval

**El Enfoque Psicológico:** El jugador necesita un marco de referencia estable (core loop) para que, cuando ocurran eventos excepcionales, se sientan realmente épicos.
*   **Combate Terrestre (Core Loop - 90%):** La exploración y combate táctico ocurren a pie en ruinas y bosques corruptos. Aquí el jugador desarrolla maestría en las sinergias de personaje.
*   **Set Pieces Navales (Eventos Excepcionales - 10%):** Son eventos de alta tensión. El jugador abandona el control individual para defender el barco (ej. operar balistas, esquivar tentáculos). Psicológicamente, rompen la monotonía y actúan como "exámenes" de tensión que elevan la escala del conflicto.

---

### 2. Sistema de Combate Evolutivo (Las 3 Fases de Adaptación)

La mecánica principal del juego es la **Adaptación a la Pérdida y Reencuentro**.

#### Fase 1: El Dúo Dinámico (Seguridad y Poder)
*   **Diseño:** El jugador tiene el control absoluto. Zantyr actúa como Tanque (habilidades de Provocación/Aggro y control de terreno), mientras que Aura es la Artillera (daño masivo de área con tiempos de casteo).
*   **Situación Tipo:** Zantyr usa "Grito de Provocación" para agrupar monstruos corruptos. Aura carga su magia a salvo durante 2 turnos (o segundos) y limpia la zona. El jugador se siente invencible trabajando en equipo.

#### Fase 2: La Pérdida (Vulnerabilidad y Entorno)
*   **Diseño:** Zantyr se sacrifica. Aura queda sola. Psicológicamente, el jugador experimenta pánico inicial, pero el diseño debe empoderarlo mediante táctica.
*   **Evolución:** Como Aura no tiene a su escudo humano, las mecánicas de las mazmorras cambian. El jugador debe usar "Kiting" (atacar y correr), colocar **trampas mágicas**, usar cuellos de botella del terreno y manipular el entorno a su favor.
*   **Efecto:** La transición convierte a Aura de una "arma de asedio" a una verdadera líder táctica.

#### Fase 3: El Regreso Condicionado (Recompensa Emocional)
*   **Diseño:** Zantyr vuelve, pero no puede pelear. Actúa como **Soporte/Buff pasivo y activo**.
*   **Mecánica:** Zantyr no ataca, pero sigue protegiendo a Aura a su manera. Si Aura se queda quieta junto a Zantyr, recibe un "Aura de Concentración" (aumenta daño o reduce maná). Él puede bloquear proyectiles con su cuerpo. Es el cierre del arco de personajes traducido a mecánicas.

---

### 3. Sistema de Exploración: La Tripulación Animal

Orfeo y Choco no son simples mascotas; son los puentes entre el jugador y el entorno, diseñados para recompensar la curiosidad.

#### Sistema Guía: Orfeo (El Gato Táctico)
*   **Escáner de Debilidades:** En combate, interactuar con Orfeo revela las debilidades elementales o tácticas de monstruos nuevos (Ej: "La coraza de esa bestia es inmune a tu magia frontal, Aura. Busca su espalda").
*   **Detector de Peligro (Trampas/Emboscadas):** En mazmorras, si el jugador avanza hacia un suelo con runas explosivas invisibles o una habitación con una emboscada en el techo, Orfeo se eriza y lanza un maullido distintivo, salvando recursos del jugador si presta atención.

#### Sistema de Interacción: Choco (El Perro Explorador)
*   **Puzzles Activos:** Choco es indispensable para progresar en tierra. El jugador puede ordenarle pasar por huecos en la pared donde los humanos no caben, para recuperar llaves o activar palancas.
*   **Rastreo y Búsqueda:** Choco tiene un "modo rastreo". Puede seguir el rastro invisible de los corruptos por el Sello, o desenterrar artefactos escondidos que reemplazan el farmeo (grind) con recompensas de progresión (Milestone Leveling).