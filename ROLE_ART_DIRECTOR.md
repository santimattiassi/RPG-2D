# Rol: Director de Arte - "El Destello Escarlata"

Este documento define la visión artística, las directrices visuales y las especificaciones técnicas para los activos del RPG "El Destello Escarlata". Está diseñado para guiar a los artistas y servir como referencia cruzada para los departamentos de Game Design, Narrativa y Level Design, asegurando una coherencia estética que potencie el tono de fantasía marítima y el desarrollo de la trama.

---

## 1. Estilo Visual General (HD-2D)

**Estética y Dirección de Arte**
El juego adoptará un estilo visual "HD-2D", caracterizado por la integración de:
*   **Personajes:** Sprites en pixel art de 32-bit, con animaciones claras y siluetas legibles.
*   **Entornos:** Escenarios de exploración terrestre con temática marítima (ruinas costeras, bosques, puertos, y eventualmente la taberna/barco).
*   **Iluminación y Efectos:** Uso de técnicas de renderizado modernas. Sombras dinámicas proyectadas por los sprites en pixel art, post-procesamiento para bloom en efectos mágicos y ajustes de color dinámicos (Color Grading).

**Atmósfera y Evolución de Color (Conexión Narrativa/Niveles)**
La paleta de colores y la iluminación deben contar la historia de la corrupción de "El Sello", acompañando el avance por los escenarios definidos en el `LEVEL_DESIGN.md` y `NARRATIVE_DESIGN.md`:
*   **Fase 1 (Prólogo y Viaje Inicial):** Paleta vibrante y aventurera. Predominancia de azules marinos profundos, dorados cálidos (como el sol sobre la madera de los barcos o la taberna de Elina), y blancos frescos. Sensación de exploración clásica.
*   **Fase 2 (Profundización en los dominios del Sello):** Transición hacia la corrupción. La iluminación se vuelve más dura y direccional. Se introducen sombras opresivas que contrastan con los tonos originales.
*   **Fase 3 (Corazón de la Corrupción y Clímax):** Sustitución de los colores vibrantes por tonos enfermizos. Dominancia del carmesí oscuro, violetas antinaturales y verdes tóxicos. El entorno debe sentirse claustrofóbico visualmente.

---

## 2. Dirección de Personajes Principales

El diseño visual de los personajes debe comunicar mecánicas de gameplay (`ROLE_GAME_DESIGNER.md`) y su peso narrativo.

### Aura (Protagonista y Maga Arcana)
*   **Diseño Inicial (Acto I):** Atuendo práctico y aventurero de maga de tripulación. Colores que reflejen su conexión con la magia biomágica limpia. Debe transmitir ligereza y agilidad.
*   **Evolución (Acto III - "La Capitana"):** Su diseño debe cambiar visualmente para reflejar el peso del liderazgo y la pérdida. Debería incorporar un elemento visual distintivo tomado de Zantyr tras su sacrificio (ej. usar parte de su capa raída o un broche de su armadura). La postura idle debe volverse más firme y decidida.

### Zantyr (Capitán Original y Tanque)
*   **Diseño (Actos I y II):** Robusto y ancho. Su silueta debe ser el doble de imponente que la de Aura para comunicar instantáneamente su rol de protector físico. Armadura pesada y utilitaria, mostrando claro desgaste y corrosión por la sal del mar y el combate. Debe parecer un muro infranqueable.
*   **Estado Final (Acto III - Amnésico/Apoyo):** Cuando regresa como soporte, su diseño no debe ser agresivo. Aunque conserva su armadura, su postura debe ser vacía/distraída en idle, activándose únicamente para defender por puro instinto.

### Elina (El Anclaje Emocional)
*   **Diseño:** Colores cálidos, ropa de tabernera/comerciante (tonos terracota, linos). Sin embargo, debe tener detalles utilitarios sutiles (ej. un brazalete de cuero reforzado o dagas ocultas) que denoten que, aunque es un NPC de zona segura, sobrevive en un mundo hostil.

### Orfeo (Gato) y Choco (Perro)
*   **Rol de Legibilidad Visual:** Dado que la cámara será táctica/isométrica (top-down) y los escenarios se volverán oscuros, **sus diseños deben tener colores o detalles de altísimo contraste**.
*   **Orfeo:** Podría ser un gato negro pero con ojos o marcas que brillen (luz emisiva sutil) de color cian o dorado al detectar magia/trampas.
*   **Choco:** Un perro de complexión ágil y colores tierra, posiblemente llevando un pañuelo brillante o un pequeño farol/cristal en el collar que lo haga destacar contra el suelo lodoso oscuro.

### Enemigos (Marineros Corruptos) y Malakor
*   **Diseño:** Deformación provocada por la magia corruptora marítima. Mutaciones que fusionan la anatomía humana con elementos del mar abisal (coral negro adherido a la piel, extremidades reemplazadas por tentáculos mágicos semitransparentes, ojos que emiten un brillo vacío antinatural).
*   **Malakor:** La silueta máxima de esta corrupción. Una amalgama grotesca que absorbe la luz a su alrededor, usando el carmesí y violeta como colores primarios de amenaza.

---

## 3. Especificaciones Técnicas y Prompts (Generación de Activos)

Los activos iniciales (imágenes semilla) se generarán mediante IA/Artistas para luego ser adaptados como hojas de sprites completas utilizando herramientas automatizadas como el **LPC Generator** (Liberated Pixel Cup Generator).

### Especificaciones Base (Para todos los Prompts)
Para asegurar que las herramientas de automatización de spritesheets funcionen correctamente, *todos* los pedidos de arte semilla deben adherirse estrictamente a lo siguiente:
*   **Formato de Salida:** Pixel art puro de 32-bit. Sin desenfoques (anti-aliasing) en los bordes internos.
*   **Perspectiva:** De frente (Front-facing), sin ángulos de picado extremos.
*   **Pose:** Idle (Postura de reposo natural, pies en el suelo, brazos a los lados o en postura base).
*   **Fondo:** Verde puro (`#00FF00` Chroma/Green Screen) para facilitar la extracción automatizada y recorte de la silueta.
*   **Especificación Técnica Adicional:** Mantener los bordes de la silueta limpios. Se recomienda un lienzo base inicial de 64x64 o 128x128 píxeles (antes de escalar) para garantizar proporciones que encajen en una cuadrícula (Grid) clásica. En caso de requerir ajuste manual post-generación, el diseño no debe superponer elementos complejos sobre la cara u hombros para facilitar la separación de capas (cabeza, torso, piernas) en el LPC Generator.

### Lista de Prompts de Generación

#### 1. Aura (Protagonista/Maga)
*   **Prompt Descriptivo:** "Pixel art 32-bit de una joven maga aventurera de frente. Postura de reposo (idle). Lleva ropa de marinera práctica combinada con túnicas ligeras de magia, colores azul marino brillante, dorado y blanco. Expresión decidida. Estilo RPG clásico japonés."
*   **Instrucciones Técnicas:** "Perspectiva puramente frontal. Fondo verde Chroma sólido (#00FF00). Silueta limpia, colores planos para pixel art sin bordes difuminados."

#### 2. Zantyr (Tanque/Capitán)
*   **Prompt Descriptivo:** "Pixel art 32-bit de un guerrero veterano muy robusto y ancho, vista de frente. Postura de reposo (idle). Lleva una armadura pesada desgastada por el mar, con detalles de óxido y sal. Tonos acero oscuro y tela roja raída. Transmite la sensación de un muro defensivo impenetrable."
*   **Instrucciones Técnicas:** "Perspectiva puramente frontal. Fondo verde Chroma sólido (#00FF00). La proporción debe ser ancha. Borde de silueta nítido."

#### 3. Elina (Tabernera)
*   **Prompt Descriptivo:** "Pixel art 32-bit de una mujer acogedora pero resistente de frente. Postura de reposo (idle). Lleva ropa de tabernera en tonos terracota cálidos y lino, con delantal, y un brazalete de cuero reforzado sutil. Estilo RPG clásico."
*   **Instrucciones Técnicas:** "Perspectiva puramente frontal. Fondo verde Chroma sólido (#00FF00). Diseño limpio en la zona del torso para fácil separación de sprites."

#### 4. Orfeo (Mascota - Gato)
*   **Prompt Descriptivo:** "Pixel art 32-bit de un gato negro de frente. Postura de reposo (idle). Tiene ojos grandes y marcas mágicas sutiles que brillan en color cian luminoso. Debe destacar mucho para vista isométrica."
*   **Instrucciones Técnicas:** "Perspectiva puramente frontal. Fondo verde Chroma sólido (#00FF00). Alto contraste entre el pelaje negro y el brillo cian. Sprite de tamaño menor ajustado a cuadrícula de mascotas."

#### 5. Choco (Mascota - Perro)
*   **Prompt Descriptivo:** "Pixel art 32-bit de un perro ágil de colores tierra (marrón claro) de frente. Postura de reposo (idle). Lleva un pequeño pañuelo rojo brillante al cuello. Aspecto amigable y rastreador."
*   **Instrucciones Técnicas:** "Perspectiva puramente frontal. Fondo verde Chroma sólido (#00FF00). Colores planos y saturados para máxima visibilidad en fondos oscuros."

#### 6. Enemigo Base (Marinero Corrompido)
*   **Prompt Descriptivo:** "Pixel art 32-bit de un marinero zombi mutado de frente. Postura de reposo (idle) ligeramente encorvada. Su cuerpo fusiona anatomía humana con elementos del abismo marino: coral negro incrustado y ojos que emiten un brillo púrpura vacío."
*   **Instrucciones Técnicas:** "Perspectiva puramente frontal. Fondo verde Chroma sólido (#00FF00). Uso de paleta de colores de corrupción (violeta y verde tóxico) contrastando con gris muerto. Evitar formas que difuminen la silueta externa."

---

## 4. Efectos Visuales (VFX) Clave y Magia

El lenguaje visual de los efectos de hechizos es vital para comunicar el estado del mundo en combate:

*   **Magia Arcana (Aura):** Debe sentirse **limpia, estructurada y precisa**. Los efectos visuales de sus ataques y curaciones utilizarán líneas definidas, colores puros (blancos azulados, luz dorada) y formas geométricas estables. Emiten una luz que ilumina claramente el entorno.
*   **Magia de Corrupción (Malakor / Enemigos):** Debe verse **caótica, orgánica y destructiva**. Sus ataques no tienen forma definida; se asemejan a líquidos oscuros, humo espeso o tentáculos sombríos. Al impactar, **deben parecer que "manchan" temporalmente el escenario** (usando decals en el suelo o partículas residuales de color púrpura oscuro o fango). Su iluminación es sustractiva (parece tragar la luz alrededor) o enfermiza.
