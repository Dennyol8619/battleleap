extends Node2D

signal  player_death(id:int)

var map
var level
var player_alive:int = 2
var game_ended:bool = false
var point_to_win:int

@onready var ui:CanvasLayer = $Menu
@onready var reset_timer:Timer = $RestartTimer
@onready var death_timer:Timer = $DeathTimer
@onready var player_label:Label = $WinScreen/PlayerLabel
@onready var round_label:Label = $WinScreen/RoundLabel
@onready var win_label:Label = $WinScreen/WinLabel
@onready var background:TextureRect = $WinScreen/TextureRect

var maps = [
	"res://Scenes/GrassLand/Map1.tscn",
	"res://Scenes/GrassLand/Map2.tscn",
	"res://Scenes/GrassLand/Map3.tscn",
	"res://Scenes/GrassLand/Map4.tscn",
	"res://Scenes/GrassLand/Map5.tscn",
	"res://Scenes/Cave/Map6.tscn",
	"res://Scenes/Cave/Map7.tscn",
	"res://Scenes/Test/Test.tscn"
	]

func _ready():
	set_meta("StartingMap", "res://Scenes/GrassLand/Map1.tscn")
	set_meta("LoopMap", false)
	set_meta("PlayerCount", 2)
	set_meta("Player3", false)
	set_meta("Player4", false)
	set_meta("PointsToWin", 1)

func reset_game():
	map.queue_free()
	ui.show()
	set_meta("Player1Score", 0)
	set_meta("Player2Score", 0)
	set_meta("Player3Score", 0)
	set_meta("Player4Score", 0)
	_on_player_count_item_selected(get_meta("PlayerCount") - 2)

func _on_level_select_item_selected(index):
	match index:
		0: set_meta("StartingMap", "res://Scenes/GrassLand/Map1.tscn")
		1: set_meta("StartingMap", "res://Scenes/GrassLand/Map2.tscn")
		2: set_meta("StartingMap", "res://Scenes/GrassLand/Map3.tscn")
		3: set_meta("StartingMap", "res://Scenes/GrassLand/Map4.tscn")
		4: set_meta("StartingMap", "res://Scenes/GrassLand/Map5.tscn")
		5: set_meta("StartingMap", "res://Scenes/Cave/Map6.tscn")
		6: set_meta("StartingMap", "res://Scenes/Cave/Map7.tscn")
		7: set_meta("StartingMap", "res://Scenes/Test/Test.tscn")

func _on_loop_map_toggled(toggled_on):
	set_meta("LoopMap", toggled_on)

func _on_player_count_item_selected(index):
	match index:
		0:
			set_meta("PlayerCount", 2)
			set_meta("Player1", true)
			set_meta("Player2", true)
			set_meta("Player3", false)
			set_meta("Player4", false)
		1:
			set_meta("PlayerCount", 3)
			set_meta("Player1", true)
			set_meta("Player2", true)
			set_meta("Player3", true)
			set_meta("Player4", false)
		2:
			set_meta("PlayerCount", 4)
			set_meta("Player1", true)
			set_meta("Player2", true)
			set_meta("Player3", true)
			set_meta("Player4", true)
	player_alive = get_meta("PlayerCount")

func _on_rounds_to_win_item_selected(index):
	match index:
		0: set_meta("PointsToWin", 1)
		1: set_meta("PointsToWin", 2)
		2: set_meta("PointsToWin", 3)
		3: set_meta("PointsToWin", 4)
		4: set_meta("PointsToWin", 5)
		5: set_meta("PointsToWin", 6)
		6: set_meta("PointsToWin", 7)
		7: set_meta("PointsToWin", 8)
		8: set_meta("PointsToWin", 9)
		9: set_meta("PointsToWin", 10)

func _on_start_pressed():
	ui.hide()
	level = get_meta("StartingMap")
	var scnene = load(level)
	map = scnene.instantiate()
	add_child(map)

func _on_player_death(id:int):
	set_meta("Player" + str(id), false)
	player_alive -= 1
	if player_alive == 1:
		death_timer.start(0.1)

func round_finished():
	player_label.visible = false
	win_label.visible = false
	round_label.visible = false
	background.visible = false
	map.queue_free()
	_on_player_count_item_selected(get_meta("PlayerCount") - 2)
	if !get_meta("LoopMap"):
		level = maps.pick_random()
	var scnene = load(level)
	map = scnene.instantiate()
	add_child(map)
	
	if game_ended:
		game_ended = false
		reset_game()

func add_score():
	if get_meta("Player1"):
		set_meta("Player1Score", get_meta("Player1Score") + 1)
		player_label.text = "Player 1 Won"
		round_label.text = "Round Ended"
		player_label.visible = true
		win_label.visible = true
		round_label.visible = true
		background.visible = true
	elif get_meta("Player2"):
		set_meta("Player2Score", get_meta("Player2Score") + 1)
		player_label.text = "Player 2 Won"
		round_label.text = "Round Ended"
		player_label.visible = true
		win_label.visible = true
		round_label.visible = true
		background.visible = true
	elif get_meta("Player3"):
		set_meta("Player3Score", get_meta("Player3Score") + 1)
		player_label.text = "Player 3 Won"
		round_label.text = "Round Ended"
		player_label.visible = true
		win_label.visible = true
		round_label.visible = true
		background.visible = true
	elif get_meta("Player4"):
		set_meta("Player4Score", get_meta("Player4Score") + 1)
		player_label.text = "Player 4 Won"
		round_label.text = "Round Ended"
		player_label.visible = true
		win_label.visible = true
		round_label.visible = true
		background.visible = true
	else:
		player_label.text = "No one Won"
		round_label.text = "Round Ended"
		player_label.visible = true
		win_label.visible = true
		round_label.visible = true
		background.visible = true
	win_label_text()
	if get_meta("Player1Score") == get_meta("PointsToWin"):
		player_label.text = "Player 1 Won"
		round_label.text = "Game Ended"
		player_label.visible = true
		win_label.visible = true
		round_label.visible = true
		background.visible = true
		game_ended = true
	if get_meta("Player2Score") == get_meta("PointsToWin"):
		player_label.text = "Player 2 Won"
		round_label.text = "Game Ended"
		player_label.visible = true
		win_label.visible = true
		round_label.visible = true
		background.visible = true
		game_ended = true
	if get_meta("Player3Score") == get_meta("PointsToWin"):
		player_label.text = "Player 3 Won"
		round_label.text = "Game Ended"
		player_label.visible = true
		win_label.visible = true
		round_label.visible = true
		background.visible = true
		game_ended = true
	if get_meta("Player4Score") == get_meta("PointsToWin"):
		player_label.text = "Player 4 Won"
		round_label.text = "Game Ended"
		player_label.visible = true
		win_label.visible = true
		round_label.visible = true
		background.visible = true
		game_ended = true

func _on_death_timer_timeout():
	death_timer.stop()
	add_score()
	if game_ended:
		reset_timer.start(4)
	else:
		reset_timer.start(2)

func _on_restart_timer_timeout():
	reset_timer.stop()
	round_finished()

func win_label_text():
	match get_meta("PlayerCount"):
		2:
			var player1text = "Player 1: " + str(get_meta("Player1Score")) + " Win"
			var player2text = "Player 2: " + str(get_meta("Player2Score")) + " Win"
			win_label.text = player1text + "\n" + player2text
		3:
			var player1text = "Player 1: " + str(get_meta("Player1Score")) + " Win"
			var player2text = "Player 2: " + str(get_meta("Player2Score")) + " Win"
			var player3text = "Player 3: " + str(get_meta("Player3Score")) + " Win"
			win_label.text = player1text + "\n" + player2text + "\n" + player3text
		4:
			var player1text = "Player 1: " + str(get_meta("Player1Score")) + " Win"
			var player2text = "Player 2: " + str(get_meta("Player2Score")) + " Win"
			var player3text = "Player 3: " + str(get_meta("Player3Score")) + " Win"
			var player4text = "Player 4: " + str(get_meta("Player4Score")) + " Win"
			win_label.text = player1text + "\n" + player2text + "\n" + player3text + "\n" + player4text
