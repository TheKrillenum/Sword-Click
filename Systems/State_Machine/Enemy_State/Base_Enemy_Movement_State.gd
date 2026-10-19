class_name base_enemy_movement_state extends State

@export var state_owner: BaseEnemy
var circle_counter_clockwise: bool = true

func circling_direction()->void:
	var random_number: float = randf()
	if(random_number >= 0.5):
		circle_counter_clockwise = true
	else:
		circle_counter_clockwise = false


func move_toward_distance_from_player(distance_from_player: float) -> void:
	if(state_owner.position.distance_squared_to(Player.get_player().position) > distance_from_player + 300):
		# Move toward player
		state_owner.velocity += (Player.get_player().position - state_owner.position).normalized() * state_owner.stats.speed
	elif(state_owner.position.distance_squared_to(Player.get_player().position) < distance_from_player - 300):
		# If enemy is on the edge of being out of bound, return
		if(state_owner.position.x >= (GlobalDataCollection.screen_size.x - 10) || state_owner.position.x <= 10):
			return
		if(state_owner.position.y >= (GlobalDataCollection.screen_size.y - 10) || state_owner.position.y <= 10):
			return
		# Move away from player
		state_owner.velocity += (state_owner.position - Player.get_player().position).normalized() * state_owner.stats.speed


func move_away_from_other_enemies() -> void:
	for enemy in InteractibleManager.all_enemies:
		if(enemy != self):
			if(state_owner.position.distance_squared_to(enemy.position) < 400):
				state_owner.velocity += (state_owner.position - enemy.position).normalized() * state_owner.stats.speed


func circle_around_position(position_to_circle: Vector2) -> void:
	var direction_to_target: Vector2 = (position_to_circle - state_owner.global_position).normalized()
	var tangent: Vector2 = direction_to_target.orthogonal()
	
	# turn counterclockwise.
	if(!circle_counter_clockwise):
		tangent = -tangent
	
	state_owner.velocity += tangent * state_owner.stats.speed


func reset_velocity() -> void:
	state_owner.velocity = Vector2.ZERO
