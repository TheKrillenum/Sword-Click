extends Node2D

var Player_scene: PackedScene  = preload("uid://wm2vmj0jvsd6")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var player_container = get_tree().get_first_node_in_group("Player_container")
	if(player_container.get_child_count() == 0 || !(player_container.get_child(0) as Player)):
		spawn_player()
	player_at_spawn_position()


func player_at_spawn_position() -> void:
	Player.get_player().global_position = global_position


func spawn_player() -> void:
	Player_scene.instantiate()
	get_tree().get_first_node_in_group("Player_container").add_child(Player.get_player())
