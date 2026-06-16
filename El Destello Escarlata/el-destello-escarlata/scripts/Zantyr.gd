extends CharacterBody2D

@export var speed: float = 200.0
@export var dash_speed: float = 600.0
@export var dash_duration: float = 0.2
@export var attack_duration: float = 0.2

var is_invulnerable: bool = false
var invulnerability_timer: float = 0.0

var is_dashing: bool = false
var dash_timer: float = 0.0
var dash_direction: Vector2 = Vector2.ZERO

var is_attacking: bool = false
var attack_timer: float = 0.0

var knockback_velocity: Vector2 = Vector2.ZERO
var shake_intensity: float = 0.0
var shake_decay: float = 15.0

@onready var weapon_pivot = $WeaponPivot
@onready var hitbox_shape = $WeaponPivot/AttackHitbox/CollisionShape2D
@onready var sprite = $Sprite2D

func _ready() -> void:
	# Conectamos la caja de daño para detectar colisiones
	$WeaponPivot/AttackHitbox.body_entered.connect(_on_attack_hitbox_body_entered)

func _physics_process(delta: float) -> void:
	if GameManager.active_character != "Zantyr":
		$CollisionShape2D.disabled = true
		return
	$CollisionShape2D.disabled = false
	$Camera2D.make_current()

	# Procesar screen shake
	if shake_intensity > 0.0:
		$Camera2D.offset = Vector2(randf_range(-shake_intensity, shake_intensity), randf_range(-shake_intensity, shake_intensity))
		shake_intensity = move_toward(shake_intensity, 0.0, shake_decay * delta)
	else:
		$Camera2D.offset = Vector2.ZERO

	# Procesar knockback (aturdimiento breve al ser golpeado)
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

	if is_dashing:
		_process_dash(delta)
		return
		
	if is_attacking:
		_process_attack(delta)
		return

	var input_dir: Vector2 = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	# Rotamos el pivote invisible del arma hacia donde miramos
	if input_dir != Vector2.ZERO:
		weapon_pivot.rotation = input_dir.angle()
	
	# Invulnerabilidad temporal
	if is_invulnerable:
		invulnerability_timer -= delta
		# Parpadeo rojo cuando está herido
		sprite.modulate = Color(1, 0.3, 0.3, 1) if int(invulnerability_timer * 10) % 2 == 0 else Color(1, 1, 1, 1)
		if invulnerability_timer <= 0:
			is_invulnerable = false
			sprite.modulate = Color(1, 1, 1, 1)
	
	# Dash (Espacio)
	if Input.is_action_just_pressed("ui_accept") and input_dir != Vector2.ZERO:
		if GameManager.consume_stamina(25.0):
			_start_dash(input_dir)
			return
			
	# Ataque Básico Melee (Tecla Z)
	if Input.is_key_pressed(KEY_Z) and not is_attacking:
		_start_attack()
		return
	
	# Movimiento normal
	velocity = input_dir * speed
	move_and_slide()
	_check_block_push()

func _check_block_push() -> void:
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		if collider and collider.has_method("push"):
			collider.push(-collision.get_normal(), speed)

func _start_dash(dir: Vector2) -> void:
	is_dashing = true
	dash_timer = dash_duration
	dash_direction = dir
	velocity = dash_direction * dash_speed

func _process_dash(delta: float) -> void:
	dash_timer -= delta
	move_and_slide()
	if dash_timer <= 0:
		is_dashing = false

func _start_attack() -> void:
	is_attacking = true
	attack_timer = attack_duration
	velocity = Vector2.ZERO # Nos detenemos un poco al dar el espadazo
	
	hitbox_shape.disabled = false # Encendemos el área de daño
	sprite.modulate = Color.RED # Truco visual: Nos ponemos rojos al golpear
	
	# Sonido retro de espada
	if has_node("/root/SoundManager"):
		get_node("/root/SoundManager").play_sword()

func _process_attack(delta: float) -> void:
	attack_timer -= delta
	move_and_slide()
	
	if attack_timer <= 0:
		is_attacking = false
		hitbox_shape.disabled = true # Apagamos el área de daño
		sprite.modulate = Color.WHITE # Volvemos al color normal

func _on_attack_hitbox_body_entered(body: Node2D) -> void:
	# Si lo que tocamos con la espada está en el grupo "enemies"
	if body.is_in_group("enemies"):
		if body.has_method("take_damage"):
			body.take_damage(GameManager.zantyr_damage, global_position) # Pasar origen del golpe para el knockback

func take_damage(amount: int, source_position: Vector2 = Vector2.ZERO) -> void:
	if is_invulnerable or GameManager.active_character != "Zantyr":
		return
		
	GameManager.current_health -= amount
	is_invulnerable = true
	invulnerability_timer = 1.0 # 1 segundo de invulnerabilidad
	
	# Sonido retro de daño
	if has_node("/root/SoundManager"):
		get_node("/root/SoundManager").play_hurt()
		
	# Sacudir pantalla
	shake_intensity = 8.0
	
	# Aplicar retroceso (knockback)
	var from_pos = source_position
	if from_pos == Vector2.ZERO:
		var push_dir = -velocity.normalized()
		if push_dir == Vector2.ZERO:
			push_dir = Vector2.DOWN
		knockback_velocity = push_dir * 300.0
	else:
		var push_dir = (global_position - from_pos).normalized()
		knockback_velocity = push_dir * 300.0
		
	print("Zantyr recibió daño. Vida actual: ", GameManager.current_health)
	
	if GameManager.current_health <= 0:
		print("¡Zantyr ha caído!")
		get_parent().get_node("HUD").show_end_screen(false)

func _unhandled_input(event: InputEvent) -> void:
	if GameManager.active_character != "Zantyr":
		return
	if event is InputEventKey and event.pressed and event.keycode == KEY_C:
		if GameManager.fragments >= 5 and GameManager.current_health < GameManager.max_health:
			GameManager.fragments -= 5
			GameManager.current_health = min(GameManager.current_health + 20, GameManager.max_health)
			print("Zantyr se curó 20 de vida.")
