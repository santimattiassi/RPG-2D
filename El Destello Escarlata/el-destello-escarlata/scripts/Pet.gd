class_name Pet extends CharacterBody2D

enum State { IDLE, FOLLOW, WAIT, ACTION }
var current_state: State = State.FOLLOW

@export var follow_distance: float = 60.0
@export var speed: float = 120.0

var active_player: Node2D

func _ready() -> void:
	add_to_group("pets")

func _physics_process(delta: float) -> void:
	if GameManager.is_dialogue_active:
		velocity = Vector2.ZERO
		return

	# Encontrar dinámicamente al jugador activo según el PartyManager
	active_player = get_tree().get_root().find_child(GameManager.active_character, true, false)

	match current_state:
		State.FOLLOW:
			if active_player:
				var dist = global_position.distance_to(active_player.global_position)
				if dist > follow_distance:
					var dir = global_position.direction_to(active_player.global_position)
					velocity = dir * speed
				else:
					velocity = Vector2.ZERO
					current_state = State.IDLE
		State.IDLE:
			velocity = Vector2.ZERO
			if active_player and global_position.distance_to(active_player.global_position) > follow_distance * 1.5:
				current_state = State.FOLLOW
		State.WAIT:
			velocity = Vector2.ZERO
		State.ACTION:
			pass

	move_and_slide()
