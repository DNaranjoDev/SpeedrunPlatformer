extends Node2D

@onready var deathzone: Area2D = $Deathzone
@onready var start_position: StaticBody2D = $StartZone
@onready var exit: Area2D = $Exit
@onready var hud: Control = $UI/HUD
@onready var ui: CanvasLayer = $UI

@export var next_level: PackedScene = null
@export var is_final_level: bool = false
@export var level_time = 60

var player = null

var timer_node = null
var time_left
var win = false

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	if player != null:
		player.global_position = start_position.get_spawn_pos()
	var traps = get_tree().get_nodes_in_group("traps")
	for trap in traps:
		trap.touched_player.connect(_on_trap_touched_player)
	exit.body_entered.connect(_on_exit_body_entered)
	deathzone.body_entered.connect(_on_deathzone_body_entered)
	# Declare the time of each level
	time_left = level_time
	hud.set_time_label(time_left)
	# Creating Timer node
	timer_node = Timer.new()
	timer_node.name = "Level Timer"
	timer_node.wait_time = 1
	timer_node.timeout.connect(_on_lever_timer_timeout)
	add_child(timer_node)
	timer_node.start()

# Function to make a countdown of the timer that we created before
func _on_lever_timer_timeout():
	if win == false:
		time_left -= 1
		hud.set_time_label(time_left)
		if time_left < 0:
			reset_player()
			time_left = level_time
			hud.set_time_label(time_left)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("quit"):
		get_tree().change_scene_to_file("res://scenes/levels/start_menu.tscn")
	elif Input.is_action_just_pressed("reset"):
		get_tree().reload_current_scene()

func _on_deathzone_body_entered(_body: Node2D) -> void:
	AudioPlayer.play_sfx("hurt")
	reset_player()


func _on_trap_touched_player() -> void:
	AudioPlayer.play_sfx("hurt")
	reset_player()

func reset_player():
	player.velocity = Vector2.ZERO
	player.global_position = start_position.get_spawn_pos()

func _on_exit_body_entered(body):
	if body is Player:
		if is_final_level || next_level != null:
			exit.animate()
			player.active = false
			win = true
			await get_tree().create_timer(1.5).timeout
			if is_final_level:
				ui.show_win_screen(true)
			else:
				get_tree().change_scene_to_packed(next_level)
