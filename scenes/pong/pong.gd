class_name Pong extends Node2D

@onready var divider: Polygon2D = $Divider
@onready var player: Player = $Player
@onready var enemy: Enemy = $Enemy
@onready var ball: Ball = $Ball

@onready var point_timer: Timer = $Timer
@onready var phrase: Label = $Phrase

@onready var comrades_points: Node2D = $ComradesPoints
@onready var comrades: Node2D = $Comrades

@onready var comrade_point_scene: PackedScene = load("res://scenes/comrade_point/comrade_point.tscn")
@onready var comrade_scene: PackedScene = load("res://scenes/bar/comrade/comrade.tscn")

@onready var timer: Timer = $Timer
@onready var ui_container: HSplitContainer = $GUI/HSplitContainer
@onready var player_label: Label = $GUI/HSplitContainer/ScrollContainer/Label
@onready var enemy_label: Label = $GUI/HSplitContainer/ScrollContainer2/Label
@onready var organize_button: Button = $GUI/CenterContainer/PanelContainer/ButtonGroup/CenterContainer/OrganizeAbility
@onready var paper_tigers_button: Button = $GUI/CenterContainer/PanelContainer/ButtonGroup/CenterContainer2/PaperTigersAbility

@onready var background_texture: TextureRect = $TextureRect
@onready var backgrounds: Dictionary[int, CompressedTexture2D] = {
	0: load("res://images/backgrounds/bg01.png"),
	20: load("res://images/backgrounds/bg02.png"),
	40: load("res://images/backgrounds/bg03.png"),
	50: load("res://images/backgrounds/bg04.png")
}
@onready var loss_background: CompressedTexture2D = load("res://images/backgrounds/bg05.png")

var organization_started: bool = false

var player_area: Vector2
var enemy_area: Vector2

const VERTIX_WITH_HEIGHT: int = 2
const LEFT_SIDE: int = 0
const RIGHT_SIDE: int = 1

func get_half_viewport() -> Vector2:
	return get_viewport_rect().size / 2

func start_with_debug() -> void:
	player.stats.score = 49
	enemy.stats.score = 49
	organize_button.disabled = false
	paper_tigers_button.disabled = false
	for i in range(10):
		_on_comrade_poit_create_comrade()

func _ready() -> void:
	var half_viewport: Vector2 = get_half_viewport()
	for i in range(VERTIX_WITH_HEIGHT, len(divider.polygon)):
		divider.polygon[i].y = get_viewport_rect().size.y
	var divider_half_size: Vector2 = divider.polygon[VERTIX_WITH_HEIGHT] / 2
	divider.position.x = half_viewport.x - divider_half_size.x
	ui_container.split_offsets[0] = half_viewport.x
	
	player_area = Vector2(0, half_viewport.x - 1)
	enemy_area = Vector2(half_viewport.x + 1, get_viewport_rect().size.x)
	
	enemy.setup(get_viewport_rect().size)
	enemy.infiltrate_ability.ability_used.connect(change_phrase)
	enemy.infiltrate_ability.ability_ended.connect(reset_phrase)
	enemy.individualism_ability.ability_used.connect(change_phrase)
	enemy.individualism_ability.ability_ended.connect(reset_phrase)
	
	player.setup(half_viewport)
	player.organize_ability.cooldown_timer.timeout.connect(_on_organize_ability_timer_timeout)
	player.organize_ability.ability_used.connect(change_phrase)
	player.organize_ability.ability_ended.connect(reset_phrase)
	organize_button.get_node("CooldownLabel").text = "{0}/{1}".format([player.stats.score, player.organize_ability.requirement])
	
	player.paper_tigers_ability.cooldown_timer.timeout.connect(_on_paper_tigers_ability_timer_timeout)
	player.paper_tigers_ability.ability_used.connect(change_phrase)
	player.paper_tigers_ability.ability_ended.connect(reset_phrase)
	paper_tigers_button.get_node("CooldownLabel").text = "{0}/{1}".format([player.stats.score, player.paper_tigers_ability.requirement])
	
	ball.setup(half_viewport)
	point_timer.start()
	$GUI.size = get_viewport_rect().size
	$GUI/CenterContainer.size.x = get_viewport_rect().size.x

func choose_coord() -> Vector2:
	divider.position.x
	var MIN_PADDING_Y: int = 10
	var x: float = randf_range(enemy_area.x, enemy_area.y - 2 * enemy.stats.width)
	var y: float = randf_range(0 + MIN_PADDING_Y, get_viewport_rect().size.y - MIN_PADDING_Y)
	return Vector2(x, y)

func spawn_comrade() -> void:
	var must_spawn: bool = false
	if enemy.score >= 5:
		if not organization_started:
			must_spawn = true
		elif randf() >= 0.9 and comrades_points.get_child_count() < 1:
			must_spawn = true
	if must_spawn:
		var pos: Vector2 = choose_coord()
		var new_point: ComradePoint = comrade_point_scene.instantiate()
		comrades_points.add_child(new_point)
		new_point.position = pos
		new_point.create_comrade.connect(_on_comrade_poit_create_comrade)
		organization_started = true
		must_spawn = false

func add_comrade(comrade: Comrade) -> void:
	comrades.add_child(comrade)
	comrade.setup(get_viewport_rect().size)

func change_phrase(value: String):
	phrase.text = value

func reset_phrase():
	if player.score < 50 and enemy.score < 50:
		phrase.text = ""

func _process(delta: float) -> void:
	spawn_comrade()
	if player.score >= 50 or enemy.score >= 50:
		if player.score >= 50:
			change_phrase("We won, comrade!\nA new future begins.\n{0}".format([int(timer.time_left)]))
		if enemy.score >= 50:
			change_phrase("They have everything to lose, we got nothing, we can't give up!\n{0}".format([int(timer.time_left)]))
			background_texture.texture = loss_background
		if Input.is_action_just_pressed("return"):
			get_tree().change_scene_to_file("res://scenes/pong/menu.tscn")
	if player.organize_ability.cooldown_timer.time_left > 0:
		var cooldown_time: int = int(player.organize_ability.cooldown_timer.time_left)
		organize_button.get_node("CooldownLabel").text = "{0}".format([cooldown_time])
	if player.paper_tigers_ability.cooldown_timer.time_left > 0:
		var cooldown_time: int = int(player.paper_tigers_ability.cooldown_timer.time_left)
		paper_tigers_button.get_node("CooldownLabel").text = "{0}".format([cooldown_time])

func _on_comrade_poit_create_comrade() -> void:
	var comrade: Comrade = comrade_scene.instantiate()
	call_deferred('add_comrade', comrade)

func _on_ball_hit_score(side: int) -> void:
	if side == RIGHT_SIDE:
		player.score+=1
		player_label.text = "{0}".format([player.score])
		
		if player.score == player.organize_ability.requirement:
			organize_button.disabled = false
			organize_button.get_node("CooldownLabel").text = ""
		elif player.score < player.organize_ability.requirement:
			organize_button.get_node("CooldownLabel").text = "{0}/{1}".format([player.score, player.organize_ability.requirement])
		
		if player.score == player.paper_tigers_ability.requirement:
			paper_tigers_button.disabled = false
			paper_tigers_button.get_node("CooldownLabel").text = ""
		elif player.score < player.paper_tigers_ability.requirement:
			paper_tigers_button.get_node("CooldownLabel").text = "{0}/{1}".format([player.score, player.paper_tigers_ability.requirement])
		
		for points in backgrounds:
			if points == player.score:
				background_texture.texture = backgrounds[points]
				break
	elif side == LEFT_SIDE:
		enemy.score+=1
		enemy_label.text = "{0}".format([enemy.score])
	if player.score >= 50 or enemy.score >= 50:
		ball.game_stopped = true
		enemy.is_game_over = true
		for comrade in get_tree().get_nodes_in_group("comrades"):
			comrade.is_game_over = true
		ball.setup(get_half_viewport())
		timer.stop()
		timer.timeout.connect(_on_endgame_timer_timeout)
		timer.start(10)
		$HelpLabel.visible = true
		Stats.save_config(player.score, enemy.score, player.score >= 50, comrades.get_child_count())
	point_timer.start()

func _on_endgame_timer_timeout() -> void:
	get_tree().change_scene_to_file("res://scenes/pong/menu.tscn")

func _on_ball_change_speed(speed: Vector2) -> void:
	$DebugLabel.text = "Velocidade: {0}".format([speed])

func _on_timer_timeout() -> void:
	print("Timeout: 20s without points.")
	ball.setup(get_half_viewport(), false, true)

func _on_organize_ability_pressed() -> void:
	player.organize_ability.use()
	organize_button.disabled = true
	organize_button.get_node("ShortcutLabel").theme_type_variation = "LabelDisabled"

func _on_organize_ability_timer_timeout() -> void:
	organize_button.disabled = false
	organize_button.get_node("ShortcutLabel").theme_type_variation = "Text"
	organize_button.get_node("CooldownLabel").text = ""

func _on_paper_tigers_ability_pressed() -> void:
	player.paper_tigers_ability.use()
	paper_tigers_button.disabled = true
	paper_tigers_button.get_node("ShortcutLabel").theme_type_variation = "LabelDisabled"

func _on_paper_tigers_ability_timer_timeout() -> void:
	paper_tigers_button.disabled = false
	paper_tigers_button.get_node("CooldownLabel").text = ""
	paper_tigers_button.get_node("ShortcutLabel").theme_type_variation = "Text"
