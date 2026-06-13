extends Area2D

var triggered: bool = false

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if triggered:
		return
	if body.name == "Zantyr" or body.name == "Aura":
		triggered = true
		
		# Cerrar la puerta de entrada detrás del jugador
		var gate = get_parent().find_child("EntranceGate", true, false)
		if gate and gate.has_method("close_door"):
			gate.close_door()
			
		# Diálogo de amenaza del jefe y activación
		var boss = get_parent().find_child("MiniBoss", true, false)
		if not boss:
			boss = get_parent().find_child("Malakor", true, false)
			
		var hud = get_tree().get_root().find_child("HUD", true, false)
		
		if boss:
			if boss.has_method("activate_boss"):
				boss.activate_boss()
				
			if hud:
				if boss.name == "MiniBoss":
					hud.start_dialogue(boss.boss_name, [
						"¡Miau-jajaja... no! Perdón, ¡el aliento corrupto reclama sus almas!",
						"¡Nadie escapa de los muelles de desembarco!"
					])
				elif boss.name == "Malakor":
					hud.start_dialogue(boss.boss_name, [
						"¡Al fin se atreven a pisar mis dominios, insignificantes mortales!",
						"¡El Destello Escarlata se ahogará en la resonancia de mi poder!"
					])
