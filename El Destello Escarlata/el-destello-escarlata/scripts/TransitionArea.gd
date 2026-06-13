extends Area2D

@export var target_scene_path: String = ""
@export var target_spawn_position: Vector2 = Vector2.ZERO

var transitioning: bool = false

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if transitioning:
		return
	if body.name == "Zantyr" or body.name == "Aura":
		transitioning = true
		GameManager.is_dialogue_active = true # Congelar al jugador
		
		var hud = get_tree().get_root().find_child("HUD", true, false)
		if hud and hud.has_method("fade_to_black"):
			hud.fade_to_black(0.5, _change_scene)
		else:
			_change_scene()

func _change_scene() -> void:
	GameManager.next_spawn_position = target_spawn_position
	if target_scene_path != "":
		print("Cambiando escena a: ", target_scene_path)
		var err = get_tree().change_scene_to_file(target_scene_path)
		if err != OK:
			print("Error cargando escena: ", err)
			# Restaurar estado por si falla
			GameManager.is_dialogue_active = false
			transitioning = false
	else:
		print("Error: Ruta de escena vacía en TransitionArea")
		GameManager.is_dialogue_active = false
		transitioning = false
