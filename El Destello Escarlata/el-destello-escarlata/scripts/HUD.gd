extends CanvasLayer

@onready var hp_bar = $HealthBar
@onready var stamina_bar = $StaminaBar
@onready var fragment_label = $FragmentLabel
@onready var key_label = $KeyLabel
@onready var prompt_label = $InteractionPrompt
@onready var dialogue_panel = $DialoguePanel
@onready var speaker_label = $DialoguePanel/SpeakerLabel
@onready var dialogue_label = $DialoguePanel/DialogueLabel
@onready var overlay = $Overlay
@onready var message = $Overlay/Message
@onready var retry_button = $Overlay/RetryButton
@onready var transition_rect = $TransitionOverlay

# Menú de Pausa y Progresión RPG
@onready var pause_menu = $PauseMenu
@onready var health_lbl = $PauseMenu/LeftPanel/HealthLabel
@onready var stamina_lbl = $PauseMenu/LeftPanel/StaminaLabel
@onready var zantyr_dmg_lbl = $PauseMenu/LeftPanel/ZantyrDmgLabel
@onready var aura_dmg_lbl = $PauseMenu/LeftPanel/AuraDmgLabel
@onready var spheres_lbl = $PauseMenu/LeftPanel/SpheresLabel

@onready var btn_health = $PauseMenu/RightPanel/BtnHealth
@onready var lbl_health_cost = $PauseMenu/RightPanel/LblHealthCost

@onready var btn_damage = $PauseMenu/RightPanel/BtnDamage
@onready var lbl_damage_cost = $PauseMenu/RightPanel/LblDamageCost

@onready var btn_stamina = $PauseMenu/RightPanel/BtnStamina
@onready var lbl_stamina_cost = $PauseMenu/RightPanel/LblStaminaCost

@onready var btn_triple = $PauseMenu/RightPanel/BtnTriple
@onready var lbl_triple_cost = $PauseMenu/RightPanel/LblTripleCost

@onready var close_button = $PauseMenu/CloseButton

# Barra de Jefe
@onready var boss_bar_container = $BossBarContainer
@onready var boss_health_bar = $BossBarContainer/BossHealthBar
@onready var boss_name_label = $BossBarContainer/BossNameLabel

var dialogue_lines: Array = []
var dialogue_speaker: String = ""
var current_line_index: int = 0
var dialogue_callback: Callable = Callable()

func _ready() -> void:
	retry_button.pressed.connect(_on_retry_pressed)
	dialogue_panel.visible = false
	if prompt_label:
		prompt_label.visible = false
	
	# Ocultar barra de vida ProgressBar anterior e instanciar Corazones
	hp_bar.visible = false
	var hearts_scene = load("res://scripts/HeartsContainer.gd")
	if hearts_scene:
		var hearts = hearts_scene.new()
		hearts.name = "HeartsContainer"
		hearts.position = Vector2(20, 20)
		add_child(hearts)
	
	# Conexión de botones de Pausa
	close_button.pressed.connect(toggle_pause)
	btn_health.pressed.connect(_on_buy_health)
	btn_damage.pressed.connect(_on_buy_damage)
	btn_stamina.pressed.connect(_on_buy_stamina)
	btn_triple.pressed.connect(_on_buy_triple)
	pause_menu.visible = false

func _process(_delta: float) -> void:
	stamina_bar.max_value = GameManager.max_stamina
	stamina_bar.value = GameManager.current_stamina
	
	if fragment_label:
		fragment_label.text = "Esferas Oscuras: " + str(GameManager.fragments)
		
	if key_label:
		key_label.text = "Llaves: " + str(GameManager.keys)
		
	if GameManager.fragments >= 20 and not overlay.visible:
		show_end_screen(true)

func start_dialogue(speaker: String, lines: Array, on_complete: Callable = Callable()) -> void:
	dialogue_speaker = speaker
	dialogue_lines = lines
	current_line_index = 0
	dialogue_callback = on_complete
	GameManager.is_dialogue_active = true
	
	hide_prompt() # Ocultar prompt para no obstruir el diálogo
	dialogue_panel.visible = true
	_show_current_line()

func _show_current_line() -> void:
	speaker_label.text = dialogue_speaker
	dialogue_label.text = dialogue_lines[current_line_index]

func advance_dialogue() -> void:
	current_line_index += 1
	if current_line_index < dialogue_lines.size():
		_show_current_line()
	else:
		_close_dialogue()

func _close_dialogue() -> void:
	dialogue_panel.visible = false
	GameManager.is_dialogue_active = false
	if dialogue_callback.is_valid():
		dialogue_callback.call()

func show_prompt(msg: String) -> void:
	if prompt_label:
		prompt_label.text = "[E] " + msg
		prompt_label.visible = true

func hide_prompt() -> void:
	if prompt_label:
		prompt_label.visible = false

func _unhandled_input(event: InputEvent) -> void:
	# Abrir o cerrar pausa con ESC o P
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_ESCAPE or event.keycode == KEY_P:
			# Evitar pausar si hay diálogo activo o pantalla de fin de juego visible
			if not GameManager.is_dialogue_active and not overlay.visible:
				get_viewport().set_input_as_handled()
				toggle_pause()
				return
				
	if GameManager.is_dialogue_active:
		if event is InputEventKey and event.pressed and event.keycode == KEY_E:
			get_viewport().set_input_as_handled()
			advance_dialogue()

func toggle_pause() -> void:
	var is_paused = get_tree().paused
	get_tree().paused = not is_paused
	pause_menu.visible = not is_paused
	
	if pause_menu.visible:
		update_pause_menu_ui()

func update_pause_menu_ui() -> void:
	health_lbl.text = "Vida Máxima: " + str(GameManager.max_health)
	stamina_lbl.text = "Estamina Máxima: " + str(GameManager.max_stamina)
	zantyr_dmg_lbl.text = "Tajo de Zantyr (Daño): " + str(GameManager.zantyr_damage)
	aura_dmg_lbl.text = "Fuego de Aura (Daño): " + str(GameManager.aura_damage)
	spheres_lbl.text = "Esferas Oscuras Disponibles: " + str(GameManager.fragments)
	
	# Vida Extra
	if GameManager.upgrade_health_bought:
		btn_health.disabled = true
		lbl_health_cost.text = "¡COMPRADO!"
		lbl_health_cost.modulate = Color.GOLD
	else:
		btn_health.disabled = GameManager.fragments < 10
		lbl_health_cost.text = "Costo: 10 Esferas"
		lbl_health_cost.modulate = Color(0.6, 0.8, 0.6)
		
	# Daño Extra Zantyr
	if GameManager.upgrade_damage_bought:
		btn_damage.disabled = true
		lbl_damage_cost.text = "¡COMPRADO!"
		lbl_damage_cost.modulate = Color.GOLD
	else:
		btn_damage.disabled = GameManager.fragments < 15
		lbl_damage_cost.text = "Costo: 15 Esferas"
		lbl_damage_cost.modulate = Color(0.6, 0.8, 0.6)
		
	# Estamina Extra
	if GameManager.upgrade_stamina_bought:
		btn_stamina.disabled = true
		lbl_stamina_cost.text = "¡COMPRADO!"
		lbl_stamina_cost.modulate = Color.GOLD
	else:
		btn_stamina.disabled = GameManager.fragments < 10
		lbl_stamina_cost.text = "Costo: 10 Esferas"
		lbl_stamina_cost.modulate = Color(0.6, 0.8, 0.6)
		
	# Disparo Triple Aura
	if GameManager.upgrade_triple_shoot_bought:
		btn_triple.disabled = true
		lbl_triple_cost.text = "¡COMPRADO!"
		lbl_triple_cost.modulate = Color.GOLD
	else:
		btn_triple.disabled = GameManager.fragments < 15
		lbl_triple_cost.text = "Costo: 15 Esferas"
		lbl_triple_cost.modulate = Color(0.6, 0.8, 0.6)

func _on_buy_health() -> void:
	if GameManager.buy_upgrade_health():
		hp_bar.max_value = GameManager.max_health
		hp_bar.value = GameManager.current_health
		update_pause_menu_ui()

func _on_buy_damage() -> void:
	if GameManager.buy_upgrade_damage():
		update_pause_menu_ui()

func _on_buy_stamina() -> void:
	if GameManager.buy_upgrade_stamina():
		stamina_bar.max_value = GameManager.max_stamina
		stamina_bar.value = GameManager.current_stamina
		update_pause_menu_ui()

func _on_buy_triple() -> void:
	if GameManager.buy_upgrade_triple_shoot():
		update_pause_menu_ui()

func show_end_screen(win: bool) -> void:
	overlay.visible = true
	get_tree().paused = true # Pausar el juego
	if win:
		var current_scene = get_tree().current_scene
		if current_scene and current_scene.name == "Bastian":
			message.text = "¡EL DESTELLO ESCARLATA\nHA SIDO SALVADO!"
			message.modulate = Color(1.0, 0.84, 0.0) # Dorado
		else:
			message.text = "¡CUBIERTA LIMPIA!"
			message.modulate = Color(0.2, 0.8, 0.2)
	else:
		message.text = "HAS CAÍDO"
		message.modulate = Color(0.8, 0.2, 0.2)

func _on_retry_pressed() -> void:
	get_tree().paused = false
	GameManager.current_health = GameManager.max_health
	GameManager.fragments = 0
	GameManager.keys = 0
	GameManager.is_dialogue_active = false
	GameManager.hold_puzzle_solved = false
	GameManager.boss_defeated = false
	# Resetear mejoras al reintentar para no romper el testeo de progresión
	GameManager.upgrade_health_bought = false
	GameManager.upgrade_damage_bought = false
	GameManager.upgrade_stamina_bought = false
	GameManager.upgrade_triple_shoot_bought = false
	GameManager.max_health = 150
	GameManager.max_stamina = 100
	GameManager.zantyr_damage = 25
	GameManager.aura_damage = 20
	GameManager.aura_triple_shoot = false
	if boss_bar_container:
		boss_bar_container.visible = false
	get_tree().reload_current_scene()

func fade_to_black(duration: float, on_complete: Callable) -> void:
	if not transition_rect:
		on_complete.call()
		return
	transition_rect.visible = true
	transition_rect.color = Color(0, 0, 0, 0)
	var tween = create_tween()
	tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	tween.tween_property(transition_rect, "color", Color(0, 0, 0, 1), duration)
	tween.tween_callback(on_complete)

func fade_from_black(duration: float) -> void:
	if not transition_rect:
		return
	transition_rect.visible = true
	transition_rect.color = Color(0, 0, 0, 1)
	var tween = create_tween()
	tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	tween.tween_property(transition_rect, "color", Color(0, 0, 0, 0), duration)
	tween.tween_callback(func(): transition_rect.visible = false)

func show_boss_bar(max_hp: int, boss_name: String) -> void:
	if boss_bar_container:
		boss_name_label.text = boss_name
		boss_health_bar.max_value = max_hp
		boss_health_bar.value = max_hp
		boss_bar_container.visible = true

func update_boss_hp(value: int) -> void:
	if boss_health_bar:
		boss_health_bar.value = value

func hide_boss_bar() -> void:
	if boss_bar_container:
		boss_bar_container.visible = false
