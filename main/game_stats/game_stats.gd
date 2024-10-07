class_name GameStats
extends Resource

@export var money: int = 20:
	set(value):
		assert(value >= 0)
		if money == value:
			return
		money = value
		emit_changed()
@export var lives_left: int = 10:
	set(value):
		if value <= 0 and lives_left > 0:
			Events.game_lost.emit()
		if lives_left == value:
			return
		lives_left = value
		emit_changed()
@export var wave_sequence: Array[Wave]
@export var current_wave: int = 0:
	set(value):
		if current_wave == value:
			return
		current_wave = value
		emit_changed()

func clone() -> GameStats:
	var output := GameStats.new()
	output.money = money
	output.lives_left = lives_left
	output.wave_sequence = wave_sequence
	output.current_wave = current_wave
	return output
