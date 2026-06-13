extends Interactable

@export var npc_name: String = "Aliado"
@export var dialogue_pages: Array[String] = [
	"¡Hola! Mucho cuidado en este lugar.",
	"La niebla carmesí altera a las criaturas de las sombras."
]

var has_healed: bool = false

func _ready() -> void:
	super._ready()
	prompt_message = "Hablar con " + npc_name

func interact() -> void:
	var hud = get_tree().get_root().find_child("HUD", true, false)
	if not hud:
		return
		
	if npc_name == "Elina":
		if not has_healed:
			has_healed = true
			# Sanar al jugador por completo
			GameManager.current_health = GameManager.max_health
			hud.start_dialogue(npc_name, [
				"¡Capitán Zantyr! Aura! Qué alivio verlos con vida.",
				"Déjenme aplicarles un ungüento de esencias florales para sanar sus cuerpos...",
				"*(¡Tu salud ha sido completamente restaurada!)*",
				"La escotilla hacia el puerto está trabada por un cerrojo mágico de 3 placas.",
				"Hablen con Orfeo, él conoce bien los secretos de la nave."
			])
		else:
			hud.start_dialogue(npc_name, [
				"Mis ungüentos curativos se han agotado por hoy.",
				"Por favor, tengan mucho cuidado allí abajo.",
				"Algo inmenso acecha en los muelles de desembarco."
			])
	elif npc_name == "Orfeo":
		hud.start_dialogue(npc_name, [
			"Miau... Los humanos y sus cerrojos complicados...",
			"Para abrir la puerta de la Bodega deben activar los 3 interruptores en secuencia.",
			"El orden correcto es: primero el interruptor izquierdo, luego la placa central y al final el interruptor derecho.",
			"Pero miau... la placa central requiere peso continuo. Tendrán que pedirle a Choco que se quede sentado allí con 'X'."
		])
	else:
		hud.start_dialogue(npc_name, dialogue_pages)
