extends Node

var file_path: String = "user://stats.cfg"

var config: ConfigFile = ConfigFile.new()
var config_err: Error
const pw: String = 'e2706c950d2143932629b17c97cae046fde49f0bdfdef9f7b921fcd34b6f5988'
var total_points_player: int = 0
var total_points_enemy: int = 0
var total_wins: int = 0
var total_losses: int = 0
var best_score: Vector2i = Vector2i.ZERO
var total_comrades: int = 0
var max_comrades: int = 0

func _ready() -> void:
	if FileAccess.file_exists(file_path):
		load_config()
	else:
		set_config()

func get_value(section, key) -> Variant:
	if config_err == OK:
		return config.get_value(section, key)
	return 0

func set_config(tps: int = 0, tes: int = 0, tw: int = 0, tl: int = 0, bs: Vector2i = Vector2i.ZERO, tc: int = 0, mc: int = 0) -> void:
	if config_err == OK:
		config.set_value('stats', 'total_points_player', tps)
		config.set_value('stats', 'total_points_enemy', tes)
		config.set_value('stats', 'total_wins', tw)
		config.set_value('stats', 'total_losses', tl)
		config.set_value('stats', 'best_score', bs)
		config.set_value('stats', 'total_comrades', tc)
		config.set_value('stats', 'max_comrades', mc)

func save_config(player_score: int, enemy_score: int, is_win: bool, comrades: int) -> void:
	if config_err == OK:
		var score: Vector2i = Vector2i(player_score, enemy_score)
		total_points_player += player_score
		total_points_enemy += enemy_score
		total_wins += 1 if is_win else 0
		total_losses += 1 if not is_win else 0
		if best_score == Vector2i.ZERO:
			best_score = score
		else:
			best_score = score if score.x - score.y > best_score.x - best_score.y else best_score
		total_comrades += comrades
		max_comrades = comrades if comrades > max_comrades else max_comrades
		set_config(total_points_player, total_points_enemy, total_wins, total_losses, best_score, total_comrades, max_comrades)
		config.save_encrypted_pass(file_path, pw)

func load_config():
	config_err = config.load_encrypted_pass(file_path, pw)
	if config_err == OK:
		total_points_player = get_value('stats', 'total_points_player')
		total_points_enemy = get_value('stats', 'total_points_enemy')
		total_wins = get_value('stats', 'total_wins')
		total_losses = get_value('stats', 'total_losses')
		best_score = get_value('stats', 'best_score')
		total_comrades = get_value('stats', 'total_comrades')
		max_comrades = get_value('stats', 'max_comrades')
