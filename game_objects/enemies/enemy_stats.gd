class_name EnemyStats
extends Resource

@export_group("Visuals")
@export var sprite_frames: SpriteFrames
@export var name: String
@export_group("Attributes")
@export var max_health: float
@export var speed: float
@export var loot: int

func clone() -> EnemyStats:
	var output := EnemyStats.new()
	output.sprite_frames = sprite_frames
	output.name = name
	output.max_health = max_health
	output.speed = speed
	output.loot = loot
	return output
