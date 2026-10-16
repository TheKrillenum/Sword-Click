class_name idleState extends State

@export var dash: State
@export var dodge: State

func enter_state()-> void:
	if(player.sprite):
		player.sprite.play("Idle")


func exit_state()-> void:
	pass


func custom_state_input(event: InputEvent) -> void:
	if event.is_action_pressed("LeftClick"):
		
		if(GlobalDataCollection.debug_mode):
			debug_mode_idle()
			return
		
		if(PointAndClick.last_highlighted_interactible == null):
			return
		
		enemy_selection()
	
	if(event.is_action_pressed("Dodge")):
		switch_state.emit(dodge)


func debug_mode_idle() -> void:
	player.debug_mode_target = PointAndClick.current_mouse_pos
	switch_state.emit(dash)


func enemy_selection() -> void:
	var selected_enemy: Interactible = PointAndClick.last_highlighted_interactible
	
	if(player.position.distance_to(selected_enemy.position) <= player.active_sword.stats.sword_range):
		player.active_sword.perform_combo_attack(selected_enemy.position)
	else:
		player.current_target = selected_enemy
		switch_state.emit(dash)
