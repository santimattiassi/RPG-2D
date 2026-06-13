# El Destello Escarlata

**El Destello Escarlata** es un videojuego de aventura y acción top-down en 2D desarrollado en **Godot Engine 4** inspirado en clásicos como *The Legend of Zelda*. Presenta mecánicas de intercambio de protagonistas en tiempo real (Zantyr y Aura), cooperación con un leal compañero canino (Choco), progresión de personajes RPG (tienda de mejoras), complejos puzles cooperativos y desafiantes combates contra jefes finales.

---

## 🌟 Características Principales

*   **Dualidad de Protagonistas (Relevo en Tiempo Real):** 
    *   **Zantyr:** Guerrero especializado en combate cuerpo a cuerpo. Utiliza ataques rápidos de espada que consumen estamina y hacen gran daño de área cercano.
    *   **Aura:** Hechicera de Biomagia especializada en ataques a larga distancia. Puede lanzar ráfagas de proyectiles mágicos y realizar un veloz dash (biotransporte) para esquivar ataques o cruzar abismos.
    *   *Alterna el control activo en cualquier momento pulsando la tecla `TAB`.*
*   **Compañero Canino (Choco):**
    *   Choco sigue fielmente al personaje activo actual.
    *   Puedes ordenarle sentarse y esperar en una posición usando la tecla `X`. Esto permite activar placas de presión pesadas mientras el jugador se mueve libremente.
    *   Choco posee físicas de paso libre a través del jugador para evitar obstrucciones, pero interactúa con interruptores de presión.
*   **Progresión RPG e Interfaz de Pausa:**
    *   Consigue esferas oscuras derrotando enemigos o abriendo cofres.
    *   Abre el menú pulsando `ESC` o `P` para pausar la partida, revisar tus estadísticas actuales y comprar mejoras permanentes:
        *   **Salud Máxima** (+50 HP)
        *   **Daño Físico (Zantyr)** / **Daño de Hechizo (Aura)** (+10 de Daño)
        *   **Estamina Máxima** (+50 Estamina)
        *   **Disparo Triple de Aura** (dispara tres proyectiles mágicos en abanico)
*   **Enemigos Inteligentes y Spawners:**
    *   Las sombras invaden los niveles mediante generadores dinámicos que se detienen temporalmente cerca de Aura para evitar muertes injustas al spawnear.
    *   Variedad de enemigos:
        *   **Sombra Común (Gris):** Estadísticas equilibradas.
        *   **Sombra Veloz (Morada):** Extremadamente rápidas, poca vida.
        *   **Sombra Robusta (Negra):** Gigantescos tanques que infligen gran daño cuerpo a cuerpo.
        *   **Sombras Rangers / Contrabandistas (Rojo/Naranja):** Evitan el contacto directo disparando proyectiles desde la distancia.
*   **Combates de Jefes en Fases:**
    *   **Sombra de la Tempestad (Puerto):** Invoca torbellinos de velocidad y ráfagas radiales de proyectiles, además de llamar esbirros al verse acorralado.
    *   **Malakor, el Resonante Corrupto (Bastián):** El jefe final definitivo. Posee proyectiles teledirigidos (Homing) en Fase 1, un Escudo de Inmunidad Resonante alimentado por pilares distantes en Fase 2 (requiere dividirse para romperlos), y una Fase 3 Berserk con ráfagas continuas de proyectiles en espiral y velocidad duplicada.

---

## 🎮 Controles del Juego

*   **`W`, `A`, `S`, `D` / Flechas:** Mover al personaje activo.
*   **`Z` / Clic Izquierdo:** Ataque básico.
    *   Zantyr realiza un tajo de espada.
    *   Aura dispara un proyectil de biomagia.
*   **`TAB`:** Cambiar de personaje activo.
*   **`SPACE` / Clic Derecho:** Dash / Esquiva rápido.
*   **`X`:** Ordenar a Choco esperar ("Stay") o seguir ("Follow").
*   **`E`:** Interactuar con el entorno (NPCs, carteles, cofres, puertas).
*   **`ESC` / `P`:** Abrir el menú de pausa y la tienda de mejoras.

---

## 🗺️ Estructura de Niveles

1.  **Camarote de los Capitanes (`Camarote.tscn`):** Tutorial introductorio. Explica el uso de cofres, llaves y la interacción base.
2.  **Cubierta Principal (`mundo.tscn`):** El exterior del barco. Zona abierta repleta de combates contra las distintas variantes de sombras.
3.  **Bodega de Carga (`Bodega.tscn`):** Nivel cerrado de puzzles. Conoce a Elina (quien cura gratis tus heridas) y a Orfeo (el gato parlante que te dará pistas). Debes activar el mecanismo en orden: Botón Izquierdo -> Placa con Choco -> Botón Derecho para abrir la escotilla.
4.  **Muelles de Desembarco (`Puerto.tscn`):** Zona de emboscada. Una verja de acero se cierra a tu espalda y debes derrotar a la Sombra de la Tempestad para abrir el muelle de escape.
5.  **El Bastián de Malakor (`Bastian.tscn`):** La mazmorra cooperativa final. Usa a Aura para parpadear sobre el foso y disparar al cristal de energía para liberar a Zantyr. Zantyr deberá pisar la placa para disolver la barrera de llamas de Aura. Juntos deberán adentrarse al salón del trono y derrotar a Malakor para salvar El Destello Escarlata.

---

## 🛠️ Detalles Técnicos y Desarrollo

*   **Motor:** Godot Engine 4.x
*   **Lenguaje:** GDScript
*   **Seguridad en Diálogos:** Durante los diálogos y lecturas de carteles, toda la física del juego se pausa, los proyectiles se congelan y los enemigos no pueden infligir daño ni moverse.
*   **Activación Controlada de Jefes:** Los jefes no se mueven ni activan sus barras de vida en el HUD hasta que los jugadores cruzan la línea de activación física en la arena de combate.
*   **Legibilidad Visual:** Las modulaciones de color de los mapas de la bodega, el puerto y el castillo final han sido refinados para mejorar significativamente el brillo y contraste del escenario sin perder la atmósfera oscura y mística característica de cada zona.
