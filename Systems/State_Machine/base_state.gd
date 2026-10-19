class_name State extends Node

signal switch_state(new_state: State)

func _init() -> void:
	set_process(false)
	set_physics_process(false)


func enter_state()-> void:
	pass


func exit_state()-> void:
	pass


func update(_delta: float)-> void:
	pass


func update_physics(_delta: float)-> void:
	pass


func custom_state_input(event: InputEvent) -> void:
	pass
