extends CharacterBody2D

@export var push_speed: float = 70.0

func _ready() -> void:
	add_to_group("blocks")
	$Sprite2D.modulate = Color(0.4, 0.4, 0.4, 1.0) # Color gris piedra
	$Label.text = "BLOQUE"

func push(direction: Vector2, _force: float) -> void:
	# Bloqueo cardinal estricto para empujar en cruz
	var cardinal_dir = Vector2.ZERO
	if abs(direction.x) > abs(direction.y):
		cardinal_dir.x = sign(direction.x)
	else:
		cardinal_dir.y = sign(direction.y)
		
	velocity = cardinal_dir * push_speed

func _physics_process(delta: float) -> void:
	move_and_slide()
	# Deceleración por fricción al dejar de empujar
	velocity = velocity.move_toward(Vector2.ZERO, 400.0 * delta)
