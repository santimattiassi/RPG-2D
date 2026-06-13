extends Interactable

@export var speaker_name: String = "Cartel"
@export var dialogue_lines: Array[String] = [
	"Es un cartel antiguo carcomido por la sal marina.",
	"Dice: 'Presiona TAB para alternar entre Zantyr y Aura.'",
	"Dice: 'Presiona X para sentar a Choco en los interruptores.'"
]

func interact() -> void:
	var hud = get_tree().get_root().find_child("HUD", true, false)
	if hud and hud.has_method("start_dialogue"):
		# Iniciar diálogo
		hud.start_dialogue(speaker_name, dialogue_lines)
