extends Area2D

@export var loot_type: String = "Fragment" # Fragment, Heart, Stamina

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	
	# Modular color según el tipo de loot
	match loot_type:
		"Heart":
			$Sprite2D.modulate = Color(1.0, 0.25, 0.25, 1.0) # Rojo (curación)
			scale = Vector2(0.8, 0.8) # Ligeramente más pequeño
		"Stamina":
			$Sprite2D.modulate = Color(0.25, 0.9, 0.25, 1.0) # Verde (estamina)
			scale = Vector2(0.8, 0.8)
		"Fragment", _:
			$Sprite2D.modulate = Color(0.6, 0.1, 0.8, 1.0) # Morado (esferas oscuras)

func _process(delta: float) -> void:
	# Flotar suavemente arriba y abajo
	position.y += sin(Time.get_ticks_msec() / 150.0) * 0.5

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Zantyr" or body.name == "Aura":
		match loot_type:
			"Heart":
				GameManager.current_health = min(GameManager.current_health + 25, GameManager.max_health)
			"Stamina":
				GameManager.current_stamina = min(GameManager.current_stamina + 30, GameManager.max_stamina)
			"Fragment", _:
				GameManager.fragments += 1
		
		# Sonido retro de recolección
		if has_node("/root/SoundManager"):
			get_node("/root/SoundManager").play_pickup()
			
		queue_free()
