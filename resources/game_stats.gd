class_name GameStats
extends Resource

signal game_stats_changed()

@export var money: int = 20:
	set(value):
		assert(value >= 0)
		money = value
		game_stats_changed.emit()
@export var lives_left: int = 10:
	set(value):
		lives_left = value # TODO: check if dead
		game_stats_changed.emit()
