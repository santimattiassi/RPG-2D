extends Node

var sample_rate: float = 22050.0

func play_tone(freq_start: float, freq_end: float, duration: float, type: String = "sine", volume: float = 0.08) -> void:
	var player = AudioStreamPlayer.new()
	player.process_mode = PROCESS_MODE_ALWAYS # Suena incluso si el juego está pausado
	add_child(player)
	
	var generator = AudioStreamGenerator.new()
	generator.mix_rate = sample_rate
	generator.buffer_length = duration + 0.1
	player.stream = generator
	player.play()
	
	var playback = player.get_stream_playback()
	if not playback:
		player.queue_free()
		return
		
	var num_samples = int(sample_rate * duration)
	var points = PackedVector2Array()
	points.resize(num_samples)
	
	var phase: float = 0.0
	for i in range(num_samples):
		var pct = float(i) / num_samples
		var freq = lerp(freq_start, freq_end, pct)
		
		phase += 2.0 * PI * freq / sample_rate
		phase = fmod(phase, 2.0 * PI)
		
		var val: float = 0.0
		if type == "sine":
			val = sin(phase)
		elif type == "square":
			val = 1.0 if phase < PI else -1.0
		elif type == "noise":
			val = randf_range(-1.0, 1.0)
		elif type == "saw":
			val = (phase / PI) - 1.0
			
		# Envolvente: atenuar al final para evitar chasquido y ataque suave al inicio
		var env = 1.0
		if pct > 0.8:
			env = lerp(1.0, 0.0, (pct - 0.8) / 0.2)
		elif pct < 0.1:
			env = lerp(0.0, 1.0, pct / 0.1)
			
		val *= env * volume
		points[i] = Vector2(val, val)
		
	playback.push_back_frames(points)
	
	# Autodestrucción cuando termine el sonido
	await get_tree().create_timer(duration + 0.15).timeout
	player.queue_free()

func play_sword() -> void:
	# Latigazo descendente rápido de espada
	play_tone(800, 150, 0.1, "sine", 0.12)

func play_magic() -> void:
	# Tono ascendente rápido de magia
	play_tone(400, 900, 0.15, "sine", 0.06)

func play_hit() -> void:
	# Ruido blanco corto de golpe
	play_tone(150, 50, 0.08, "noise", 0.12)

func play_hurt() -> void:
	# Pitido descendente de daño
	play_tone(220, 60, 0.22, "square", 0.08)

func play_pickup() -> void:
	# Dos pitidos ascendentes clásicos de recolección
	play_tone(523.25, 783.99, 0.08, "square", 0.05)

func play_puzzle() -> void:
	# Arpegio de "puzle resuelto" de Zelda
	var notes = [783.99, 739.99, 622.25, 440.00, 415.30, 659.25, 783.99, 1046.50]
	for note in notes:
		play_tone(note, note, 0.1, "square", 0.05)
		await get_tree().create_timer(0.08).timeout

func play_fanfare() -> void:
	# Fanfarria clásica de cofre
	var notes = [523.25, 587.33, 659.25, 698.46]
	for i in range(len(notes)):
		var dur = 0.14 if i < 3 else 0.5
		play_tone(notes[i], notes[i], dur, "square", 0.05)
		await get_tree().create_timer(0.12).timeout

func play_fail() -> void:
	# Zumbido de error
	play_tone(100, 100, 0.25, "square", 0.1)
