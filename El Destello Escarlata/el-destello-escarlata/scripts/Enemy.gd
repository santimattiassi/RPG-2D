extends CharacterBody2D

const LOOT_SCENE = preload("res://Loot.tscn")
const PROJECTILE_SCENE = preload("res://Projectile.tscn")

@export var enemy_type: String = "Comun" # Comun, Veloz, Robusta, Ranger

var health: int = 50
var speed: float = 70.0
var damage_amount: int = 20
var base_color: Color = Color.WHITE
var shoot_timer: float = 0.0

func _ready() -> void:
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
			$Sprite2D.modulate = Color(0.9, 0.4, 0.4, 1.0) # Rojo anaranjado / Contrabandista
		"Comun", _:
			health = 50
			speed = 70.0
			damage_amount = 20
			$Sprite2D.modulate = Color(0.3, 0.3, 0.3, 1.0) # Sombra gris básica
			
	# Guardamos el color de base para volver a él tras el parpadeo de daño
	base_color = $Sprite2D.modulate
	add_to_group("enemies")

func _physics_process(delta: float) -> void:
	if GameManager.is_dialogue_active:
		velocity = Vector2.ZERO
		return # Detener movimiento y daño durante diálogos
		
	var player = get_tree().get_root().find_child(GameManager.active_character, true, false)
	if player:
		var dist = global_position.distance_to(player.global_position)
		var direction = (player.global_position - global_position).normalized()
		
		if enemy_type == "Ranger":
			# IA de Ranger: mantener distancia y disparar
			if dist > 260.0:
				velocity = direction * speed
			elif dist < 170.0:
				velocity = -direction * speed # Retroceder (Kiting)
			else:
				velocity = Vector2.ZERO # Distancia perfecta, quieto
				
			# Disparar proyectil mágico carmesí
			shoot_timer += delta
			if shoot_timer >= 2.5:
				shoot_timer = 0.0
				_shoot_at_player(player)
		else:
			# IA Cuerpo a cuerpo: persecución directa
			velocity = direction * speed
			
		# Mover y detectar colisión cuerpo a cuerpo
		var collision = move_and_collide(velocity * delta)
		if collision:
			var collider = collision.get_collider()
			if collider and (collider.name == "Zantyr" or collider.name == "Aura"):
				if collider.has_method("take_damage"):
					collider.take_damage(damage_amount)

func _shoot_at_player(player: Node2D) -> void:
	var proj = PROJECTILE_SCENE.instantiate()
	proj.global_position = global_position
	proj.direction = global_position.direction_to(player.global_position)
	proj.is_enemy_projectile = true
	get_parent().add_child(proj)

func take_damage(amount: int) -> void:
	health -= amount
	print(enemy_type, " recibio daño! Vida restante: ", health)
	
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
