class_name TileCursor
extends Area2D

@onready var tower_ghost: TowerGhost = $TowerGhost

func _ready() -> void:
	Events.tower_selected.connect(_on_tower_selected)

func _on_tower_selected(tower_stats: TowerStats):
	if not tower_stats:
		tower_ghost.visible = false
		return
	tower_ghost.visible = true
	tower_ghost.tower_stats = tower_stats
