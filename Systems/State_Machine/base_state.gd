class_name State extends Node

signal switch_state(new_state: State)
var player = Player.get_player()

func enter_state()-> void:
	pass


func exit_state()-> void:
	pass


func update(_delta: float)-> void:
	pass


func update_physics(_delta: float)-> void:
	pass
