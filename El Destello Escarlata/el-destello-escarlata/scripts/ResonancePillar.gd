extends StaticBody2D

@export var max_health: int = 50
var health: int = 50

func _ready() -> void:
	add_to_group("enemies")
	health = max_health
	# Modulación dorada brillante
	$Sprite2D.modulate = Color(1.0, 0.84, 0.0)

func take_damage(amount: int) -> void:
	health -= amount
	print("Pilar de Resonancia golpeado! Vida restante: ", health)
	
	# Parpadeo rojo al recibir daño
	$Sprite2D.modulate = Color.RED
	await get_tree().create_timer(0.1).timeout
	$Sprite2D.modulate = Color(1.0, 0.84, 0.0) # Vuelve al dorado
	
	if health <= 0:
		GameManager.pillars_destroyed += 1
		print("Pilar de Resonancia DESTRUIDO. Total destruidos: ", GameManager.pillars_destroyed)
		
		# Mostrar diálogo explicativo
		var hud = get_tree().get_root().find_child("HUD", true, false)
		if hud:
			hud.start_dialogue("Mecanismo", [
				"¡El Pilar de Resonancia ha estallado en mil pedazos!",
				"*(La barrera de Malakor emite un crujido inestable...)*"
			])
			
		queue_free()
