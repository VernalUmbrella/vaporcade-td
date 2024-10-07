class_name TowerButton
extends TextureButton

@export var tower_stats: TowerStats

func _ready() -> void:
	assert(tower_stats.texture)
	texture_normal = tower_stats.texture

func _pressed() -> void:
	Events.tower_selected.emit(tower_stats)
