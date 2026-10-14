extends "res://Systems/State_Machine/base_state.gd"

# exports
@export var idle: State
@export var dash: State

# Dodge properties
var dodge_start_position: Vector2
var current_distance_traveled: float = 0.0
var dodge_direction: Vector2
var dodge_input_released: bool = false
var is_dodge_over: bool = false
var player_IFrame: bool
var dodge_speed: float
var dash_buffer: bool = false

# constant
const DODGE_MAX_SPEED: float = 400.0
const MAX_DODGE_LENGHT: float = 50


func enter_state()-> void:
	dodge_start_position = Player.get_player().global_position
	dodge_direction = (PointAndClick.current_mouse_pos - Player.get_player().position).normalized()
	current_distance_traveled = 0
	dodge_speed = DODGE_MAX_SPEED
	is_dodge_over = false
	dodge_input_released = false
	dash_buffer = false
	player_start_iFrame()


func exit_state()-> void:
	player.velocity = Vector2(0,0)


func custom_state_input(event: InputEvent) -> void:
	if(event.is_action_released("Dodge")):
		dodge_input_released = true
	
	if(event.is_action_pressed("LeftClick")):
			
		if(GlobalDataCollection.debug_mode):
			return
		dash_buffer = true
		dash.buffer_next_target()


func update_physics(_delta: float)-> void:
	if(!is_dodge_over):
		if((dodge_input_released and current_distance_traveled >= MAX_DODGE_LENGHT) or (current_distance_traveled >= (MAX_DODGE_LENGHT * 2.5))):
			is_dodge_over = true
			ease_out_dodge()
			
			#switch_state.emit(idle)
			#return
	
		if(player_IFrame and current_distance_traveled >= MAX_DODGE_LENGHT):
			player_end_iFrame()
		else:
			current_distance_traveled = Vector2(dodge_start_position - Player.get_player().global_position).length()
			
	dodge_movement()


func player_start_iFrame()->void:
	player_IFrame = true
	Player.get_player().invincible = true
	if(player.sprite):
		player.sprite.play("IFrame")


func player_end_iFrame()->void:
	player_IFrame = false
	Player.get_player().invincible = false
	if(player.sprite):
		player.sprite.play("Dodge")


func ease_out_dodge()->void:
	var ease_out_tween: Tween = create_tween()
	ease_out_tween.finished.connect(on_ease_out_end)
	ease_out_tween.set_ease(Tween.EASE_OUT)
	ease_out_tween.tween_property(self, "dodge_speed", 0.0, 0.1)


func on_ease_out_end()->void:
	if(dash_buffer):
		switch_state.emit(dash)
	else:
		switch_state.emit(idle)


func dodge_movement()->void:
	Player.get_player().velocity = dodge_direction * dodge_speed
