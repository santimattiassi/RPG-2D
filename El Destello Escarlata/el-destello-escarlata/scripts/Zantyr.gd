extends Player

@export var attack_duration: float = 0.2
var attack_timer: float = 0.0

@onready var hitbox_shape = $WeaponPivot/AttackHitbox/CollisionShape2D

func _ready() -> void:
	move_speed = 200.0
	dash_speed = 600.0
	dash_duration = 0.2
	
	var hitbox = get_node_or_null("WeaponPivot/AttackHitbox")
	if hitbox:
		hitbox.body_entered.connect(_on_attack_hitbox_body_entered)

func _handle_attack() -> void:
	if current_state != State.ATTACK:
		current_state = State.ATTACK
		attack_timer = attack_duration
		velocity = Vector2.ZERO # Nos detenemos un poco al dar el espadazo
		
		if hitbox_shape:
			hitbox_shape.disabled = false
		if sprite:
			sprite.modulate = Color.RED
			
		if has_node("/root/SoundManager"):
			get_node("/root/SoundManager").play_sword()

func _process_attack(delta: float) -> void:
	attack_timer -= delta
	move_and_slide()
	
	if attack_timer <= 0:
		current_state = State.IDLE
		if hitbox_shape:
			hitbox_shape.disabled = true
		if sprite:
			sprite.modulate = Color.WHITE

func _on_attack_hitbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemies"):
		if body.has_method("take_damage"):
			body.take_damage(GameManager.zantyr_damage, global_position)
