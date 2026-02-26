class_name InfiltrateAbility extends Ability

@onready var cooldown_timer: Timer = $CooldownTimer

func _ready():
	requirement = 20
	phrase = "Infiltration! {X} spies have infiltrated our movement!"

func use():
	if not is_cooldown:
		var comrades: Array[Node] = get_tree().get_nodes_in_group('comrade')
		if len(comrades) > 0:
			is_cooldown = true
			comrades.shuffle()
			var spies_num: int = randi_range(1, min(10, len(comrades)))
			print("Using Infiltrate Ability! {0} Spies!".format([spies_num]))
			for i in range(spies_num):
				var spy: Comrade = comrades[i]
				spy.can_hit_from_right = false
				spy.modulate.r = Color.PURPLE.r
				spy.modulate.g = Color.PURPLE.g
				spy.modulate.b = Color.PURPLE.b
				spy.status_timer.start(3)
			cooldown_timer.start(10)
			phrase = "Infiltration! {X} spies have infiltrated our movement!".replace("{X}", "{0}".format([spies_num]))
			super.use()

func _on_cooldown_timer_timeout() -> void:
	cooldown_timer.stop()
	super._on_cooldown_timer_timeout()

func _on_tooltip_timer_timeout() -> void:
	super._on_tooltip_timer_timeout()
