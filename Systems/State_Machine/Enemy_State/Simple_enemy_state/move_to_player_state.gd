extends base_enemy_movement_state

func enter_state()-> void:
	state_owner.animation_sprite.play("Run")


func update_physics(_delta: float)-> void:
	move_toward_distance_from_player(0.0)
	move_away_from_other_enemies()
	state_owner.move_and_slide()
	reset_velocity()
