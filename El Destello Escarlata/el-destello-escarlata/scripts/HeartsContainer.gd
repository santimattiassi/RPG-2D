extends Control

@export var heart_size: float = 24.0
@export var spacing: float = 8.0

var last_health: int = -1
var last_max_health: int = -1

func _process(_delta: float) -> void:
	if GameManager.current_health != last_health or GameManager.max_health != last_max_health:
		last_health = GameManager.current_health
		last_max_health = GameManager.max_health
		queue_redraw()

func _draw() -> void:
	var max_hearts = GameManager.max_health / 25
	var full_hearts = GameManager.current_health / 25
	var remainder = GameManager.current_health % 25
	
	for i in range(max_hearts):
		var pos = Vector2(i * (heart_size + spacing) + heart_size/2.0, heart_size/2.0)
		
		# Determinar el estado de llenado
		var fill_ratio = 0.0
		if i < full_hearts:
			fill_ratio = 1.0
		elif i == full_hearts:
			if remainder >= 18:
				fill_ratio = 1.0
			elif remainder >= 7:
				fill_ratio = 0.5
			else:
				fill_ratio = 0.0
		else:
			fill_ratio = 0.0
			
		draw_heart(pos, heart_size, fill_ratio)

func draw_heart(pos: Vector2, size: float, fill_ratio: float) -> void:
	# 1. Dibujar contorno exterior oscuro
	var pts_outline = get_heart_points(size + 3.0)
	var offset_pts_outline = PackedVector2Array()
	for p in pts_outline:
		offset_pts_outline.append(p + pos)
	draw_colored_polygon(offset_pts_outline, Color(0.2, 0.05, 0.05, 1.0))
	
	# 2. Dibujar fondo vacío del corazón
	var pts_bg = get_heart_points(size)
	var offset_pts_bg = PackedVector2Array()
	for p in pts_bg:
		offset_pts_bg.append(p + pos)
	draw_colored_polygon(offset_pts_bg, Color(0.25, 0.2, 0.2, 1.0))
	
	# 3. Dibujar relleno según fill_ratio
	if fill_ratio > 0.0:
		var color = Color(0.9, 0.15, 0.15, 1.0) # Rojo Zelda clásico
		if fill_ratio >= 1.0:
			draw_colored_polygon(offset_pts_bg, color)
		else:
			# Dibujar mitad izquierda en rojo
			var pts_left = get_heart_points_half(size, true)
			var offset_pts_left = PackedVector2Array()
			for p in pts_left:
				offset_pts_left.append(p + pos)
			draw_colored_polygon(offset_pts_left, color)

func get_heart_points(size: float) -> PackedVector2Array:
	var pts = PackedVector2Array()
	var steps = 24
	for i in range(steps):
		var t = i * 2.0 * PI / steps
		var x = 16.0 * pow(sin(t), 3.0)
		var y = -(13.0 * cos(t) - 5.0 * cos(2.0 * t) - 2.0 * cos(3.0 * t) - cos(4.0 * t))
		
		var scale_factor = size / 32.0
		pts.append(Vector2(x, y) * scale_factor)
	return pts

func get_heart_points_half(size: float, left: bool) -> PackedVector2Array:
	var pts = PackedVector2Array()
	var steps = 24
	for i in range(steps + 1):
		var t = i * 2.0 * PI / steps
		var x = 16.0 * pow(sin(t), 3.0)
		var y = -(13.0 * cos(t) - 5.0 * cos(2.0 * t) - 2.0 * cos(3.0 * t) - cos(4.0 * t))
		
		if left and x > 0.05:
			x = 0.0
		elif not left and x < -0.05:
			x = 0.0
			
		var scale_factor = size / 32.0
		pts.append(Vector2(x, y) * scale_factor)
	return pts
