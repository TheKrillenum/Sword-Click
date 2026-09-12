class_name idleState extends State

@export var dash: State

func enter_state()-> void:
	pass


func exit_state()-> void:
	pass


func update_physics(_delta: float)-> void:
	pass


func update(_delta: float)-> void:
	if(player.sprite):
		player.sprite.play("Idle")
		
	if(Input.is_action_just_pressed("LeftClick")):
		
		if(GlobalDataCollection.debug_mode):
			player.debug_mode_target = PointAndClick.current_mouse_pos
			switch_state.emit(dash)
			return
		
		if(PointAndClick.last_highlighted_enemy == null):
			return
	
		var selected_enemy: Interactible = PointAndClick.last_highlighted_enemy
	
		if(player.position.distance_to(selected_enemy.position) <= player.TEMP_SWORD.sword_range):
			player.TEMP_SWORD.perform_combo_attack(selected_enemy.position)
		else:
			player.current_target = selected_enemy
			switch_state.emit(dash)
