extends CharacterBody2D

const LOOT_SCENE = preload("res://Loot.tscn")
const PROJECTILE_SCENE = preload("res://Projectile.tscn")

enum State { PATROL, CHASE, ATTACK }
var current_state: State = State.PATROL

@export var enemy_type: String = "Comun" # Comun, Veloz, Robusta, Ranger
@export var detection_radius: float = 300.0
@export var patrol_radius: float = 150.0

var health: int = 50
var speed: float = 70.0
var damage_amount: int = 20
var base_color: Color = Color.WHITE
var shoot_timer: float = 0.0
var knockback_velocity: Vector2 = Vector2.ZERO

var spawn_position: Vector2 = Vector2.ZERO
var patrol_target: Vector2 = Vector2.ZERO
var patrol_timer: float = 0.0

func _ready() -> void:
	spawn_position = global_position
	_pick_new_patrol_target()
	
	# Configurar las variantes de enemigos al spawnear
	match enemy_type:
		"Veloz":
			health = 25
			speed = 125.0
			damage_amount = 12
			$Sprite2D.modulate = Color(0.8, 0.2, 0.8, 1.0) # Violeta / Fucsia
		"Robusta":
			health = 120
			speed = 45.0
			damage_amount = 35
			$Sprite2D.modulate = Color(0.1, 0.1, 0.1, 1.0) # Sombra oscura pesada
			$Sprite2D.scale = Vector2(0.1, 0.1) # Más grande que el 0.07 normal
			$CollisionShape2D.scale = Vector2(1.5, 1.5)
		"Ranger":
			health = 45
			speed = 60.0
			damage_amount = 15
			$Sprite2D.modulate = Color(0.9, 0.4, 0.4, 1.0) # Rojo anaranjado
			detection_radius = 450.0 # Ranger detecta desde más lejos
		"Comun", _:
			health = 50
			speed = 70.0
			damage_amount = 20
			$Sprite2D.modulate = Color(0.3, 0.3, 0.3, 1.0) # Sombra gris básica
			
	# Guardamos el color de base para volver a él tras el parpadeo de daño
	base_color = $Sprite2D.modulate
	add_to_group("enemies")

func _pick_new_patrol_target() -> void:
	var random_angle = randf() * PI * 2.0
	var random_dist = randf() * patrol_radius
	patrol_target = spawn_position + Vector2(cos(random_angle), sin(random_angle)) * random_dist
	patrol_timer = randf_range(2.0, 4.0)

func _physics_process(delta: float) -> void:
	if GameManager.is_dialogue_active:
		velocity = Vector2.ZERO
		return # Detener movimiento y daño durante diálogos
		
	# Añadir knockback a la velocidad si está activo
	if knockback_velocity.length() > 10.0:
		velocity = knockback_velocity
		knockback_velocity = knockback_velocity.move_toward(Vector2.ZERO, 600.0 * delta)
		var coll = move_and_collide(velocity * delta)
		if coll:
			pass
		return
		
	var player = get_tree().get_root().find_child(GameManager.active_character, true, false)
	var dist_to_player = 9999.0
	if player:
		dist_to_player = global_position.distance_to(player.global_position)
		
	match current_state:
		State.PATROL:
			if dist_to_player <= detection_radius:
				current_state = State.CHASE
			else:
				var dist_to_target = global_position.distance_to(patrol_target)
				if dist_to_target > 5.0:
					velocity = global_position.direction_to(patrol_target) * (speed * 0.5) # Camina más lento patrullando
				else:
					velocity = Vector2.ZERO
					patrol_timer -= delta
					if patrol_timer <= 0:
						_pick_new_patrol_target()
		State.CHASE:
			if not player or dist_to_player > detection_radius * 1.5:
				current_state = State.PATROL
				_pick_new_patrol_target()
			else:
				var direction = global_position.direction_to(player.global_position)
				if enemy_type == "Ranger":
					if dist_to_player > 260.0:
						velocity = direction * speed
					elif dist_to_player < 170.0:
						velocity = -direction * speed
					else:
						velocity = Vector2.ZERO
					
					shoot_timer += delta
					if shoot_timer >= 2.5:
						shoot_timer = 0.0
						current_state = State.ATTACK
				else:
					velocity = direction * speed
		State.ATTACK:
			velocity = Vector2.ZERO
			if enemy_type == "Ranger":
				if player:
					_shoot_at_player(player)
				current_state = State.CHASE
			else:
				current_state = State.CHASE
				
	# Mover y detectar colisión cuerpo a cuerpo
	var collision = move_and_collide(velocity * delta)
	if collision:
		var collider = collision.get_collider()
		if collider and (collider.name == "Zantyr" or collider.name == "Aura"):
			if collider.has_method("take_damage"):
				collider.take_damage(damage_amount, global_position) # Pasar origen del golpe para el retroceso del jugador
		
		if current_state == State.PATROL:
			_pick_new_patrol_target()

func _shoot_at_player(player: Node2D) -> void:
	var proj = PROJECTILE_SCENE.instantiate()
	proj.global_position = global_position
	proj.direction = global_position.direction_to(player.global_position)
	proj.is_enemy_projectile = true
	get_parent().add_child(proj)

func take_damage(amount: int, source_position: Vector2 = Vector2.ZERO) -> void:
	health -= amount
	print(enemy_type, " recibio daño! Vida restante: ", health)
	
	# Si recibe daño, automáticamente se pone a perseguir al jugador (aggro)
	current_state = State.CHASE
	
	# Sonido retro de golpe
	if has_node("/root/SoundManager"):
		get_node("/root/SoundManager").play_hit()
		
	# Aplicar retroceso (knockback)
	var from_pos = source_position
	if from_pos == Vector2.ZERO:
		var player = get_tree().get_root().find_child(GameManager.active_character, true, false)
		if player:
			from_pos = player.global_position
	if from_pos != Vector2.ZERO:
		var knock_dir = (global_position - from_pos).normalized()
		knockback_velocity = knock_dir * 250.0
	
	# Parpadeo rojo al recibir daño
	$Sprite2D.modulate = Color.RED
	await get_tree().create_timer(0.1).timeout
	$Sprite2D.modulate = base_color
	
	if health <= 0:
		# Instanciar el botín
		var loot = LOOT_SCENE.instantiate()
		loot.global_position = global_position
		get_parent().add_child(loot)
		
		queue_free() # Destruye al enemigo
