extends CharacterBody2D

@export var speed: float = 180.0 # Un poco más lento que Zantyr
@export var follow_distance: float = 80.0 # Distancia a la que se mantiene de Zantyr

var zantyr: Node2D = null
var aura: Node2D = null
var is_staying: bool = false

func _ready() -> void:
	# Buscamos a ambos personajes al inicio
	var root = get_tree().get_root()
	zantyr = root.find_child("Zantyr", true, false)
	aura = root.find_child("Aura", true, false)
	
	# Evitar colisión física con Zantyr y Aura para que no se traben
	if zantyr:
		add_collision_exception_with(zantyr)
	if aura:
		add_collision_exception_with(aura)

func _unhandled_input(event: InputEvent) -> void:
	# Bloquear órdenes si hay un diálogo activo
	if GameManager.is_dialogue_active:
		return
	if event is InputEventKey and event.pressed and event.keycode == KEY_X:
		is_staying = !is_staying
		if is_staying:
			print("Choco: Sentado / Esperando...")
			$Sprite2D.modulate = Color(0.6, 0.6, 1.0, 1.0) # Tono azulado para indicar espera
		else:
			print("Choco: Siguiendo!")
			$Sprite2D.modulate = Color(1.0, 1.0, 1.0, 1.0) # Color normal

func _physics_process(delta: float) -> void:
	if is_staying:
		velocity = Vector2.ZERO
		return

	# Determinamos a quién seguir según el personaje activo
	var player = zantyr if GameManager.active_character == "Zantyr" else aura
	
	if player:
		var distance_to_player = global_position.distance_to(player.global_position)
		
		# Solo camina si está muy lejos del personaje activo (para no empujarlo)
		if distance_to_player > follow_distance:
			var direction = global_position.direction_to(player.global_position)
			velocity = direction * speed
			move_and_slide()
		else:
			# Se detiene al lado de su amo
			velocity = Vector2.ZERO
