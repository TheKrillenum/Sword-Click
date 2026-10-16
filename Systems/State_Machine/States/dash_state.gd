class_name dashState extends State

@export var idle: State
@export var dodge: State
var next_target_buffer: Interactible
var buffer_count: int = 0
var active_buffer: bool = false
const NEXT_TARGET_BUFFER_DURATION: int = 16


func enter_state()-> void:
	if(!GlobalDataCollection.debug_mode):
		
		if(player.current_target == null and next_target_buffer != null):
			player.current_target = next_target_buffer
				
		player.active_sword.dash_attack_begin(player.current_target.position)
	
	if(player.sprite):
		player.sprite.play("Run")


func exit_state()-> void:
	player.velocity = Vector2(0,0)
	active_buffer = false
	player.current_target = null

# -----------------------------------------------------------

func custom_state_input(event: InputEvent) -> void:
	if(event.is_action_pressed("LeftClick")):
			
		if(GlobalDataCollection.debug_mode):
			return
		
		# option 1: commited dash ---
		buffer_next_target()
		
		# option 2: forgiving dash ---
		#TEMP_FORGIVING_DASH()
	
	if(event.is_action_pressed("Dodge")):
		switch_state.emit(dodge)


func update_physics(_delta: float)-> void:
	
	if(GlobalDataCollection.debug_mode):
		debug_mode_dash()
		return
	
	dash_logic()


func buffer_next_target() -> void:
	
	if(PointAndClick.last_highlighted_enemy == null):
		return
	
	active_buffer = true
	buffer_count = 0
	next_target_buffer = PointAndClick.last_highlighted_enemy


func debug_mode_dash()->void:
	player.velocity = player.position.direction_to(player.debug_mode_target) * player.SPEED
	if(player.position.distance_squared_to(player.debug_mode_target) < 1000):
		switch_state.emit(idle)


func dash_logic()-> void:	
	
	if(player.current_target == null):
		switch_state.emit(idle)
		return
	
	player.velocity = player.position.direction_to(player.current_target.position) * player.SPEED
	
	if(player.position.distance_to(player.current_target.position) < (player.active_sword.stats.sword_range * 0.75)):
		player.active_sword.dash_attack_complete(player.current_target.position)
		if(active_buffer and is_instance_valid(next_target_buffer)):
			player.current_target = next_target_buffer
			active_buffer = false
			player.active_sword.dash_attack_begin(player.current_target.position)
		else:
			switch_state.emit(idle)


func TEMP_FORGIVING_DASH() -> void:
	var selected_enemy: Interactible = PointAndClick.last_highlighted_enemy
	
	if(player.position.distance_to(selected_enemy.position) <= player.active_sword.stats.sword_range):
		player.active_sword.perform_combo_attack(selected_enemy.position)
	else:
		player.current_target = selected_enemy
