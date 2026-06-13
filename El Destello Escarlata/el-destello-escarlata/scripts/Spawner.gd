extends Node2D

const ENEMY_SCENE = preload("res://Enemy.tscn")
@export var spawn_interval: float = 3.0
var timer: float = 0.0

func _process(delta: float) -> void:
	if GameManager.is_dialogue_active:
		return # Congelar el temporizador de oleadas
	timer += delta
	if timer >= spawn_interval:
		timer = 0.0
		spawn_enemy()

func spawn_enemy() -> void:
	var enemy = ENEMY_SCENE.instantiate()
	
	# Randomizar variantes de enemigos en las oleadas de la cubierta
	var roll = randf()
	if roll < 0.50:
		enemy.enemy_type = "Comun"
	elif roll < 0.70:
		enemy.enemy_type = "Veloz"
	elif roll < 0.85:
		enemy.enemy_type = "Robusta"
	else:
		enemy.enemy_type = "Ranger"
	
	# Elegir un lado aleatorio para spawnear cerca de los bordes del mapa gigante
	var random_x = randf_range(-1400, 1400)
	var random_y = randf_range(-1400, 1400)
	
	# Asegurarnos de que no aparezca exactamente encima del jugador activo
	var player = get_tree().get_root().find_child(GameManager.active_character, true, false)
	if player:
		while player.global_position.distance_to(Vector2(random_x, random_y)) < 400:
			random_x = randf_range(-1400, 1400)
			random_y = randf_range(-1400, 1400)

	enemy.global_position = Vector2(random_x, random_y)
	get_parent().add_child(enemy)
