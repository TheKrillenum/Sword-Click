class_name stateMachine extends Node

var current_state: State
@export var starting_state: State

func _ready() -> void:
	for child_state: State in get_children():
		child_state.switch_state.connect(update_state)
	update_state(starting_state)


func update_state(new_state: State)->void:
	if(new_state == current_state):
		return
	
	if(current_state):
		current_state.exit_state()
	
	current_state = new_state
	
	if(current_state):
		current_state.enter_state()


func _process(delta: float) -> void:
	if(current_state):
		current_state.update(delta)


func _physics_process(delta: float) -> void:
	if(current_state):
		current_state.update_physics(delta)
