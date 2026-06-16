extends Area2D

var speed: float = 500.0
var direction: Vector2 = Vector2.ZERO
var is_enemy_projectile: bool = false
var is_homing: bool = false

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	
	# Ajustar velocidad y color del proyectil según el origen
	if is_homing:
		is_enemy_projectile = true
		$Sprite2D.modulate = Color(0.8, 0.0, 1.0, 1.0) # Violeta oscuro eléctrico
		speed = 260.0 # Lento para ser teledirigido y esquivable
	elif is_enemy_projectile:
		$Sprite2D.modulate = Color(1.0, 0.2, 0.2, 1.0) # Rojo carmesí
		speed = 350.0
	else:
		$Sprite2D.modulate = Color(0.2, 0.6, 1.0, 1.0) # Fuego azul de Aura
		speed = 600.0
		
	# Destruir después de 2 segundos si no golpea nada
	await get_tree().create_timer(2.0).timeout
	queue_free()

func _physics_process(delta: float) -> void:
	if is_homing:
		# Lógica de rastreo de objetivo
		var player = get_tree().get_root().find_child(GameManager.active_character, true, false)
		if player:
			var target_dir = global_position.direction_to(player.global_position)
			direction = direction.lerp(target_dir, 2.5 * delta).normalized()

	position += direction * speed * delta
	rotation = direction.angle()

func _on_body_entered(body: Node2D) -> void:
	if is_enemy_projectile:
		if body.name == "Zantyr" or body.name == "Aura":
			if body.has_method("take_damage"):
				body.take_damage(15, global_position) # Contrabandista carmesí hace 15 de daño
			queue_free()
	else:
		if body.is_in_group("enemies"):
			if body.has_method("take_damage"):
				body.take_damage(GameManager.aura_damage, global_position) # Daño dinámico (RPG)
			queue_free()
