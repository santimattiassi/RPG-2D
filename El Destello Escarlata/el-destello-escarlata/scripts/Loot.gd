extends Area2D

func _ready() -> void:
	# Nos conectamos a nosotros mismos para saber si Zantyr nos pisa
	body_entered.connect(_on_body_entered)

func _process(delta: float) -> void:
	# Hacemos que la esfera flote suavemente arriba y abajo
	position.y += sin(Time.get_ticks_msec() / 150.0) * 0.5

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Zantyr" or body.name == "Aura":
		# Sumamos una esfera al inventario global
		GameManager.fragments += 1
		# Nos destruimos
		queue_free()
