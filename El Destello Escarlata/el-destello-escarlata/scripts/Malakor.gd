extends CharacterBody2D

const LOOT_SCENE = preload("res://Loot.tscn")
const PROJECTILE_SCENE = preload("res://Projectile.tscn")
const ENEMY_SCENE = preload("res://Enemy.tscn")
const PILLAR_SCENE = preload("res://ResonancePillar.tscn")

@export var boss_name: String = "Malakor, el Resonante Corrupto"
var health: int = 500
var max_health: int = 500
var speed: float = 65.0
var damage_amount: int = 35

var state: String = "Phase1" # Phase1, Shielded, Phase3, Death
var state_timer: float = 0.0
var shoot_cooldown: float = 0.0
var active_bar_triggered: bool = false
var has_summoned_pillars: bool = false
var berserk_timer: float = 0.0
var is_active: bool = false

func _ready() -> void:
	add_to_group("enemies")
	# Modulado morado y dorado gigante por defecto
	$Sprite2D.modulate = Color(0.6, 0.1, 0.8, 1.0)
	$Sprite2D.scale = Vector2(0.24, 0.24) # Gigante x3.5 del normal
	$CollisionShape2D.scale = Vector2(3.0, 3.0)

func activate_boss() -> void:
	is_active = true

func _physics_process(delta: float) -> void:
	if not is_active or GameManager.is_dialogue_active or state == "Death":
		velocity = Vector2.ZERO
		return
		
	var player = get_tree().get_root().find_child(GameManager.active_character, true, false)
	if player:
		# Activar la barra de jefe en el HUD
		if not active_bar_triggered:
			active_bar_triggered = true
			var hud = get_tree().get_root().find_child("HUD", true, false)
			if hud and hud.has_method("show_boss_bar"):
				hud.show_boss_bar(max_health, boss_name)
		
		var direction = (player.global_position - global_position).normalized()
		
		match state:
			"Phase1":
				velocity = direction * speed
				$Sprite2D.rotation = lerp_angle($Sprite2D.rotation, direction.angle(), 4.0 * delta)
				
				# Disparar proyectiles teledirigidos (homing) cada 4 segundos
				shoot_cooldown += delta
				if shoot_cooldown >= 4.0:
					shoot_cooldown = 0.0
					_shoot_homing_bullet(player)
					
				# Pasar a Fase 2 (Escudo) al 70% de vida (350 HP)
				if health <= 350:
					state = "Shielded"
					shoot_cooldown = 0.0
					state_timer = 0.0
					
			"Shielded":
				velocity = Vector2.ZERO
				# Invocar pilares si no se ha hecho
				if not has_summoned_pillars:
					has_summoned_pillars = true
					_spawn_pillars()
					
				# Monitorear pilares
				if GameManager.pillars_destroyed >= 2:
					# Romper escudo y pasar a fase 3
					state = "Phase3"
					shoot_cooldown = 0.0
					state_timer = 0.0
					$Sprite2D.modulate = Color(0.15, 0.15, 0.15, 1.0) # Modulación negra Berserk
					var hud = get_tree().get_root().find_child("HUD", true, false)
					if hud:
						hud.start_dialogue(boss_name, [
							"¡Mi barrera de resonancia... disuelta!",
							"¡No importa! ¡Los aplastaré con mis propias garras!",
							"*(¡Malakor ha entrado en modo Berserk!)*"
						])
						
			"Phase3":
				# Persecución veloz y giratoria
				velocity = direction * speed * 1.5 # Berserk es más rápido
				$Sprite2D.rotation += 8.0 * delta
				
				# Disparo radial continuo en ráfagas cada 1.5 segundos
				shoot_cooldown += delta
				if shoot_cooldown >= 1.5:
					shoot_cooldown = 0.0
					_shoot_radial_burst()
					
				# Invocar sombras veloces ayudantes cada 6 segundos
				berserk_timer += delta
				if berserk_timer >= 6.0:
					berserk_timer = 0.0
					_spawn_fast_helpers()
					
		# Mover y colisionar
		var collision = move_and_collide(velocity * delta)
		if collision:
			var collider = collision.get_collider()
			if collider and (collider.name == "Zantyr" or collider.name == "Aura"):
				if collider.has_method("take_damage"):
					collider.take_damage(damage_amount)

func _shoot_homing_bullet(player: Node2D) -> void:
	var proj = PROJECTILE_SCENE.instantiate()
	proj.global_position = global_position
	proj.direction = global_position.direction_to(player.global_position)
	proj.is_homing = true
	get_parent().add_child(proj)

func _shoot_radial_burst() -> void:
	# Lanzar 10 proyectiles en círculo
	for i in range(10):
		var angle = i * (PI * 2.0 / 10.0)
		var proj = PROJECTILE_SCENE.instantiate()
		proj.global_position = global_position
		proj.direction = Vector2.RIGHT.rotated(angle)
		proj.is_enemy_projectile = true
		get_parent().add_child(proj)

func _spawn_pillars() -> void:
	# Crear los 2 pilares de resonancia
	# Pilar 1: Lado izquierdo (Aura debe disparar sobre el foso)
	var p1 = PILLAR_SCENE.instantiate()
	p1.global_position = global_position + Vector2(-350, -50)
	get_parent().add_child(p1)
	
	# Pilar 2: Lado derecho (Zantyr pelea cuerpo a cuerpo)
	var p2 = PILLAR_SCENE.instantiate()
	p2.global_position = global_position + Vector2(350, -50)
	get_parent().add_child(p2)

func _spawn_fast_helpers() -> void:
	# Invocar 2 sombras veloces
	for offset in [Vector2(-100, 100), Vector2(100, 100)]:
		var helper = ENEMY_SCENE.instantiate()
		helper.global_position = global_position + offset
		helper.enemy_type = "Veloz"
		get_parent().add_child(helper)

func take_damage(amount: int) -> void:
	if state == "Death":
		return
		
	var hud = get_tree().get_root().find_child("HUD", true, false)
	
	if state == "Shielded":
		# Totalmente inmune durante el escudo
		print("¡Inmune! Destruye los Pilares de Resonancia.")
		$Sprite2D.modulate = Color(1.0, 1.0, 1.0, 1.0) # Destello blanco de inmunidad
		await get_tree().create_timer(0.08).timeout
		if state == "Shielded":
			$Sprite2D.modulate = Color(1.0, 0.84, 0.0, 1.0) # Vuelve al escudo dorado
		return
		
	health = max(0, health - amount)
	
	if hud and hud.has_method("update_boss_hp"):
		hud.update_boss_hp(health)
		
	# Parpadeo rojo de daño
	var prev_color = $Sprite2D.modulate
	$Sprite2D.modulate = Color.RED
	await get_tree().create_timer(0.1).timeout
	if state != "Death":
		$Sprite2D.modulate = prev_color
		
	if health <= 0:
		_die(hud)

func _die(hud: Node) -> void:
	state = "Death"
	print("¡Malakor derrotado de forma definitiva!")
	
	if hud:
		if hud.has_method("hide_boss_bar"):
			hud.hide_boss_bar()
		hud.start_dialogue(boss_name, [
			"*(Malakor ruge mientras grietas de luz dorada fracturan su forma oscura...)*",
			"¡Noooo! El Sello de Resonancia... se ha... roto...",
			"*(La corrupción se desvanece de las aguas. El Destello Escarlata está a salvo.)*"
		])
		
	# Soltar lluvia masiva de esferas
	for i in range(8):
		var loot = LOOT_SCENE.instantiate()
		loot.global_position = global_position + Vector2(randf_range(-60, 60), randf_range(-60, 60))
		get_parent().add_child(loot)
		
	# Desbloquear puerta final
	var exit_door = get_parent().find_child("ExitBastianDoor", true, false)
	if exit_door and exit_door.has_method("open_door"):
		exit_door.open_door()
		
	queue_free()
