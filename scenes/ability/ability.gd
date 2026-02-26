class_name Ability extends Node2D

signal ability_used(phrase: String)
signal ability_ended

@onready var tooltip_timer: Timer = $TooltipTimer

@export var is_cooldown: bool = false
@export var requirement: int = 20
@export var phrase: String = "Used this Ability!"

func use():
	ability_used.emit(phrase)
	tooltip_timer.start(3)

func is_ready(score: int):
	return score >= requirement

func _on_cooldown_timer_timeout() -> void:
	is_cooldown = false

func _on_tooltip_timer_timeout() -> void:
	ability_ended.emit() # Replace with function body.
