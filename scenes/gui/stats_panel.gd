class_name StatsPanel extends Panel

@onready var total_wins: Label = $CenterContainer2/GridContainer/TotalWinsValue
@onready var total_losses: Label = $CenterContainer2/GridContainer/TotalLossesValue
@onready var total_player_points: Label = $CenterContainer2/GridContainer/TotalPlayerPointsValue
@onready var total_enemy_points: Label = $CenterContainer2/GridContainer/TotalEnemyPointsValue2
@onready var best_score: Label = $CenterContainer2/GridContainer/BestScoreValue
@onready var total_comrades: Label = $CenterContainer2/GridContainer/TotalComradesValue
@onready var max_comrades: Label = $CenterContainer2/GridContainer/MaxComradesValue

func update_stats() -> void:
	total_player_points.text = "{0}".format([Stats.get_value("stats", "total_points_player")])
	total_enemy_points.text = "{0}".format([Stats.get_value("stats", "total_points_enemy")])
	total_wins.text = "{0}".format([Stats.get_value("stats", "total_wins")])
	total_losses.text = "{0}".format([Stats.get_value("stats", "total_losses")])
	var bs: Vector2i = Stats.get_value("stats", "best_score")
	best_score.text = "{0} x {1}".format([bs.x, bs.y])
	total_comrades.text = "{0}".format([Stats.get_value("stats", "total_comrades")])
	max_comrades.text = "{0}".format([Stats.get_value("stats", "max_comrades")])
	
