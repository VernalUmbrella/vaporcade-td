class_name Tower
extends Node2D

@export var tower_stats: TowerStats:
	set(value):
		tower_stats = value.duplicate()

@onready var sprite: AnimatedSprite2D = $Sprite
@onready var range_area: Area2D = $AttackRange
@onready var range_shape: CollisionShape2D = $AttackRange/CollisionShape2D
@onready var range_indicator: Panel = $RangeIndicator
@onready var tile_area: Area2D = $Tile

var tween: Tween
var show_range: bool = false
var range_fade_time: float = 0.2
var current_targets: Array[Enemy]

func _ready() -> void:
	if not tower_stats:
		return
	range_shape.shape = RectangleShape2D.new()
	tower_stats.changed.connect(_on_tower_stats_changed)
	_on_tower_stats_changed()

func locate_targets() -> Array[Enemy]:
	var candidates: Array[Enemy]
	for overlapper: Area2D in range_area.get_overlapping_areas():
		var area_owner: Enemy = overlapper.get_parent() #TODO: rework to avoid get_parent?
		candidates.append(area_owner)
	match tower_stats.targeting_mode:
		TowerStats.TargetingMode.FIRST:
			candidates.sort_custom(func(a: Enemy, b: Enemy) -> bool: return a.progress > b.progress)
		TowerStats.TargetingMode.STRONGEST:
			candidates.sort_custom(func(a: Enemy, b: Enemy) -> bool:
					return a.current_health > b.current_health or (a.current_health == b.current_health and a.progress > b.progress)
			)
	return candidates.slice(0, tower_stats.max_targets)

func _attack(_delta: float) -> void:
	assert(false, "Abstract `attack` function not overridden in Tower")

func _on_tower_stats_changed():
	sprite.sprite_frames = tower_stats.sprite_frames
	var range_size: Vector2 = Main.TILE_SIZE * (1+2*tower_stats.attack_range)
	range_shape.shape.set_size(range_size)
	range_indicator.size = range_size
	range_indicator.set_position(-range_size / 2)

func _on_tile_mouse_entered() -> void:
	if tween:
		tween.kill()
	tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(range_indicator, "modulate", Color.WHITE, range_fade_time)

func _on_tile_mouse_exited() -> void:
	if tween:
		tween.kill()
	tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(range_indicator, "modulate", Color.TRANSPARENT, range_fade_time)
