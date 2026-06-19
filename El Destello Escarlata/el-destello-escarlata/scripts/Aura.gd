extends Player

const PROJECTILE_SCENE = preload("res://Projectile.tscn")
var shoot_cooldown: float = 0.0

func _ready() -> void:
	move_speed = 220.0
	dash_speed = 800.0
	dash_duration = 0.15

func _physics_process(delta: float) -> void:
	if shoot_cooldown > 0:
		shoot_cooldown -= delta
	super._physics_process(delta)

func _handle_attack() -> void:
	if GameManager.consume_stamina(5.0):
		shoot_projectile()

func shoot_projectile() -> void:
	if shoot_cooldown > 0:
		return
	shoot_cooldown = 0.35 # Cadencia de disparo
	
	if has_node("/root/SoundManager"):
		get_node("/root/SoundManager").play_magic()
	
	if not weapon_pivot or not weapon_pivot.has_node("FirePoint"):
		return
		
	var fire_point_pos = weapon_pivot.get_node("FirePoint").global_position
	var base_rot = weapon_pivot.rotation
	
	if GameManager.aura_triple_shoot:
		for angle_offset in [-0.25, 0.0, 0.25]:
			var proj = PROJECTILE_SCENE.instantiate()
			proj.global_position = fire_point_pos
			proj.direction = Vector2.RIGHT.rotated(base_rot + angle_offset)
			get_parent().add_child(proj)
	else:
		var proj = PROJECTILE_SCENE.instantiate()
		proj.global_position = fire_point_pos
		proj.direction = Vector2.RIGHT.rotated(base_rot)
		get_parent().add_child(proj)
