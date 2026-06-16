# El Destello Escarlata

**El Destello Escarlata** es un videojuego de aventura y acción top-down en 2D desarrollado en **Godot Engine 4** con el sabor de los clásicos de 8 bits al puro estilo de *The Legend of Zelda*. Presenta mecánicas de intercambio de protagonistas en tiempo real (Zantyr y Aura), cooperación con un leal compañero canino (Choco), progresión de personajes RPG (tienda de mejoras), complejos puzles cooperativos y desafiantes combates contra jefes finales.

---

## 🌟 Características Principales

*   **Dualidad de Protagonistas (Relevo en Tiempo Real):** 
    *   **Zantyr:** Guerrero especializado en combate cuerpo a cuerpo. Utiliza ataques rápidos de espada que consumen estamina y hacen gran daño de área cercano.
    *   **Aura:** Hechicera de Biomagia especializada en ataques a larga distancia. Puede lanzar ráfagas de proyectiles mágicos y realizar un veloz dash (biotransporte) para esquivar ataques o cruzar abismos.
    *   *Alterna el control activo en cualquier momento pulsando la tecla `TAB`.*
*   **Indicador de Salud de Corazones (Hearts HUD):**
    *   La clásica barra de vida ProgressBar ha sido reemplazada por una barra de corazones vectoriales retro dibujados matemáticamente en tiempo real.
    *   Cada corazón representa **25 HP** y soporta fracciones de medio corazón.
    *   Aumenta dinámicamente tu fila de corazones al comprar mejoras de Salud Máxima.
*   **Síntesis de Audio Retro 8-Bits:**
    *   Sintetizador integrado por código (`SoundManager.gd`) que autogenera efectos retro de 8 bits en tiempo real para espada, magia, impactos, daño, cofres, errores y fanfarrias triunfales de puzles sin requerir archivos de sonido externos.
*   **Físicas de Combate Clásicas:**
    *   **Knockback (Retroceso):** Tanto los héroes como las sombras retroceden físicamente al ser golpeados.
    *   **Aturdimiento:** El personaje activo sufre un breve parón de control al recibir daño.
    *   **Screen Shake:** Temblor dinámico de cámara en impactos críticos o al recibir daño.
*   **Compañero Canino (Choco):**
    *   Choco sigue fielmente al personaje activo actual.
    *   Puedes ordenarle sentarse y esperar en una posición usando la tecla `X` para activar placas de presión mientras te mueves libremente.
*   **Objetos Rompibles (Arbustos y Jarras):**
    *   Arbustos en la cubierta y jarras de arcilla en camarotes/mazmorras bloquean el paso y pueden cortarse o romperse con tus ataques.
    *   Al romperse, sueltan partículas dinámicas de hojas o arcilla y tienen un 65% de probabilidad de soltar: **Corazones de Curación** (+25 HP), **Hojas de Estamina** (+30 Stamina) o **Esferas Oscuras**.
*   **Bloques Empujables y Puzles:**
    *   Piedras de puzle clásicas que el jugador puede empujar de forma cardinal.
    *   Las placas de presión aceptan y detectan el peso de los bloques para mantenerse activadas.
*   **Jefes Finales en Fases:**
    *   **Sombra de la Tempestad (Puerto):** Remolinos de velocidad y ráfagas radiales de proyectiles mágicos.
    *   **Malakor, el Resonante Corrupto (Bastián):** Batalla final de 3 fases: proyectiles Homing teledirigidos, fase de escudo con pilares de resonancia destructibles por separado (Aura a distancia sobre foso, Zantyr en cuerpo a cuerpo) y fase berserk en espiral.

---

## 🎮 Controles del Juego

*   **`W`, `A`, `S`, `D` / Flechas:** Mover al personaje activo.
*   **`Z` / Clic Izquierdo:** Ataque básico.
    *   Zantyr realiza un tajo de espada (sonido de espada).
    *   Aura dispara un proyectil de biomagia (sonido de magia).
*   **`TAB`:** Cambiar de personaje activo.
*   **`SPACE` / Clic Derecho:** Dash / Esquiva rápido.
*   **`X`:** Ordenar a Choco esperar ("Stay") o seguir ("Follow").
*   **`E`:** Interactuar con el entorno (NPCs, carteles, cofres, puertas).
*   **`ESC` / `P`:** Abrir el menú de pausa y la tienda de mejoras.
*   **`C`:** Consume 5 esferas para curarte 20 HP.

---

## 🗺️ Estructura de Niveles

1.  **Camarote de los Capitanes (`Camarote.tscn`):** Tutorial introductorio. Contiene jarras rompibles, placas y cofre con fanfarria.
2.  **Cubierta Principal (`mundo.tscn`):** Zona abierta llena de sombras agresivas y arbustos cortables.
3.  **Bodega de Carga (`Bodega.tscn`):** Rompecabezas secuencial de botones, aliados y jarras de soporte.
4.  **Muelles de Desembarco (`Puerto.tscn`):** Arena de emboscada y combate de minijefe.
5.  **El Bastián de Malakor (`Bastian.tscn`):** Mazmorra final cooperativa. Requiere usar a Aura para cruzar abismos, abrir la reja a Zantyr, y a Zantyr para empujar el bloque de piedra a la placa y desactivar la barrera de llamas de Aura para enfrentar juntos a Malakor.
