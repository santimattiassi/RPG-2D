extends StaticBody2D

@export var requires_key: bool = false
var is_open: bool = false

@onready var collision_shape = $CollisionShape2D
@onready var sprite = $Sprite2D
@onready var interact_area = get_node_or_null("InteractArea")

var can_unlock: bool = false
var player_ref: Node2D = null

func _ready() -> void:
	if requires_key and interact_area:
		interact_area.body_entered.connect(_on_player_entered)
		interact_area.body_exited.connect(_on_player_exited)
		
	if is_open:
		collision_shape.set_deferred("disabled", true)
		if sprite:
			sprite.modulate.a = 0.25

func _on_player_entered(body: Node2D) -> void:
	if body.name == "Zantyr" or body.name == "Aura":
		can_unlock = true
		player_ref = body
		var hud = get_tree().get_root().find_child("HUD", true, false)
		if hud:
			hud.show_prompt("Abrir Puerta Cerrada")

func _on_player_exited(body: Node2D) -> void:
	if body == player_ref:
		can_unlock = false
		player_ref = null
		var hud = get_tree().get_root().find_child("HUD", true, false)
		if hud:
			hud.hide_prompt()

func _unhandled_input(event: InputEvent) -> void:
	if can_unlock and not is_open and not GameManager.is_dialogue_active and event is InputEventKey and event.pressed and event.keycode == KEY_E:
		get_viewport().set_input_as_handled()
		var hud = get_tree().get_root().find_child("HUD", true, false)
		if GameManager.keys > 0:
			if GameManager.use_key():
				open_door()
				if hud:
					hud.hide_prompt()
					hud.start_dialogue("Puerta", ["¡Usaste una Llave Antigua y la puerta se abrió!"])
		else:
			# Sonido de fallo al intentar abrir bloqueada
			if has_node("/root/SoundManager"):
				get_node("/root/SoundManager").play_fail()
			if hud:
				hud.start_dialogue("Puerta", ["Esta puerta está bloqueada.", "Necesitas una Llave Antigua para abrirla."])

func open_door() -> void:
	if is_open: return
	is_open = true
	collision_shape.set_deferred("disabled", true)
	sprite.modulate.a = 0.25 # Semi-transparente para indicar que está abierta
	
	# Sonido retro de apertura / desbloqueo
	if has_node("/root/SoundManager"):
		get_node("/root/SoundManager").play_puzzle()
		
	print("Puerta abierta.")

func close_door() -> void:
	if not is_open: return
	if requires_key: return # Las puertas con llave se quedan abiertas permanentemente
	is_open = false
	collision_shape.set_deferred("disabled", false)
	sprite.modulate.a = 1.0 # Opaca de nuevo
	print("Puerta cerrada.")
