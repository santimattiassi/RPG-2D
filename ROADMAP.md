# ROADMAP y Directrices - "El Destello Escarlata"

## Visión General del Proyecto
**Título:** El Destello Escarlata
**Género:** RPG Táctico/Aventura, vista top-down 2D, estilo HD-2D (pixel art clásico con iluminación moderna).
**Tono:** Alta fantasía épica y marítima. Aventura seria y profunda, balanceada con la camaradería.
**Temas:** Liderazgo, transición de aprendiz a maestra, sacrificio heroico, lealtad.
**Mensaje:** Los lazos forjados superan la magia oscura y las tragedias.

### Resumen Narrativo
La historia sigue a la tripulación contra la magia oscura de Malakor.
- **Fase 1 (70% del juego):** Dinámica de dúo (Capitán Zantyr y maga Aura) + Mascotas (Orfeo el gato y Choco el perro).
- **El Punto de Inflexión:** Sacrificio heroico de Zantyr para salvar a la tripulación de Malakor.
- **Fase 2 (Desenlace):** Aura asume el rol de capitana. Adaptación al estilo de juego en solitario/nueva dinámica.
- **Clímax:** Rescate de Zantyr (sin memoria/habilidades de combate directas). Reencuentro emocional con Orfeo y Choco. Regresa como soporte/buffs para Aura en la batalla final.

---

## Fases de Desarrollo

### Fase 1: Prototipado y Bases del Sistema (Lo primero a desarrollar)
- **Motor:** Configuración inicial en Godot Engine 4 (`El Destello Escarlata/el-destello-escarlata/`).
- **Controles y Movimiento:** Sistema de movimiento básico.
- **Sistemas Base:** Implementación de la arquitectura base de combate táctico.
- **Mecánicas de Mascotas:** Sistemas de interacción de Orfeo (pistas/UI) y Choco (exploración/búsqueda).
- **Prototipo HD-2D:** Establecer el pipeline visual (sprites 2D + iluminación en entornos).

### Fase 2: Construcción de la Primera Mitad (Dúo Dinámico)
- **Combate de Dúo:** Sinergia entre la fuerza física de Zantyr y la magia de Aura.
- **Diseño de Niveles Iniciales:** Zonas costeras y mazmorras introductorias (Sello Oscuro).
- **Narrativa:** Presentación de la tripulación, el antagonista Malakor y misiones secundarias ligadas al lore.

### Fase 3: El Punto de Inflexión y Segunda Mitad (Aura Solitaria)
- **El Sacrificio:** Implementación narrativa y de jugabilidad del sacrificio de Zantyr.
- **Transición de Gameplay:** Rebalanceo del combate para que el jugador sienta la pérdida, debiendo adaptar su estilo de juego solo con Aura.
- **Niveles Avanzados:** Entornos corrompidos por el Sello Oscuro, mayor exigencia táctica.

### Fase 4: Desenlace y Pulido
- **Batalla Final:** Implementación de Zantyr como sistema de buffs/soporte táctico para Aura.
- **Cinemáticas:** Encuentro emocional (Orfeo y Choco reconociendo a Zantyr).
- **Balance Final:** Ajustes de ritmo (no grindfest), progresión atada a historia.
- **QA y Corrección de Bugs:** Pulido visual, de combate y de iluminación.

---

## Directrices para las Instancias de Agentes

### 1. Game Designer
- **Enfoque:** Evolución del gameplay. Debes asegurar que el juego se sienta muy distinto al controlar al dúo Zantyr/Aura frente a controlar solo a Aura tras la pérdida.
- **Mascotas:** Diseñar las interacciones donde Orfeo funcione como un guía (tipo "Navi") para pistas vitales de mundo y combate, y Choco actúe como ayuda directa para resolver acertijos y encontrar objetos.
- **Progreso:** Diseñar el progreso y recompensas ligados estrictamente a la historia. **No hacer un juego de farmeo infinito (Grindfest).**

### 2. Narrative Designer / Writer
- **Enfoque:** Mantener el tono de fantasía épica seria, complementado con la calidez de la camaradería. **Nada de comedia caricaturesca o parodias constantes.**
- **Desarrollo de Personajes:** Enfocarse en el arco de transición de aprendiz a maestra de Aura, la carga del liderazgo, el sacrificio de Zantyr y la lealtad de la tripulación animal.
- **Misiones:** Asegurar que toda historia secundaria aporte al lore de la tripulación o a la amenaza que supone Malakor.
- **Protagonista No Invencible:** Plasmar narrativamente la sensación de progresión y la posterior pérdida.

### 3. Level Designer
- **Enfoque:** Traducción de las mecánicas tácticas a la topografía del mundo.
- **Exploración:** Proveer oportunidades claras donde Choco sea necesario (objetos ocultos, puzles del entorno) y zonas donde el jugador deba depender de las advertencias de Orfeo.
- **Atmósfera:** Los niveles no deben caer en oscuridad absoluta ("Grimdark"). El mundo debe ser vibrante; el mal es una amenaza a superar, no una realidad deprimente.

### 4. Art Director
- **Enfoque:** Lograr la inmersión visual nostálgica pero moderna ("HD-2D").
- **Iluminación:** Usar la iluminación moderna para resaltar la magia arcana de Aura, embellecer los escenarios costeros y contrastar claramente la corrupción del Sello oscuro en los enemigos.
- **Diseño de Personajes:** Asegurarse de que el rediseño de Zantyr en el late-game refleje su pérdida y su nuevo rol de apoyo, manteniendo la expresividad en pixel art.

### 5. Technical Designer / Programmer
- **Enfoque:** Estructuración sólida de sistemas en Godot 4.
- **Flexibilidad:** Programar sistemas de combate, party manager y habilidades que permitan transicionar fluidamente de tener 2 personajes controlables, a 1 solo, y luego a 1 + mecánicas de soporte (Zantyr en late-game).
- **Pipeline HD-2D:** Implementar los shaders y técnicas de iluminación necesarios para lograr la estética deseada manteniendo el rendimiento.

### 6. QA Designer
- **Enfoque:** Coherencia narrativa vs jugabilidad, y balance de ritmo de juego.
- **Testing de Experiencia:** Comprobar que el cambio de gameplay al perder a Zantyr no resulte frustrante, sino narrativamente impactante.
- **Accesibilidad:** Asegurar que las pistas de Orfeo sean claras y útiles, y que el alto contraste de iluminación no perjudique la lectura visual del entorno o el combate táctico.