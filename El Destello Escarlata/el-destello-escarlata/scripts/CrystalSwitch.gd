extends Area2D

var activated: bool = false

func _ready() -> void:
	area_entered.connect(_on_area_entered)
	# Modulación celeste brillante inicial
	$Sprite2D.modulate = Color(0.1, 0.7, 1.0, 1.0)

func _on_area_entered(area: Area2D) -> void:
	if activated:
		return
	
	# Verificar si es un proyectil aliado de Aura (no del enemigo)
	if area.has_method("get_class") or area.name.begins_with("Projectile"):
		if area.get("is_enemy_projectile") == false:
			activated = true
			$Sprite2D.modulate = Color(0.5, 1.0, 0.5, 1.0) # Verde activado
			print("Cristal de Energía activado por disparo de Aura.")
			
			# Buscar y abrir la verja del camino de Zantyr
			var gate = get_parent().find_child("ZantyrGate", true, false)
			if gate and gate.has_method("open_door"):
				gate.open_door()
				
			var hud = get_tree().get_root().find_child("HUD", true, false)
			if hud:
				hud.start_dialogue("Mecanismo", [
					"¡El Cristal de Energía absorbe el fuego de biomagia!",
					"*(La verja del camino de Zantyr se abre con un chasquido)*"
				])
				
			# Destruir el proyectil para que no siga de largo
			area.queue_free()
