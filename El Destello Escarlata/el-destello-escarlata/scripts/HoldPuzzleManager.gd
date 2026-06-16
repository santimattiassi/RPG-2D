extends Node2D

var current_step: int = 0
var is_solved: bool = false

func _ready() -> void:
	pass

func press_button(button_id: int) -> void:
	if is_solved:
		return
		
	var hud = get_tree().get_root().find_child("HUD", true, false)
	
	if button_id == 0: # Botón Izquierdo
		if current_step == 0:
			current_step = 1
			print("Paso 1: Botón Izquierdo activado.")
			$LeftButton/Sprite2D.modulate = Color(1, 0.84, 0) # Modulación Dorada
		else:
			_reset_puzzle(hud)
			
	elif button_id == 1: # Placa de Presión Central
		if current_step == 1:
			current_step = 2
			print("Paso 2: Placa de Presión Central activada.")
			$CenterPlate/Sprite2D.modulate = Color(0.5, 1.0, 0.5) # Modulación Verde
		else:
			_reset_puzzle(hud)
			
	elif button_id == 2: # Botón Derecho
		if current_step == 2:
			current_step = 3
			is_solved = true
			GameManager.hold_puzzle_solved = true
			print("Paso 3: Puzle de la Bodega RESUELTO.")
			
			$RightButton/Sprite2D.modulate = Color(0.5, 1.0, 0.5)
			$LeftButton/Sprite2D.modulate = Color(0.5, 1.0, 0.5)
			
			# Sonido de puzle resuelto
			if has_node("/root/SoundManager"):
				get_node("/root/SoundManager").play_puzzle()
			
			# Abrir la compuerta metálica hacia el puerto
			var exit_door = get_parent().find_child("ExitHoldDoor", true, false)
			if exit_door and exit_door.has_method("open_door"):
				exit_door.open_door()
				
			if hud:
				hud.start_dialogue("Mecanismo", [
					"*(Se escucha un rugido de engranajes oxidados. El escotillón del suelo se abre con estruendo.)*",
					"¡El paso hacia el Puerto ha quedado abierto!"
				])
		else:
			_reset_puzzle(hud)

func release_plate() -> void:
	if is_solved:
		return
		
	if current_step == 2:
		current_step = 1
		print("Paso 2 deshecho: Placa liberada. Regresando al paso 1.")
		$CenterPlate/Sprite2D.modulate = Color(1.0, 1.0, 1.0)
		$RightButton/Sprite2D.modulate = Color(1.0, 1.0, 1.0)

func _reset_puzzle(hud: Node) -> void:
	current_step = 0
	print("Puzle reseteado.")
	# Restablecer colores originales
	$LeftButton/Sprite2D.modulate = Color(1.0, 1.0, 1.0)
	$CenterPlate/Sprite2D.modulate = Color(1.0, 1.0, 1.0)
	$RightButton/Sprite2D.modulate = Color(1.0, 1.0, 1.0)
	
	# Sonido de fallo
	if has_node("/root/SoundManager"):
		get_node("/root/SoundManager").play_fail()
	
	if hud:
		hud.start_dialogue("Mecanismo", [
			"*(Se oye un chasquido agudo... Las runas de los interruptores se apagan.)*",
			"El orden fue incorrecto. El mecanismo se ha reiniciado."
		])
