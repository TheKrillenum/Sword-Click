class_name dashState extends State

@export var idle: State
var next_target_buffer: Interactible
var buffer_count: int = 0
var active_buffer: bool = false
const NEXT_TARGET_BUFFER_DURATION: int = 16

func enter_state()-> void:
	if(!GlobalDataCollection.debug_mode):
		player.TEMP_SWORD.dash_attack_begin(player.current_target.position)


func exit_state()-> void:
	player.velocity = Vector2(0,0)


func update_physics(_delta: float)-> void:
	
	if(GlobalDataCollection.debug_mode):
		player.velocity = player.position.direction_to(player.debug_mode_target) * player.SPEED
		if(player.position.distance_squared_to(player.debug_mode_target) < 1000):
			switch_state.emit(idle)
		return
	
	if(player.current_target):
	
		player.velocity = player.position.direction_to(player.current_target.position) * player.SPEED
		
		if(player.position.distance_to(player.current_target.position) < (player.TEMP_SWORD.sword_range * 0.75)):
			player.TEMP_SWORD.dash_attack_complete(player.current_target.position)
			if(active_buffer):
				player.current_target = next_target_buffer
				active_buffer = false
				player.TEMP_SWORD.dash_attack_begin(player.current_target.position)
			else:
				switch_state.emit(idle)


func update(_delta: float)-> void:
	
	player.sprite.play("Run")
	
	if(Input.is_action_just_pressed("LeftClick")):
		
		if(GlobalDataCollection.debug_mode):
			return
		
		buffer_next_target()


func buffer_next_target() -> void:
	
	if(PointAndClick.last_highlighted_enemy == null):
		return
	
	active_buffer = true
	buffer_count = 0
	next_target_buffer = PointAndClick.last_highlighted_enemy
