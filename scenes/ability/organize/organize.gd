class_name OrganizeAbility extends Ability

@onready var cooldown_timer: Timer = $CooldownTimer

func _ready():
	requirement = 10
	phrase = "Comrades, Organize!"

func use():
	if not is_cooldown:
		var comrades: Array[Node] = get_tree().get_nodes_in_group('comrade')
		if len(comrades) > 0:
			is_cooldown = true
			print("Using Organize Ability!")
			for i in range(len(comrades)):
				var comrade: Comrade = comrades[i]
				comrade.can_hit_from_left = false
				comrade.modulate.r = Color.RED.r
				comrade.modulate.g = Color.RED.g
				comrade.modulate.b = Color.RED.b
				comrade.status_timer.start(3)
		cooldown_timer.start(10)

func _on_cooldown_timer_timeout() -> void:
	cooldown_timer.stop()
	super._on_cooldown_timer_timeout()

func _on_tooltip_timer_timeout() -> void:
	super._on_tooltip_timer_timeout()
