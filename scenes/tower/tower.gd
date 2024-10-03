class_name Tower
extends Node2D

@export var tower_stats: TowerStats # TODO: this assumes it will never change

@onready var sprite: Sprite2D = $Sprite
@onready var range_area: Area2D = $AttackRange
@onready var range_shape: CollisionShape2D = $AttackRange/CollisionShape2D

var current_targets: Array[Enemy]

func _ready() -> void:
	sprite.texture = tower_stats.texture
	range_shape.shape = RectangleShape2D.new()
	range_shape.shape.set_size(Main.TILE_SIZE * (1+2*tower_stats.attack_range))

func locate_targets() -> Array[Enemy]:
	var candidates: Array[Enemy]
	for overlapper: Area2D in range_area.get_overlapping_areas():
		var area_owner = overlapper.get_parent() #TODO: rework to avoid get_parent?
		if area_owner is not Enemy:
			continue
		if area_owner.is_in_group("enemies"):
			candidates.append(area_owner)
	candidates.sort_custom(func(a: Enemy, b: Enemy) -> bool: return a.progress > b.progress)
	return candidates.slice(0, tower_stats.max_targets)

func _attack(_delta: float) -> void:
	assert(false, "Abstract `attack` function not overridden in Tower")
