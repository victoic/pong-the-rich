class_name Cutscene extends Control

@onready var texture_rect: TextureRect = $TextureRect

@export var cur_scene: int = 0
@export var scene_list: Array[CompressedTexture2D] = [
	load("res://images/scenes/scene01.png"),
	load("res://images/scenes/scene02.png"),
	load("res://images/scenes/scene03.png")
]

func _ready() -> void:
	texture_rect.texture = scene_list[cur_scene]

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("enter"):
		cur_scene += 1
		if cur_scene < len(scene_list):
			texture_rect.texture = scene_list[cur_scene]
		else:
			get_tree().change_scene_to_file("res://scenes/pong/pong.tscn")
