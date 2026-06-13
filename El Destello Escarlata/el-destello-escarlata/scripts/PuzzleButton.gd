extends Interactable

@export var button_id: int = 0

func interact() -> void:
	var parent = get_parent()
	if parent and parent.has_method("press_button"):
		parent.press_button(button_id)
