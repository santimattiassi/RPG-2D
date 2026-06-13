extends CharacterBody2D

const PROJECTILE_SCENE = preload("res://Projectile.tscn")

@export var move_speed: float = 220.0 # Aura es ligeramente más lenta
@export var dash_speed: float = 800.0 # Su dash mágico es más rápido
@export var dash_duration: float = 0.15

var is_invulnerable: bool = false
var invulnerability_timer: float = 0.0

var is_dashing: bool = false
var dash_timer: float = 0.0
var dash_direction: Vector2 = Vector2.ZERO
var shoot_cooldown: float = 0.0

@onready var sprite = $Sprite2D
@onready var weapon_pivot = $WeaponPivot
@onready var col = $CollisionShape2D
@onready var cam = $Camera2D

func _physics_process(delta: float) -> void:
	if shoot_cooldown > 0:
		shoot_cooldown -= delta
		
	if GameManager.active_character != "Aura":
		col.disabled = true
		return
	col.disabled = false
	cam.make_current()
	
	if GameManager.is_dialogue_active:
		velocity = Vector2.ZERO
		move_and_slide()
		return
	
	if is_invulnerable:
		invulnerability_timer -= delta
		sprite.modulate = Color(1, 0.3, 0.3, 1) if int(invulnerability_timer * 10) % 2 == 0 else Color(1, 1, 1, 1)
		if invulnerability_timer <= 0:
			is_invulnerable = false
			sprite.modulate = Color(1, 1, 1, 1)
			
	if is_dashing:
		dash_timer -= delta
		velocity = dash_direction * dash_speed
		move_and_slide()
		if dash_timer <= 0:
			is_dashing = false
		return

	var input_dir = Vector2.ZERO
	input_dir.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_dir.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_dir = input_dir.normalized()
	
	velocity = input_dir * move_speed
	move_and_slide()
	
	if input_dir != Vector2.ZERO:
		weapon_pivot.rotation = input_dir.angle()
		
	# Dash mágico
	if Input.is_action_just_pressed("ui_accept") and input_dir != Vector2.ZERO:
		if GameManager.consume_stamina(20.0):
			is_dashing = true
			dash_timer = dash_duration
			dash_direction = input_dir
			
	# Disparo (Z)
	if Input.is_key_pressed(KEY_Z) and GameManager.consume_stamina(5.0):
		shoot_projectile()

func shoot_projectile() -> void:
	if shoot_cooldown > 0:
		return
	shoot_cooldown = 0.35 # Cadencia de disparo
	
	var fire_point_pos = weapon_pivot.get_node("FirePoint").global_position
	var base_rot = weapon_pivot.rotation
	
	if GameManager.aura_triple_shoot:
		# Dispara 3 proyectiles en abanico (central y laterales de ±15 grados)
		for angle_offset in [-0.25, 0.0, 0.25]:
			var proj = PROJECTILE_SCENE.instantiate()
			proj.global_position = fire_point_pos
			proj.direction = Vector2.RIGHT.rotated(base_rot + angle_offset)
			get_parent().add_child(proj)
	else:
		# Disparo único convencional
		var proj = PROJECTILE_SCENE.instantiate()
		proj.global_position = fire_point_pos
		proj.direction = Vector2.RIGHT.rotated(base_rot)
		get_parent().add_child(proj)

func take_damage(amount: int) -> void:
	if is_invulnerable or GameManager.active_character != "Aura":
		return
		
	GameManager.current_health -= amount
	is_invulnerable = true
	invulnerability_timer = 1.0 
	
	print("Aura recibió daño. Vida actual: ", GameManager.current_health)
	
	if GameManager.current_health <= 0:
		print("¡Aura ha caído!")
		get_parent().get_node("HUD").show_end_screen(false)

func _unhandled_input(event: InputEvent) -> void:
	if GameManager.active_character != "Aura":
		return
	if event is InputEventKey and event.pressed and event.keycode == KEY_C:
		if GameManager.fragments >= 5 and GameManager.current_health < GameManager.max_health:
			GameManager.fragments -= 5
			GameManager.current_health = min(GameManager.current_health + 20, GameManager.max_health)
			print("Aura se curó 20 de vida.")
