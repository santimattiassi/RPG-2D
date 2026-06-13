extends Interactable

@export var is_locked: bool = false
@export var gives_key: bool = false
@export var gives_fragments: int = 5

var is_opened: bool = false

func _ready() -> void:
	super._ready()
	if is_locked:
		prompt_message = "Abrir Cofre Cerrado"
	else:
		prompt_message = "Abrir Cofre"

func interact() -> void:
	var hud = get_tree().get_root().find_child("HUD", true, false)
	if not hud:
		return
		
	if is_opened:
		hud.start_dialogue("Cofre", ["El cofre ya está abierto y no queda nada dentro."])
		return
		
	if is_locked:
		if GameManager.keys > 0:
			if GameManager.use_key():
				is_locked = false
				prompt_message = "Abrir Cofre"
				# Proceder a abrirlo en esta misma interacción
				_open_chest(hud)
		else:
			hud.start_dialogue("Cofre", [
				"Este cofre está firmemente cerrado.",
				"Necesitas una Llave Antigua para abrirlo."
			])
	else:
		_open_chest(hud)

func _open_chest(hud: Node) -> void:
	is_opened = true
	prompt_message = "Cofre Vacío"
	# Modulación visual para dar sensación de abierto/vacío
	$Sprite2D.modulate = Color(0.4, 0.4, 0.4, 1.0) 
	
	if gives_key:
		GameManager.keys += 1
		hud.start_dialogue("Cofre", [
			"¡El cofre se abre crujiendo!",
			"Encontraste una *Llave Antigua* dorada flotando en su interior."
		])
	else:
		GameManager.fragments += gives_fragments
		hud.start_dialogue("Cofre", [
			"¡El cofre se abre de golpe!",
			"Encontraste " + str(gives_fragments) + " *Esferas Oscuras* resplandecientes."
		])
