class_name IndividualismAbility extends Ability

@onready var cooldown_timer: Timer = $CooldownTimer

func _ready():
	phrase = "Individualism prevents us from real freedom!"

func use():
	print("Using Individualism Ability!")
	if not is_cooldown:
		is_cooldown = true
		for comrade: Comrade in get_tree().get_nodes_in_group("comrade"):
			comrade.visible = false
			comrade.collision_shape.disabled = true
			comrade.status_timer.start(1)
		cooldown_timer.start()
		super.use()

func _on_cooldown_timer_timeout() -> void:
	cooldown_timer.stop()
	super._on_cooldown_timer_timeout()

func _on_tooltip_timer_timeout() -> void:
	super._on_tooltip_timer_timeout()
