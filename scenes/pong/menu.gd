extends Control

@onready var star_texture: TextureRect = $StarTextureRect
@onready var stats_panel: StatsPanel = $StatsPanel

func _ready() -> void:
	if Stats.get_value('stats', 'total_wins') > 0:
		star_texture.visible = true

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("enter"):
		_on_new_game_button_pressed()
	elif Input.is_action_just_pressed("return"):
		_on_exit_button_pressed()

func _on_new_game_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/pong/cutscene.tscn")

func _on_exit_button_pressed() -> void:
	get_tree().quit()

func _on_stats_button_pressed() -> void:
	stats_panel.visible = true
	stats_panel.mouse_filter = Control.MOUSE_FILTER_STOP
	stats_panel.update_stats()
func _on_back_to_menu_button_pressed() -> void:
	stats_panel.visible = false
	stats_panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
