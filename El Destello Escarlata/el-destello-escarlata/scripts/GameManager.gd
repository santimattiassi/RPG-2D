extends Node

# Stats Base de Zantyr (Acto 1)
var current_health: int = 150
var max_health: int = 150

var current_stamina: float = 100.0
var max_stamina: float = 100.0
var stamina_regen: float = 30.0 # Regenera 30 de stamina por segundo

var fragments: int = 0
var resonance_seals: int = 0
var party_members: Array[String] = ["Zantyr", "Aura"]
var active_character: String = "Zantyr"
var keys: int = 0
var is_dialogue_active: bool = false
var next_spawn_position: Vector2 = Vector2.ZERO

# Estadísticas dinámicas (RPG)
var zantyr_damage: int = 25
var aura_damage: int = 20
var aura_triple_shoot: bool = false

# Control de mejoras compradas
var upgrade_health_bought: bool = false
var upgrade_damage_bought: bool = false
var upgrade_stamina_bought: bool = false
var upgrade_triple_shoot_bought: bool = false

# Progreso del Nivel 1
var hold_puzzle_solved: bool = false
var boss_defeated: bool = false

# Progreso de la Batalla Final (Malakor)
var pillars_destroyed: int = 0

func use_key() -> bool:
	if keys > 0:
		keys -= 1
		print("Llave consumida. Llaves restantes: ", keys)
		return true
	return false

func buy_upgrade_health() -> bool:
	if fragments >= 10 and not upgrade_health_bought:
		fragments -= 10
		max_health += 50
		current_health += 50
		upgrade_health_bought = true
		return true
	return false

func buy_upgrade_damage() -> bool:
	if fragments >= 15 and not upgrade_damage_bought:
		fragments -= 15
		zantyr_damage = 40
		upgrade_damage_bought = true
		return true
	return false

func buy_upgrade_stamina() -> bool:
	if fragments >= 10 and not upgrade_stamina_bought:
		fragments -= 10
		max_stamina += 30
		current_stamina += 30
		upgrade_stamina_bought = true
		return true
	return false

func buy_upgrade_triple_shoot() -> bool:
	if fragments >= 15 and not upgrade_triple_shoot_bought:
		fragments -= 15
		aura_triple_shoot = true
		upgrade_triple_shoot_bought = true
		return true
	return false

func _ready() -> void:
	pass

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and event.keycode == KEY_TAB:
		if party_members.size() <= 1:
			return # No se puede cambiar si solo hay un miembro

		var current_idx = party_members.find(active_character)
		if current_idx == -1: return

		var next_idx = (current_idx + 1) % party_members.size()
		var next_character = party_members[next_idx]

		var root = get_tree().get_root()
		var current_node = root.find_child(active_character, true, false)
		var next_node = root.find_child(next_character, true, false)
		
		if current_node and next_node:
			next_node.global_position = current_node.global_position
			current_node.visible = false
			next_node.visible = true
			active_character = next_character
			print("Relevo: Jugando como ", active_character)

func _process(delta: float) -> void:
	# Regeneración pasiva de Stamina
	if current_stamina < max_stamina:
		current_stamina = minf(current_stamina + stamina_regen * delta, max_stamina)

func consume_stamina(amount: float) -> bool:
	if current_stamina >= amount:
		current_stamina -= amount
		print("Dash! Stamina restante: ", int(current_stamina))
		return true
	print("¡Sin Stamina!")
	return false

func heal(amount: int) -> void:
	current_health = clampi(current_health + amount, 0, max_health)
	print("Curación. Salud actual: ", current_health)

func take_damage(amount: int) -> void:
	current_health -= amount
	print("Zantyr recibió daño. Salud actual: ", current_health)
	if current_health <= 0:
		_game_over()

func add_seal(amount: int = 1) -> void:
	resonance_seals += amount
	print("Sellos recolectados: ", resonance_seals)

func _game_over() -> void:
	print("Zantyr ha caído... El mar lo reclama.")
