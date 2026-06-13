extends Area2D

@export var target_door_path: NodePath
var target_door: Node2D = null

var pressing_bodies: int = 0

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	if target_door_path:
		target_door = get_node(target_door_path)

func _on_body_entered(body: Node2D) -> void:
	# Permitir que el jugador, Choco, o enemigos activen el botón
	if body.name == "Zantyr" or body.name == "Aura" or body.name == "Choco" or body.is_in_group("enemies"):
		pressing_bodies += 1
		if pressing_bodies == 1:
			# Placa presionada
			$Sprite2D.modulate = Color(0.5, 1.0, 0.5, 1.0) # Modulación verde activa
			if target_door and target_door.has_method("open_door"):
				target_door.open_door()

func _on_body_exited(body: Node2D) -> void:
	if body.name == "Zantyr" or body.name == "Aura" or body.name == "Choco" or body.is_in_group("enemies"):
		pressing_bodies = max(0, pressing_bodies - 1)
		if pressing_bodies == 0:
			# Placa liberada
			$Sprite2D.modulate = Color(1.0, 1.0, 1.0, 1.0) # Vuelve al color normal
			if target_door and target_door.has_method("close_door"):
				target_door.close_door()
