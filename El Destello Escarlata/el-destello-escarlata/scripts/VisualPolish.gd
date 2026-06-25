extends Node2D
class_name VisualPolish

const SHADOW_SCRIPT := preload("res://scripts/CharacterShadow.gd")
const SHIP_DECK_TEXTURE := preload("res://assets/Wooden-ship.png")
const OBSIDIAN_TEXTURE := preload("res://assets/ObsidianStone.png")

const PRESETS := {
	"Mundo": {
		"bounds": Rect2(-1500, -1500, 3000, 3000),
		"base": Color(0.19, 0.105, 0.055),
		"alt": Color(0.27, 0.15, 0.075),
		"line": Color(0.055, 0.03, 0.018, 0.72),
		"accent": Color(0.95, 0.36, 0.16, 0.28),
		"texture_tint": Color(0.95, 0.78, 0.58, 1.0),
		"wall": Color(0.105, 0.068, 0.04),
		"kind": "deck"
	},
	"Camarote": {
		"bounds": Rect2(-500, -400, 1000, 800),
		"base": Color(0.22, 0.12, 0.07),
		"alt": Color(0.34, 0.19, 0.095),
		"line": Color(0.07, 0.036, 0.018, 0.68),
		"accent": Color(1.0, 0.66, 0.28, 0.22),
		"texture_tint": Color(0.94, 0.70, 0.48, 1.0),
		"wall": Color(0.15, 0.075, 0.038),
		"kind": "cabin"
	},
	"Bodega": {
		"bounds": Rect2(-500, -400, 1000, 800),
		"base": Color(0.15, 0.12, 0.095),
		"alt": Color(0.235, 0.17, 0.115),
		"line": Color(0.045, 0.034, 0.026, 0.72),
		"accent": Color(0.34, 0.72, 0.82, 0.18),
		"texture_tint": Color(0.72, 0.68, 0.62, 1.0),
		"wall": Color(0.08, 0.06, 0.042),
		"kind": "hold"
	},
	"Puerto": {
		"bounds": Rect2(-575, -475, 1150, 950),
		"base": Color(0.13, 0.145, 0.15),
		"alt": Color(0.22, 0.19, 0.13),
		"line": Color(0.035, 0.045, 0.052, 0.74),
		"accent": Color(0.25, 0.72, 0.95, 0.22),
		"texture_tint": Color(0.62, 0.70, 0.74, 1.0),
		"wall": Color(0.045, 0.055, 0.065),
		"kind": "docks"
	},
	"Bastian": {
		"bounds": Rect2(-500, -450, 1000, 850),
		"base": Color(0.105, 0.065, 0.125),
		"alt": Color(0.22, 0.09, 0.155),
		"line": Color(0.025, 0.018, 0.035, 0.76),
		"accent": Color(1.0, 0.18, 0.08, 0.30),
		"texture_tint": Color(0.82, 0.72, 0.86, 1.0),
		"wall": Color(0.038, 0.032, 0.055),
		"kind": "bastion"
	}
}

var level: Node2D
var preset: Dictionary
var room_bounds := Rect2(-500, -400, 1000, 800)

static func apply_to_level(target_level: Node2D) -> void:
	if target_level.has_node("VisualPolish"):
		return

	var polish := VisualPolish.new()
	polish.name = "VisualPolish"
	polish.z_index = -50
	target_level.add_child(polish)
	target_level.move_child(polish, 0)
	polish.configure(target_level)

func configure(target_level: Node2D) -> void:
	level = target_level
	preset = PRESETS.get(level.name, PRESETS["Camarote"])
	room_bounds = preset["bounds"]
	_prepare_floor()
	_repaint_walls()
	_hide_world_labels(level)
	_add_actor_shadows(level)
	queue_redraw()

func _prepare_floor() -> void:
	var floor := level.find_child("Floor", true, false)
	if floor:
		floor.visible = false

func _repaint_walls() -> void:
	var walls := level.find_child("Walls", true, false)
	if not walls:
		return
	for rect in walls.find_children("ColorRect", "ColorRect", true, false):
		rect.color = preset["wall"]
		rect.z_index = 4

func _hide_world_labels(root: Node) -> void:
	if root.name == "HUD":
		return
	if root is Label:
		root.visible = false
	for child in root.get_children():
		_hide_world_labels(child)

func _add_actor_shadows(root: Node) -> void:
	for child in root.get_children():
		if child is CharacterBody2D or child is StaticBody2D or child is Area2D:
			_add_shadow_to_node(child)
		_add_actor_shadows(child)

func _add_shadow_to_node(node: Node) -> void:
	if node.name == "HUD" or node.has_node("PaintedShadow"):
		return
	var sprite := node.find_child("Sprite2D", false, false)
	if not sprite:
		return
	var shadow = SHADOW_SCRIPT.new()
	shadow.name = "PaintedShadow"
	shadow.radius = 30.0
	if node is Area2D:
		shadow.radius = 20.0
	if str(node.name).contains("Boss") or node.name == "Malakor":
		shadow.radius = 44.0
	node.add_child(shadow)
	node.move_child(shadow, 0)

func _draw() -> void:
	_draw_floor()
	_draw_room_edges()
	_draw_landmarks()
	_draw_atmosphere()

func _draw_floor() -> void:
	var base: Color = preset["base"]
	var alt: Color = preset["alt"]
	var line: Color = preset["line"]
	var tint: Color = preset["texture_tint"]
	var floor_texture := OBSIDIAN_TEXTURE if preset["kind"] == "bastion" else SHIP_DECK_TEXTURE
	draw_rect(room_bounds, base, true)
	draw_texture_rect(floor_texture, room_bounds, true, tint)
	draw_rect(room_bounds, Color(base.r, base.g, base.b, 0.18), true)

	if preset["kind"] == "bastion":
		_draw_stone_floor_overlay(line)
	else:
		_draw_plank_floor_overlay(line)

func _draw_plank_floor_overlay(line: Color) -> void:
	var plank_h := 54.0
	var plank_w := 228.0
	var y := room_bounds.position.y
	var row := 0
	while y < room_bounds.end.y:
		var x := room_bounds.position.x - (row % 2) * (plank_w * 0.5)
		while x < room_bounds.end.x:
			var rect := Rect2(x, y, plank_w - 4.0, plank_h - 5.0).intersection(room_bounds)
			draw_rect(rect, Color(line.r, line.g, line.b, 0.18), false, 1.0)
			if int(abs(x + y)) % 3 == 0:
				draw_line(rect.position + Vector2(16, rect.size.y * 0.45), rect.position + Vector2(rect.size.x - 20, rect.size.y * 0.52), Color(0.82, 0.56, 0.30, 0.10), 1.0)
			x += plank_w
		y += plank_h
		row += 1

func _draw_stone_floor_overlay(line: Color) -> void:
	var tile := 96.0
	var y := room_bounds.position.y
	var row := 0
	while y < room_bounds.end.y:
		var x := room_bounds.position.x - (row % 2) * (tile * 0.35)
		while x < room_bounds.end.x:
			var rect := Rect2(x, y, tile - 5.0, tile - 5.0).intersection(room_bounds)
			draw_rect(rect, Color(line.r, line.g, line.b, 0.10), false, 1.1)
			if _grain(x * 0.7, y * 1.3) > 0.52:
				draw_line(rect.position + Vector2(18, 22), rect.position + Vector2(rect.size.x - 24, rect.size.y - 18), Color(1.0, 0.18, 0.08, 0.13), 1.0)
			x += tile
		y += tile
		row += 1

func _draw_room_edges() -> void:
	var edge := Color(0.0, 0.0, 0.0, 0.34)
	var glow: Color = preset["accent"]
	draw_rect(Rect2(room_bounds.position, Vector2(room_bounds.size.x, 80)), edge, true)
	draw_rect(Rect2(Vector2(room_bounds.position.x, room_bounds.end.y - 80), Vector2(room_bounds.size.x, 80)), edge, true)
	draw_rect(Rect2(room_bounds.position, Vector2(80, room_bounds.size.y)), edge, true)
	draw_rect(Rect2(Vector2(room_bounds.end.x - 80, room_bounds.position.y), Vector2(80, room_bounds.size.y)), edge, true)
	draw_rect(room_bounds.grow(-16), Color(1.0, 0.84, 0.48, 0.055), false, 3.0)
	draw_rect(room_bounds.grow(-38), glow, false, 2.0)

func _draw_landmarks() -> void:
	var kind: String = preset["kind"]
	if kind == "deck":
		_draw_rug(Vector2(0, 150), Vector2(360, 150), Color(0.55, 0.08, 0.045, 0.74))
		_draw_coils(Vector2(-540, -420))
		_draw_coils(Vector2(640, 520))
	elif kind == "cabin":
		_draw_rug(Vector2(0, -80), Vector2(420, 180), Color(0.55, 0.07, 0.045, 0.78))
		_draw_table(Vector2(-280, 95))
		_draw_table(Vector2(280, -155))
	elif kind == "hold":
		_draw_crate_stack(Vector2(-385, -180))
		_draw_crate_stack(Vector2(330, -135))
		_draw_barrel(Vector2(-210, 215))
		_draw_barrel(Vector2(235, 205))
	elif kind == "docks":
		_draw_water_slits()
		_draw_crate_stack(Vector2(-390, -275))
		_draw_barrel(Vector2(410, 250))
	elif kind == "bastion":
		_draw_ritual_marks()
		_draw_rug(Vector2(0, -260), Vector2(520, 150), Color(0.36, 0.02, 0.06, 0.82))

func _draw_rug(center: Vector2, size: Vector2, color: Color) -> void:
	var rect := Rect2(center - size * 0.5, size)
	draw_rect(rect, Color(0.02, 0.0, 0.0, 0.22), true)
	draw_rect(rect.grow(-10), color, true)
	draw_rect(rect.grow(-22), Color(0.96, 0.56, 0.20, 0.22), false, 3.0)
	for i in range(5):
		var yy := rect.position.y + 24 + i * 24
		draw_line(Vector2(rect.position.x + 28, yy), Vector2(rect.end.x - 28, yy + 8), Color(1.0, 0.78, 0.42, 0.13), 2.0)

func _draw_table(center: Vector2) -> void:
	var rect := Rect2(center - Vector2(92, 38), Vector2(184, 76))
	draw_rect(rect.position + Vector2(8, 10), Color(0.0, 0.0, 0.0, 0.23), true)
	draw_rect(rect, Color(0.21, 0.105, 0.045, 0.96), true)
	draw_rect(rect.grow(-9), Color(0.47, 0.27, 0.10, 0.65), false, 3.0)

func _draw_crate_stack(center: Vector2) -> void:
	for offset in [Vector2.ZERO, Vector2(56, 20), Vector2(18, -44)]:
		var rect := Rect2(center + offset - Vector2(34, 30), Vector2(68, 60))
		draw_rect(rect.position + Vector2(8, 10), Color(0.0, 0.0, 0.0, 0.22), true)
		draw_rect(rect, Color(0.25, 0.135, 0.065, 0.95), true)
		draw_rect(rect, Color(0.065, 0.035, 0.025, 0.82), false, 2.0)
		draw_line(rect.position, rect.end, Color(0.72, 0.45, 0.20, 0.23), 2.0)
		draw_line(Vector2(rect.end.x, rect.position.y), Vector2(rect.position.x, rect.end.y), Color(0.72, 0.45, 0.20, 0.18), 2.0)

func _draw_barrel(center: Vector2) -> void:
	draw_circle(center + Vector2(8, 10), 31, Color(0, 0, 0, 0.20))
	draw_circle(center, 30, Color(0.25, 0.13, 0.055, 0.95))
	draw_circle(center, 22, Color(0.47, 0.25, 0.10, 0.50))
	draw_line(center + Vector2(-26, -8), center + Vector2(26, -8), Color(0.05, 0.035, 0.025, 0.85), 2.0)
	draw_line(center + Vector2(-26, 9), center + Vector2(26, 9), Color(0.05, 0.035, 0.025, 0.85), 2.0)

func _draw_coils(center: Vector2) -> void:
	for radius in [42.0, 30.0, 18.0]:
		draw_arc(center, radius, 0.2, TAU * 0.92, 32, Color(0.62, 0.48, 0.29, 0.48), 5.0)

func _draw_water_slits() -> void:
	for x in [-410, -220, 210, 405]:
		var rect := Rect2(Vector2(x - 45, -20), Vector2(90, 430))
		draw_rect(rect, Color(0.015, 0.055, 0.075, 0.78), true)
		for i in range(5):
			draw_line(rect.position + Vector2(12, 38 + i * 68), rect.position + Vector2(76, 52 + i * 68), Color(0.25, 0.85, 1.0, 0.16), 2.0)

func _draw_ritual_marks() -> void:
	var center := Vector2(0, -50)
	for radius in [120.0, 190.0, 260.0]:
		draw_arc(center, radius, 0.0, TAU, 96, Color(1.0, 0.16, 0.08, 0.20), 3.0)
	for i in range(8):
		var angle := TAU * float(i) / 8.0
		var a := center + Vector2(cos(angle), sin(angle)) * 120.0
		var b := center + Vector2(cos(angle), sin(angle)) * 260.0
		draw_line(a, b, Color(1.0, 0.16, 0.08, 0.15), 3.0)

func _draw_atmosphere() -> void:
	var accent: Color = preset["accent"]
	for i in range(6):
		var p := Vector2(
			lerp(room_bounds.position.x + 120.0, room_bounds.end.x - 120.0, _grain(i * 47.0, i * 13.0)),
			lerp(room_bounds.position.y + 120.0, room_bounds.end.y - 120.0, _grain(i * 17.0, i * 59.0))
		)
		draw_circle(p, 70.0 + _grain(p.x, p.y) * 90.0, Color(accent.r, accent.g, accent.b, 0.035))

func _grain(x: float, y: float) -> float:
	var value := abs(sin(x * 12.9898 + y * 78.233) * 43758.5453)
	return value - floor(value)
