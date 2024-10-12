class_name TitleScreen
extends Control

@export var difficulties: Array[GameStats]

@onready var coin_button: Button = %CoinButton
@onready var start_button: Button = %StartButton
@onready var coin_label: CoinLabel = %CoinLabel
@onready var credits_panel: Panel = %CreditsPanel
@onready var coin_sound: AudioStreamPlayer = $CoinSound

var max_coins: int = 3

var coins: int = 0:
	set(value):
		assert(value <= max_coins)
		coins = value
		coin_label.text = "COINS {amount}{difficulty}".format({
			"amount": coins,
			"difficulty": ["", " (HARD)", " (MEDIUM)", " (EASY)"][coins],
		})
		start_button.disabled = (coins == 0)
		if coins >= max_coins:
			coin_button.text = "RESET"

@export var next_scene: PackedScene

func _input(event: InputEvent) -> void:
	if not credits_panel.visible:
		return
	if event.is_action_pressed("ui_accept") or event.is_action_pressed("ui_cancel"):
		get_viewport().set_input_as_handled()
		credits_panel.visible = false

func _on_coin_button_pressed() -> void:
	coin_label.force_visible()
	if coins < max_coins:
		coins += 1
		coin_sound.play()
		return
	coin_button.text = "INSERT COIN"
	coins = 0

func _on_start_button_pressed() -> void:
	var main_scene = preload("res://main/main.tscn").instantiate()
	main_scene.game_stats = difficulties[coins]
	get_tree().root.add_child(main_scene)
	queue_free()

func _on_credits_button_pressed() -> void:
	credits_panel.visible = true
