class_name CoinLabel
extends Label

@onready var timer: Timer = $Timer

func force_visible() -> void:
	show()
	timer.start()

func _on_timer_timeout() -> void:
	visible = not visible
