class_name BasicEnemy extends BaseEnemy

func enemy_ai()->void:
	
	if(hit_stun()):
		return
		
	move_toward_distance_from_player(0.0)
	move_away_from_other_enemies()
	move_and_slide()
	reset_velocity()
