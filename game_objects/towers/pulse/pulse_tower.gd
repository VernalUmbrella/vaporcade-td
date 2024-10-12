class_name PulseTower
extends Tower

@export var max_opacity: float = 0.6
@export var flash_duration: float = 0.5

var attack_timer: Timer
var pulse_visual: ColorRect

func _ready() -> void:
	super._ready()
	attack_timer = Timer.new()
	attack_timer.wait_time = 1.0 / tower_stats.attacks_per_second
	attack_timer.one_shot = true
	add_child(attack_timer)
	pulse_visual = ColorRect.new()
	pulse_visual.color = tower_stats.attack_color
	pulse_visual.size = range_shape.shape.get_rect().size
	pulse_visual.position = -(pulse_visual.size / 2)
	pulse_visual.modulate = Color.TRANSPARENT
	pulse_visual.z_index = 5
	pulse_visual.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(pulse_visual)
	sprite.play("default")

func _process(delta: float) -> void:
	if not attack_timer.is_stopped():
		return
	current_targets = locate_targets()
	_attack(delta)

func locate_targets() -> Array[Enemy]:
	# Overrides the base method; doesn't sort targets
	var candidates: Array[Enemy]
	for overlapper: Area2D in range_area.get_overlapping_areas():
		var area_owner: Enemy = overlapper.get_parent()
		candidates.append(area_owner)
	return candidates

func _attack(_delta: float) -> void:
	if not current_targets:
		return
	var pulse_tween := create_tween()
	pulse_tween.tween_property(pulse_visual, "modulate", Color.TRANSPARENT, flash_duration).from(Color(Color.WHITE, max_opacity))
	attack_timer.start()
	for t: Enemy in current_targets:
		t.current_health -= tower_stats.damage
