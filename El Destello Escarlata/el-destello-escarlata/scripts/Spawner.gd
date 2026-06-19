extends Node2D

const ENEMY_SCENE = preload("res://Enemy.tscn")
@export var max_enemies: int = 8

func _ready() -> void:
	# Spawner estilo Zelda: Los enemigos se generan todos de una vez al entrar a la estancia
	for i in range(max_enemies):
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
	
	# Asegurarnos de que no aparezca exactamente encima del jugador activo o el spawn_position
	var player = get_tree().get_root().find_child(GameManager.active_character, true, false)
	var player_pos = Vector2.ZERO
	if player:
		player_pos = player.global_position
	elif GameManager.next_spawn_position != Vector2.ZERO:
		player_pos = GameManager.next_spawn_position
		
	if player_pos != Vector2.ZERO:
		while player_pos.distance_to(Vector2(random_x, random_y)) < 400:
			random_x = randf_range(-1400, 1400)
			random_y = randf_range(-1400, 1400)

	enemy.global_position = Vector2(random_x, random_y)
	get_parent().call_deferred("add_child", enemy)
