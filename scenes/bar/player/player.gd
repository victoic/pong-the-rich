class_name Player extends Bar

@onready var organize_ability: OrganizeAbility = $OrganizeAbility
@onready var paper_tigers_ability: PaperTigersAbility = $PaperTigersAbility

func setup(window_size: Vector2) -> void:
	position.y = (window_size / 2).y - polygon[stats.VERTIX_WITH_HEIGHT].y / 2
	stats.limit_down = get_viewport_rect().size.y
	super.setup(window_size)

func _on_ball_hit() -> void:
	$AnimationPlayer.play('animations/hit')

func _on_ball_phase_through() -> void:
	$AnimationPlayer.play('animations/phase_out')

func _physics_process(delta):
	if not is_game_over:
		if Input.is_action_pressed("move_up"):
			self.position.y -= stats.speed * delta
			self.position.y = clamp(self.position.y, stats.limit_up, stats.limit_down - self.polygon[stats.VERTIX_WITH_HEIGHT].y)
		elif Input.is_action_pressed("move_down"):
			self.position.y += stats.speed * delta
			self.position.y = clamp(self.position.y, stats.limit_up, stats.limit_down - self.polygon[stats.VERTIX_WITH_HEIGHT].y)
