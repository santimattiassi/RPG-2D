extends Area2D
class_name Interactable

@export var prompt_message: String = "Interactuar"

var can_interact: bool = false
var current_player: Node2D = null

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node2D) -> void:
	# Asegurar que solo el personaje activo interactúe (los inactivos tienen colisión desactivada)
	if body.name == "Zantyr" or body.name == "Aura":
		can_interact = true
		current_player = body
		var hud = get_tree().get_root().find_child("HUD", true, false)
		if hud and hud.has_method("show_prompt"):
			hud.show_prompt(prompt_message)

func _on_body_exited(body: Node2D) -> void:
	if body == current_player:
		can_interact = false
		current_player = null
		var hud = get_tree().get_root().find_child("HUD", true, false)
		if hud and hud.has_method("hide_prompt"):
			hud.hide_prompt()

func _unhandled_input(event: InputEvent) -> void:
	if can_interact and not GameManager.is_dialogue_active:
		if event is InputEventKey and event.pressed and event.keycode == KEY_E:
			get_viewport().set_input_as_handled()
			interact()

func interact() -> void:
	# Método virtual
	pass
