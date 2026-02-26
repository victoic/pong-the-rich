class_name ComradePoint extends Node2D
signal create_comrade

func _draw() -> void:
	draw_circle(Vector2(0, 0), 10, Color.WHITE)

func _on_area_2d_area_entered(area: Area2D) -> void:
	print(area)
	create_comrade.emit()
	queue_free()
