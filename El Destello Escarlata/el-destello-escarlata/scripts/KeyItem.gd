extends Area2D

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _process(delta: float) -> void:
	# Animación simple de flotación
	$Sprite2D.position.y = sin(Time.get_ticks_msec() / 200.0) * 4.0

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Zantyr" or body.name == "Aura":
		GameManager.keys += 1
		var hud = get_tree().get_root().find_child("HUD", true, false)
		if hud:
			hud.start_dialogue("Objeto", ["¡Has encontrado una Llave Antigua! Ahora puedes abrir puertas o cofres cerrados."])
		queue_free()
