extends Area2D

var pressing_bodies: int = 0

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Zantyr" or body.name == "Aura" or body.name == "Choco":
		pressing_bodies += 1
		if pressing_bodies == 1:
			var parent = get_parent()
			if parent and parent.has_method("press_button"):
				parent.press_button(1)

func _on_body_exited(body: Node2D) -> void:
	if body.name == "Zantyr" or body.name == "Aura" or body.name == "Choco":
		pressing_bodies = max(0, pressing_bodies - 1)
		if pressing_bodies == 0:
			var parent = get_parent()
			if parent and parent.has_method("release_plate"):
				parent.release_plate()
