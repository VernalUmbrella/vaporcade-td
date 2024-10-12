class_name TowerButton
extends TextureButton

@export var tower_stats: TowerStats

@onready var highlight: TextureRect = $Highlight

var active: bool = false:
	set(value):
		active = value
		button_pressed = active
		highlight.visible = active

func _ready() -> void:
	assert(tower_stats.texture)
	texture_normal = tower_stats.texture
	Events.tower_selected.connect(_on_tower_selected)

func _pressed() -> void:
	Events.tower_selected.emit(null if active else tower_stats)

func _on_tower_selected(which: TowerStats):
	active = (which == tower_stats)
