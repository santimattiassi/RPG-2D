extends Node2D

var level_camera: Camera2D

func _ready() -> void:
	# Crear cámara independiente de la estancia
	level_camera = Camera2D.new()
	level_camera.name = "LevelCamera"
	level_camera.add_to_group("level_camera")
	level_camera.position_smoothing_enabled = true
	level_camera.position_smoothing_speed = 5.0
	add_child(level_camera)
	level_camera.make_current()

	var choco = find_child("Choco", true, false)
	var hud = find_child("HUD", true, false)
	
	# Si venimos de otra escena por una transición, posicionamos a los personajes
	if GameManager.next_spawn_position != Vector2.ZERO:
		for member in GameManager.party_members:
			var node = find_child(member, true, false)
			if node: node.global_position = GameManager.next_spawn_position
		
		if choco:
			choco.global_position = GameManager.next_spawn_position - Vector2(60, 60)
		GameManager.next_spawn_position = Vector2.ZERO

	# Sincronizar visibilidad de los héroes con el personaje activo actual
	for member in GameManager.party_members:
		var node = find_child(member, true, false)
		if node:
			if member == GameManager.active_character:
				node.visible = true
				level_camera.global_position = node.global_position
			else:
				node.visible = false
				
	level_camera.reset_smoothing()

	# Asegurar que el control se reactive
	GameManager.is_dialogue_active = false
	
	# Desvanecer pantalla a transparente
	if hud and hud.has_method("fade_from_black"):
		hud.fade_from_black(0.5)

func _process(delta: float) -> void:
	var active = find_child(GameManager.active_character, true, false)
	if active and level_camera:
		level_camera.global_position = active.global_position
