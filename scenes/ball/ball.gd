class_name Ball extends Polygon2D

signal hit_score(side: int)
signal change_speed(speed: Vector2)

const VERTIX_WITH_HEIGHT: int = 2
const X_DIMENSION: int = 0
const Y_DIMENSION: int = 1
const LEFT_SIDE: int = 0
const RIGHT_SIDE: int = 1
const ENEMY_SPEED_BOOST: Vector2 = Vector2(400, 0)
const PLAYER_SPEED_BOOST: Vector2 = Vector2(0, 0)

@onready var timer: Timer = $Timer
@onready var line_2d: Line2D = $Line2D

@export var base_speed: float = 100.0
@export var speed: Vector2 = Vector2.ZERO
@export var acceleration: float = 25.0
@export var direction: Vector2 = Vector2(-1, 1)

var limit_up: float = 0.0
var limit_down: float = 0.0
var limit_left: float = 0.0
var limit_right: float = 0.0

var game_stopped: bool = false

func _ready():
	randomize()
	if randf() > 0.5:
		direction = Vector2(1, 1)
	speed = Vector2(base_speed,base_speed)
	timer.start()
	line_2d.points = polygon
	line_2d.default_color = Color.BLACK
	line_2d.width = 1

func setup(half_window_rect: Vector2, keep_y: bool = false, random_y: bool = false):
	var half_size: Vector2 = self.polygon[VERTIX_WITH_HEIGHT] / 2
	var y: float = 0.0
	if keep_y:
		y = self.position.y
	self.position = half_window_rect - half_size
	if keep_y:
		self.position.y = y
	
	limit_down = get_viewport_rect().size.y - polygon[VERTIX_WITH_HEIGHT].y
	limit_right = get_viewport_rect().size.x - polygon[VERTIX_WITH_HEIGHT].x
	if random_y:
		self.position.y = randi_range(limit_up, limit_down)

func change_direction(dimension: int):
	if dimension == X_DIMENSION:
		direction.x *= -1
	elif dimension == Y_DIMENSION:
		direction.y *= -1

func get_speed_bonus():
	if direction.x == -1:
		return ENEMY_SPEED_BOOST
	return PLAYER_SPEED_BOOST

func accelerate():
	speed += Vector2(acceleration, acceleration)
	speed = clamp(speed, Vector2.ZERO, Vector2(1000, 1000))
	change_speed.emit(speed)

func _physics_process(delta: float) -> void:
	if not game_stopped:
		position += (speed + get_speed_bonus()) * direction * delta
		if position.y < limit_up or position.y > limit_down:
			position = clamp(position, Vector2.ZERO, get_viewport_rect().size - polygon[VERTIX_WITH_HEIGHT])
			change_direction(Y_DIMENSION)
		if position.x < limit_left:
			hit_score.emit(LEFT_SIDE)
			setup(get_viewport_rect().size / 2, true)
		if position.x > limit_right:
			hit_score.emit(RIGHT_SIDE)
			setup(get_viewport_rect().size / 2, true)

func _on_area_2d_area_entered(area: Area2D) -> void:
	var bar: Bar = area.get_parent()
	if (bar.can_hit_from_right and direction.x == -1) or (bar.can_hit_from_left and direction.x == 1):
		bar._on_ball_hit()
		change_direction(X_DIMENSION)
	else:
		bar._on_ball_phase_through()

func _on_area_2d_area_exited(area: Area2D) -> void:
	pass

func _on_timer_timeout() -> void:
	accelerate()
