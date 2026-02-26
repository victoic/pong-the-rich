class_name Enemy extends Bar

const VERTIX_WITH_HEIGHT: int = 2

@onready var infiltrate_ability: InfiltrateAbility = $InfiltrateAbility
@onready var individualism_ability: IndividualismAbility = $IndividualismAbility

@onready var status_timer: Timer = $StatusTimer

func setup(window_size: Vector2) -> void:
	position.y = (window_size / 2).y - stats.height / 2
	position.x = window_size.x - stats.width - 10
	stats.limit_down = get_viewport_rect().size.y
	super.setup(window_size)

func is_ability_ready(ability: Ability) -> bool:
	return not ability.is_cooldown and ability.is_ready(stats.score)

func move(delta: float) -> void:
	for ball in get_tree().get_nodes_in_group("ball"):
		var cur_pos_y: float = (position.y + polygon[VERTIX_WITH_HEIGHT].y / 2)
		if abs(ball.position.y - cur_pos_y) > stats.speed * delta:
			if ball.position.y > cur_pos_y:
				self.position.y += stats.speed * delta
			elif ball.position.y < cur_pos_y:
				self.position.y -= stats.speed * delta
	self.position.y = clamp(self.position.y, stats.limit_up, stats.limit_down - stats.height)

func _on_ball_hit() -> void:
	$AnimationPlayer.play('animations/hit-enemy')

func _on_ball_phase_through() -> void:
	$AnimationPlayer.play('animations/phase_out')

func _process(delta: float) -> void:
	if not is_game_over:
		var action_dice: float = randf()
		if is_ability_ready(individualism_ability) and action_dice < 0.05:
			individualism_ability.use()
		elif is_ability_ready(infiltrate_ability) and action_dice < 0.15:
			infiltrate_ability.use()
		else:
			move(delta)

func _on_status_timer_timeout() -> void:
	cur_scale = Vector2.ONE
