class_name GammaTower
extends Tower

@export var shot_duration: float = 0.3

var attack_timer: Timer
var shot: Line2D

func _ready() -> void:
	super._ready()
	attack_timer = Timer.new()
	attack_timer.wait_time = 1.0 / tower_stats.attacks_per_second
	attack_timer.one_shot = true
	add_child(attack_timer)
	shot = Line2D.new()
	shot.default_color = tower_stats.attack_color
	shot.width = 1
	shot.z_index = 5
	add_child(shot)
	sprite.play("default")

func _process(delta: float) -> void:
	if not attack_timer.is_stopped():
		return
	current_targets = locate_targets()
	_attack(delta)

func _attack(_delta: float) -> void:
	attack_timer.start()
	shot.clear_points()
	for t: Enemy in current_targets:
		shot.add_point(Vector2.ZERO)
		shot.add_point(t.global_position + Main.HALF_TILE_SIZE - global_position)
		t.current_health -= tower_stats.damage
		t.slowed_timer = 1.0
	var shot_tween := create_tween()
	shot_tween.tween_property(shot, "modulate", Color.TRANSPARENT, shot_duration).from(Color.WHITE)
