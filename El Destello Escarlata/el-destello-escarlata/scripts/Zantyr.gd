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
			body.take_damage(GameManager.zantyr_damage) # Daño dinámico (RPG)

func take_damage(amount: int) -> void:
	if is_invulnerable or GameManager.active_character != "Zantyr":
		return
		
	GameManager.current_health -= amount
	is_invulnerable = true
	invulnerability_timer = 1.0 # 1 segundo de invulnerabilidad
	
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
