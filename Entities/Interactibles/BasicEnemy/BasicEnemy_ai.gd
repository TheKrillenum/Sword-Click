class_name BasicEnemy extends Interactible

func _init() -> void:
	super()
	speed = 75.0
	health = 5.0
	armor = 0.0
	damage = 1.0


func enemy_ai()->void:
	if(hit_stun()):
		return
	move_toward_player(0.0)
	move_away_from_other_enemies()
	move_and_slide()
	reset_velocity()
