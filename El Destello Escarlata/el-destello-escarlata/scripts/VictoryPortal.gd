extends Area2D

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Zantyr" or body.name == "Aura":
		# Sonido retro de fanfarria
		if has_node("/root/SoundManager"):
			get_node("/root/SoundManager").play_fanfare()
			
		var hud = get_tree().get_root().find_child("HUD", true, false)
		if hud and hud.has_method("show_end_screen"):
			hud.show_end_screen(true)
