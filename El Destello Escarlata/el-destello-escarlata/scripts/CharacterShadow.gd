extends Node2D

@export var radius := 28.0
@export var alpha := 0.34

func _ready() -> void:
	z_index = -1
	position = Vector2(0, 26)
	scale = Vector2(1.45, 0.42)

func _draw() -> void:
	draw_circle(Vector2.ZERO, radius, Color(0.02, 0.012, 0.02, alpha))
