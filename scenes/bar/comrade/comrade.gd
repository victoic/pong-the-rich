class_name Comrade extends Bar

const FOLLOW_BALL: int = 0
const MOVE_TO_X: int = 1

@onready var timer: Timer = $Timer
@onready var status_timer: Timer = $StatusTimer
@onready var collision_shape: CollisionShape2D = $Area2D/CollisionShape2D

var origin_pos: Vector2 = Vector2(0, 0):
	set(value):
		origin_pos = value
		position = value
var action: int = 0
var destination: int = 0

func setup(window_size: Vector2):
	var MIN_X_POS: int = 30
	position.y = randi_range(0, window_size.y - stats.height)
	position.x = randi_range(MIN_X_POS, (window_size/2).x) + stats.width
	origin_pos = position
	stats.limit_down = get_viewport_rect().size.y
	timer.start()
	add_to_group('comrade')
	super.setup(window_size)

func _on_ball_hit() -> void:
	$AnimationPlayer.play('animations/hit')

func _on_ball_phase_through() -> void:
	$AnimationPlayer.play('animations/phase_out')

func _process(delta: float) -> void:
	if not is_game_over:
		var cur_pos_y: float = (position.y + stats.height / 2)
		var dest: float = destination
		for ball in get_tree().get_nodes_in_group("ball"):
			if action == FOLLOW_BALL:
				dest = ball.position.y
		if abs(dest - cur_pos_y) > stats.speed * delta:
			if dest > cur_pos_y:
				self.position.y += stats.speed * delta
			elif dest < cur_pos_y:
				self.position.y -= stats.speed * delta
		self.position.y = clamp(self.position.y, stats.limit_up, stats.limit_down - stats.height)

func _on_timer_timeout() -> void:
	if randf() >= 0.85:
		action = FOLLOW_BALL
	else:
		action = MOVE_TO_X
		destination = randi_range(stats.limit_up, stats.limit_down)
	timer.start()

func _on_status_timer_timeout() -> void:
	can_hit_from_left = true
	can_hit_from_right = true
	modulate = Color.WHITE
	visible = true
	collision_shape.disabled = false
