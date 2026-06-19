extends CharacterBody2D
class_name Player

enum State { IDLE, MOVE, DASH, ATTACK, HURT }
var current_state: State = State.IDLE

@export var move_speed: float = 200.0
@export var dash_speed: float = 600.0
@export var dash_duration: float = 0.2

var is_invulnerable: bool = false
var invulnerability_timer: float = 0.0

var dash_timer: float = 0.0
var dash_direction: Vector2 = Vector2.ZERO

var knockback_velocity: Vector2 = Vector2.ZERO
var shake_intensity: float = 0.0
var shake_decay: float = 15.0

@onready var sprite = $Sprite2D
@onready var weapon_pivot = get_node_or_null("WeaponPivot")
@onready var col = $CollisionShape2D

func _physics_process(delta: float) -> void:
	if GameManager.active_character != name:
		if col: col.disabled = true
		return
	if col: col.disabled = false
	
	_process_camera_shake(delta)
	
	if knockback_velocity.length() > 50.0:
		velocity = knockback_velocity
		knockback_velocity = knockback_velocity.move_toward(Vector2.ZERO, 800.0 * delta)
		move_and_slide()
		_check_block_push()
		return
		
	if GameManager.is_dialogue_active:
		velocity = Vector2.ZERO
		move_and_slide()
		return
		
	if is_invulnerable:
		invulnerability_timer -= delta
		if sprite:
			sprite.modulate = Color(1, 0.3, 0.3, 1) if int(invulnerability_timer * 10) % 2 == 0 else Color(1, 1, 1, 1)
		if invulnerability_timer <= 0:
			is_invulnerable = false
			if sprite:
				sprite.modulate = Color(1, 1, 1, 1)

	_process_state(delta)

func _process_camera_shake(delta: float) -> void:
	if shake_intensity > 0.0:
		shake_intensity = move_toward(shake_intensity, 0.0, shake_decay * delta)
		# Nota: LevelCamera será añadido posteriormente en el GameManager o en el Level
		var cam = get_tree().get_first_node_in_group("level_camera")
		if cam:
			cam.offset = Vector2(randf_range(-shake_intensity, shake_intensity), randf_range(-shake_intensity, shake_intensity))
	else:
		var cam = get_tree().get_first_node_in_group("level_camera")
		if cam:
			cam.offset = Vector2.ZERO

func _process_state(delta: float) -> void:
	match current_state:
		State.IDLE, State.MOVE:
			var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
			if input_dir != Vector2.ZERO:
				current_state = State.MOVE
				if weapon_pivot:
					weapon_pivot.rotation = input_dir.angle()
			else:
				current_state = State.IDLE
				
			velocity = input_dir * move_speed
			move_and_slide()
			_check_block_push()
			
			if Input.is_action_just_pressed("ui_accept") and input_dir != Vector2.ZERO:
				if GameManager.consume_stamina(20.0):
					_start_dash(input_dir)
			
			if Input.is_key_pressed(KEY_Z):
				_handle_attack()
				
		State.DASH:
			dash_timer -= delta
			move_and_slide()
			if dash_timer <= 0:
				current_state = State.IDLE
				
		State.ATTACK:
			_process_attack(delta)

func _start_dash(dir: Vector2) -> void:
	current_state = State.DASH
	dash_timer = dash_duration
	dash_direction = dir
	velocity = dash_direction * dash_speed

func _check_block_push() -> void:
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		if collider and collider.has_method("push"):
			collider.push(-collision.get_normal(), move_speed)

func take_damage(amount: int, source_position: Vector2 = Vector2.ZERO) -> void:
	if is_invulnerable or GameManager.active_character != name:
		return
		
	GameManager.current_health -= amount
	is_invulnerable = true
	invulnerability_timer = 1.0
	
	if has_node("/root/SoundManager"):
		get_node("/root/SoundManager").play_hurt()
		
	shake_intensity = 8.0
	
	var from_pos = source_position
	if from_pos == Vector2.ZERO:
		var push_dir = -velocity.normalized()
		if push_dir == Vector2.ZERO:
			push_dir = Vector2.DOWN
		knockback_velocity = push_dir * 300.0
	else:
		var push_dir = (global_position - from_pos).normalized()
		knockback_velocity = push_dir * 300.0
		
	if GameManager.current_health <= 0:
		var hud = get_parent().get_node_or_null("HUD")
		if hud:
			hud.show_end_screen(false)

func _unhandled_input(event: InputEvent) -> void:
	if GameManager.active_character != name:
		return
	if event is InputEventKey and event.pressed and event.keycode == KEY_C:
		if GameManager.fragments >= 5 and GameManager.current_health < GameManager.max_health:
			GameManager.fragments -= 5
			GameManager.current_health = min(GameManager.current_health + 20, GameManager.max_health)

# VIRTUAL FUNCTIONS to be overridden by children
func _handle_attack() -> void:
	pass

func _process_attack(_delta: float) -> void:
	pass
