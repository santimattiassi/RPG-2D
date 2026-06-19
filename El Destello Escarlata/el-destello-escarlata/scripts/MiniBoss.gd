extends CharacterBody2D

const LOOT_SCENE = preload("res://Loot.tscn")
const PROJECTILE_SCENE = preload("res://Projectile.tscn")
const ENEMY_SCENE = preload("res://Enemy.tscn")

@export var boss_name: String = "Sombra de la Tempestad"
var health: int = 300
var max_health: int = 300
var speed: float = 60.0
var damage_amount: int = 30

var state: String = "Chase" # Chase, Whirlwind, Shoot, Death
var state_timer: float = 0.0
var shoot_cooldown: float = 0.0
var active_bar_triggered: bool = false
var has_summoned: bool = false
var is_active: bool = false

func _ready() -> void:
	add_to_group("enemies")
	# Modulación morada oscura gigante por defecto
	$Sprite2D.modulate = Color(0.5, 0.1, 0.7, 1.0)
	$Sprite2D.scale = Vector2(0.2, 0.2) # Tres veces el tamaño normal
	$CollisionShape2D.scale = Vector2(2.5, 2.5)

func activate_boss() -> void:
	is_active = true

func _physics_process(delta: float) -> void:
	if not is_active or GameManager.is_dialogue_active or state == "Death":
		velocity = Vector2.ZERO
		return
		
	var player = get_tree().get_root().find_child(GameManager.active_character, true, false)
	if player:
		# Activar la barra de jefe en el HUD al entrar en combate
		if not active_bar_triggered:
			active_bar_triggered = true
			var hud = get_tree().get_root().find_child("HUD", true, false)
			if hud and hud.has_method("show_boss_bar"):
				hud.show_boss_bar(max_health, boss_name)
		
		state_timer += delta
		var direction = (player.global_position - global_position).normalized()
		
		match state:
			"Chase":
				velocity = direction * speed
				# Giro lento hacia el jugador
				$Sprite2D.rotation = lerp_angle($Sprite2D.rotation, direction.angle(), 5.0 * delta)
				
				# Cambiar de estado periódicamente
				if state_timer >= 6.0:
					state_timer = 0.0
					state = "Whirlwind" if randf() < 0.5 else "Shoot"
					
			"Whirlwind":
				# Girar velozmente y enrojecer
				$Sprite2D.rotation += 15.0 * delta
				$Sprite2D.modulate = Color(1.0, 0.1, 0.1, 1.0) # Rojo furioso
				velocity = direction * speed * 2.2 # Veloz
				
				if state_timer >= 3.0:
					state_timer = 0.0
					$Sprite2D.modulate = Color(0.5, 0.1, 0.7, 1.0) # Vuelve al morado
					state = "Chase"
					
			"Shoot":
				velocity = Vector2.ZERO
				# Disparo radial en ráfagas
				shoot_cooldown += delta
				if shoot_cooldown >= 0.8:
					shoot_cooldown = 0.0
					_shoot_radial_burst()
					
				if state_timer >= 3.2:
					state_timer = 0.0
					state = "Chase"
					
		# Mover y chocar
		var collision = move_and_collide(velocity * delta)
		if collision:
			var collider = collision.get_collider()
			if collider and (collider.name == "Zantyr" or collider.name == "Aura"):
				if collider.has_method("take_damage"):
					collider.take_damage(damage_amount)

func _shoot_radial_burst() -> void:
	# Lanzar 8 proyectiles lentos en círculo
	for i in range(8):
		var angle = i * (PI / 4.0) # 45 grados de separación
		var proj = PROJECTILE_SCENE.instantiate()
		proj.global_position = global_position
		proj.direction = Vector2.RIGHT.rotated(angle)
		proj.is_enemy_projectile = true
		get_parent().add_child(proj)

func take_damage(amount: int) -> void:
	if state == "Death":
		return
		
	health = max(0, health - amount)
	
	# Actualizar HUD
	var hud = get_tree().get_root().find_child("HUD", true, false)
	if hud and hud.has_method("update_boss_hp"):
		hud.update_boss_hp(health)
		
	# Parpadeo de daño
	var prev_modulate = $Sprite2D.modulate
	$Sprite2D.modulate = Color.RED
	await get_tree().create_timer(0.1).timeout
	if state != "Death":
		$Sprite2D.modulate = prev_modulate
		
	# Invocación de refuerzos a mitad de vida
	if health <= 150 and not has_summoned:
		has_summoned = true
		_summon_minions()
		if hud:
			hud.start_dialogue(boss_name, ["¡Las sombras de la bodega responden a mi llamada!"])
			
	if health <= 0:
		_die(hud)

func _summon_minions() -> void:
	# Spawnear dos sombras comunes al costado
	for offset in [Vector2(-120, -120), Vector2(120, 120)]:
		var minion = ENEMY_SCENE.instantiate()
		minion.global_position = global_position + offset
		minion.enemy_type = "Comun"
		get_parent().add_child(minion)

func _die(hud: Node) -> void:
	state = "Death"
	print("¡MiniBoss derrotado!")
	
	# Actualizar estados globales
	GameManager.boss_defeated = true
	
	if hud:
		if hud.has_method("hide_boss_bar"):
			hud.hide_boss_bar()
		hud.start_dialogue("Tempestad", [
			"*(La Sombra de la Tempestad se disuelve con un alarido, liberando la resonancia del puerto.)*",
			"¡El camino hacia las tierras del norte ha quedado despejado!"
		])
		
	# Soltar gran botín (4 esferas oscuras gigantes)
	for i in range(4):
		var loot = LOOT_SCENE.instantiate()
		loot.global_position = global_position + Vector2(randf_range(-40, 40), randf_range(-40, 40))
		get_parent().add_child(loot)
		
	# Abrir el puerto: buscar la puerta bloqueada de reja en Puerto.tscn y abrirla
	var exit_door = get_parent().find_child("ExitDocksDoor", true, false)
	if exit_door and exit_door.has_method("open_door"):
		exit_door.open_door()
		
	# Permitir volver por donde vinimos
	var entrance_door = get_parent().find_child("EntranceGate", true, false)
	if entrance_door and entrance_door.has_method("open_door"):
		entrance_door.open_door()
		
	queue_free()
