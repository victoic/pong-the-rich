class_name Bar extends Polygon2D

signal ability_end

@export var stats: Resource
@export var can_hit_from_left: bool = true
@export var can_hit_from_right: bool = true
@export var is_game_over: bool = false

var cur_scale: Vector2 = Vector2.ONE:
	set(value):
		cur_scale = value
		scale = value
@export var relative_scale: Vector2:
	set(value):
		relative_scale = value
		scale = cur_scale + relative_scale

var score: int:
	get():
		return stats.score
	set(value):
		stats.score = value

func setup(window_size: Vector2) -> void:
	var points: PackedVector2Array = PackedVector2Array([
		Vector2(0, 0),
		Vector2(0, stats.height),
		Vector2(stats.width, stats.height),
		Vector2(stats.width, 0)
	])
	self.polygon = points

func _on_tooltip_timer_timeout():
	ability_end.emit()

func _on_ball_hit():
	pass

func use_ability():
	pass
