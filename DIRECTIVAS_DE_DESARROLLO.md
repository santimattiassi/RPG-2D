# Directivas Interdepartamentales: Implementación del Game Design
**Proyecto:** El Destello Escarlata

Como Game Designer, la transición mecánica de "Dúo" a "Solo Aura" y el uso activo de las mascotas exigen que los demás departamentos técnicos y artísticos alineen su trabajo con la psicología del jugador. A continuación se detallan las directivas obligatorias para cada área de desarrollo en base a las decisiones de Game Design.

---

### 1. Directivas para Programadores (Technical Design)

**1.1. Arquitectura Modular del "Party System":**
El código del sistema de combate y el Party Manager deben estar preparados para transiciones dinámicas y no "hardcodeados" a 2 personajes.
*   *Fase 1:* Sistema de input dual / tag-team activo.
*   *Fase 2:* Desacople del segundo jugador sin romper los scripts de targeting de los enemigos (el aggro debe redirigirse automáticamente al entorno o a Aura).
*   *Fase 3:* Acople pasivo. Zantyr no es un agente de daño, sino una entidad que aplica modificadores estadísticos de área ("Aura de Liderazgo") y cuenta con colisiones pasivas (Shielding).

**1.2. IA y Comportamiento de Mascotas:**
*   *Orfeo (Escáner/Detector):* Programar un Raycast o Área de detección en los enemigos y trampas. Al interactuar con él en combate, debe devolver un String del `Resource` del enemigo (Debilidades). En exploración, si detecta un nodo de trampa en su radio, debe reproducir una animación de "alerta" y pausar su movimiento.
*   *Choco (Explorador):* Requiere un State Machine robusto (Follow, Wait, Search, Dig). El modo "Rastreo" requiere un sistema de Pathfinding o "migas de pan" invisibles que solo se renderizan cuando el estado de Choco está activo.

---

### 2. Directivas para Level Designers (Diseño de Niveles)

La topografía debe educar al jugador y acompañar la transición de las mecánicas de combate.

**2.1. Adaptación Topográfica (Fase 1 vs Fase 2):**
*   *Niveles Fase 1 (Dúo):* Arenas más abiertas. Permitir que Zantyr gane "aggro" en el centro mientras Aura tiene puntos de ventaja claros (high ground) para disparar con seguridad.
*   *Niveles Fase 2 (Solo Aura):* Aumentar la densidad de cuellos de botella (choke points). Aura no tiene un tanque, por lo que el nivel DEBE proveer herramientas defensivas: barriles, trampas naturales, pasillos estrechos para agrupar enemigos y usar daño de área, y coberturas para "kiting".

**2.2. Diseño de Puzles y Mascotas:**
*   Los puzles no deben ser bloques genéricos empujables todo el tiempo. Crear secciones de nivel donde el jugador físicamente no quepa (huecos en paredes, madrigueras) para justificar y recompensar el uso de Choco.

---

### 3. Directivas para Arte y UI (Art Director)

**3.1. Feedback Visual de la Pérdida:**
*   Cuando Zantyr se sacrifica (Fase 2), **NO** borren su UI del HUD. Dejen el marco de sus corazones y su retrato oscurecido, agrietado o con estática roja. Psicológicamente, la UI debe recordarle al jugador constantemente qué es lo que falta.

**3.2. Legibilidad de las Mascotas:**
*   Asegurar que el feedback visual de Orfeo (cuando detecta una trampa) sea obvio en el estilo HD-2D. Usar un ícono de alerta ("!" estilo clásico) o un brillo distintivo que no se mezcle con los hechizos de combate, ya que es información vital para el jugador.

---

### 4. Directivas para Narrativa (Narrative Designer)

**4.1. Integración Mecánica-Narrativa:**
*   El sacrificio de Zantyr debe ocurrir narrativamente justo después de que el jugador se sienta más cómodo usándolo como "muleta" para evitar el daño.
*   *Choco y la Soledad:* Escribir micro-interacciones (sin voz, solo texto o animaciones) para cuando Aura descanse en campamentos durante la Fase 2. Acariciar a Choco o que Orfeo duerma a su lado es crucial para mitigar la crudeza del mundo ("Grimdark moderado").