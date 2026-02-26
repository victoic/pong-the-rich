class_name PaperTigersAbility extends Ability

@onready var cooldown_timer: Timer = $CooldownTimer

func _ready():
	requirement = 30
	phrase = "They are Paper Tigers!"

func use():
	if not is_cooldown:
		var enemies: Array[Node] = get_tree().get_nodes_in_group('enemy')
		if len(enemies) > 0:
			is_cooldown = true
			for i in range(len(enemies)):
				var enemy: Enemy = enemies[i]
				enemy.cur_scale = Vector2(1, 0.5)
				enemy.status_timer.start(3)
			cooldown_timer.start(10)
			super.use()

func _on_cooldown_timer_timeout() -> void:
	cooldown_timer.stop()
	super._on_cooldown_timer_timeout()

func _on_tooltip_timer_timeout() -> void:
	super._on_tooltip_timer_timeout()
