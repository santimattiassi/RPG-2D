extends Node2D

func _ready() -> void:
	var zantyr = find_child("Zantyr", true, false)
	var aura = find_child("Aura", true, false)
	var choco = find_child("Choco", true, false)
	var hud = find_child("HUD", true, false)
	
	# Si venimos de otra escena por una transición, posicionamos a los personajes
	if GameManager.next_spawn_position != Vector2.ZERO:
		if zantyr:
			zantyr.global_position = GameManager.next_spawn_position
		if aura:
			aura.global_position = GameManager.next_spawn_position
		if choco:
			choco.global_position = GameManager.next_spawn_position - Vector2(60, 60)
		GameManager.next_spawn_position = Vector2.ZERO

	# Sincronizar visibilidad de los héroes con el personaje activo actual
	if zantyr and aura:
		if GameManager.active_character == "Zantyr":
			zantyr.visible = true
			aura.visible = false
		else:
			zantyr.visible = false
			aura.visible = true

	# Asegurar que el control se reactive
	GameManager.is_dialogue_active = false
	
	# Desvanecer pantalla a transparente
	if hud and hud.has_method("fade_from_black"):
		hud.fade_from_black(0.5)
