class_name BaseEnemy extends Interactible

var is_in_hitstun: bool = false
var current_hitstun_frame: int = 0
@export var stats: EnemyStats
var circle_counter_clockwise: bool = true

func _ready() -> void:
	super()
	EnemyManager.all_interactibles.append(self)
	stats.parent_enemy = self
	circling_direction()


func circling_direction()->void:
	var random_number: float = randf()
	if(random_number >= 0.5):
		circle_counter_clockwise = true
	else:
		circle_counter_clockwise = false


func move_toward_distance_from_player(distance_from_player: float) -> void:
	if(position.distance_squared_to(Player.get_player().position) > distance_from_player + 300):
		# Move toward player
		velocity += (Player.get_player().position - position).normalized() * stats.speed
	elif(position.distance_squared_to(Player.get_player().position) < distance_from_player - 300):
		# If enemy is on the edge of being out of bound, return
		if(position.x >= (GlobalDataCollection.screen_size.x - 10) || position.x <= 10):
			return
		if(position.y >= (GlobalDataCollection.screen_size.y - 10) || position.y <= 10):
			return
		# Move away from player
		velocity += (position - Player.get_player().position).normalized() * stats.speed


func move_away_from_other_enemies() -> void:
	for enemy in EnemyManager.all_interactibles:
		if(enemy != self):
			if(position.distance_squared_to(enemy.position) < 400):
				velocity += (position - enemy.position).normalized() * stats.speed


func circle_around_position(position_to_circle: Vector2) -> void:
	var direction_to_target: Vector2 = (position_to_circle - global_position).normalized()
	var tangent: Vector2 = direction_to_target.orthogonal()
	
	# turn counterclockwise.
	if(!circle_counter_clockwise):
		tangent = -tangent
	
	velocity += tangent * stats.speed


func reset_velocity() -> void:
	velocity = Vector2.ZERO


func enemy_ai()->void:
	pass


func hit_stun() -> bool:
	if(!is_in_hitstun):
		return false
	reset_velocity()
	current_hitstun_frame += 1
	
	if(current_hitstun_frame > stats.hitstun_frame_duration):
		is_in_hitstun = false
		current_hitstun_frame = 0
		return false
	else:
		return true


func damaged()->void:
	animation_sprite.play("Hit")
	is_in_hitstun = true


func destroy()->void:
	EnemyManager.all_interactibles.erase(self)
	super()
