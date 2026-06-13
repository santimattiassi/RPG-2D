extends Area2D

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Zantyr" or body.name == "Aura":
		var hud = get_tree().get_root().find_child("HUD", true, false)
		if hud and hud.has_method("show_end_screen"):
			hud.show_end_screen(true)
