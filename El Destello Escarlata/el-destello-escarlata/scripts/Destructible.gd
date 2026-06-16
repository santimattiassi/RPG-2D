extends StaticBody2D

@export var type: String = "Bush" # Bush, Jar

const LOOT_SCENE = preload("res://Loot.tscn")

var health: int = 1

func _ready() -> void:
	add_to_group("enemies")
	
	# Configurar aspecto visual
	if type == "Bush":
		$Sprite2D.modulate = Color(0.1, 0.7, 0.1, 1.0) # Verde arbusto
		$Label.text = "ARBUSTO"
		$Sprite2D.scale = Vector2(0.38, 0.38)
	else:
		$Sprite2D.modulate = Color(0.7, 0.4, 0.15, 1.0) # Terracota de jarra
		$Label.text = "JARRÓN"
		$Sprite2D.scale = Vector2(0.3, 0.38) # Alargado

func take_damage(amount: int, _source_pos: Vector2 = Vector2.ZERO) -> void:
	health -= amount
	if health <= 0:
		_break_object()

func _break_object() -> void:
	# 1. Sonido retro
	if has_node("/root/SoundManager"):
		get_node("/root/SoundManager").play_hit()
		
	# 2. Partículas dinámicas de rotura
	var particles = CPUParticles2D.new()
	get_parent().add_child(particles)
	particles.global_position = global_position
	particles.emitting = true
	particles.one_shot = true
	particles.explosiveness = 1.0
	particles.amount = 12
	particles.lifetime = 0.45
	particles.spread = 180.0
	particles.gravity = Vector2(0, 150)
	particles.initial_velocity_min = 60.0
	particles.initial_velocity_max = 140.0
	particles.scale_amount_min = 3.0
	particles.scale_amount_max = 7.0
	
	if type == "Bush":
		particles.color = Color(0.15, 0.75, 0.15, 1.0)
	else:
		particles.color = Color(0.65, 0.35, 0.1, 1.0)
		
	get_tree().create_timer(0.6).timeout.connect(func(): particles.queue_free())
	
	# 3. Probabilidad de soltar botín
	var rand = randf()
	if rand < 0.65:
		var loot = LOOT_SCENE.instantiate()
		loot.global_position = global_position
		
		# Determinar tipo
		var type_rand = randf()
		if type_rand < 0.55:
			loot.loot_type = "Fragment"
		elif type_rand < 0.85:
			loot.loot_type = "Heart"
		else:
			loot.loot_type = "Stamina"
			
		get_parent().add_child(loot)
		
	# 4. Destruir objeto
	queue_free()
