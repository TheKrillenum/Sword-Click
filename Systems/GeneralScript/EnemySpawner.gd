extends Timer

var basic_enemy: Resource = preload("res://Entities/Enemies/BaseEnemy/base_enemy.tscn")
var shooting_enemy: Resource = preload("res://Entities/Enemies/BaseEnemy/base_enemy.tscn")
var xd: bool = false

# spawn properties
var amount_to_spawn: int = 1
#ADD HERE TYPE OF ENEMY TO SPAWN (AS AN ARRAY MAYBE, WITH ENUM OF EACH ENEMY TO SPAWN)

# check query
var query = PhysicsShapeQueryParameters2D.new()
var space_state: PhysicsDirectSpaceState2D

func _ready() -> void:
	space_state = get_viewport().find_world_2d().direct_space_state
	var area_check_shape = PhysicsServer2D.circle_shape_create()
	PhysicsServer2D.shape_set_data(area_check_shape, 100.0)
	query.shape_rid = area_check_shape
	query.transform = Transform2D(Vector2.RIGHT, Vector2.DOWN, Vector2.ZERO)


func spawn_enemies()->void:
	for n in amount_to_spawn:
		var new_enemy: BaseEnemy = create_basic_enemy()
		var spawn_position: Vector2 = get_spawn_position()
		new_enemy.global_position = spawn_position


func create_basic_enemy() -> BaseEnemy:
	if(basic_enemy.can_instantiate()):
		var new_enemy: BaseEnemy = basic_enemy.instantiate()
		
		if(new_enemy != null):
			get_tree().get_first_node_in_group("Enemy_container").add_child(new_enemy)
		return new_enemy
	else:
		push_error("Canno't instantiate a new enemy")
		return null


func create_shooter_enemy() -> BaseEnemy:
	if(shooting_enemy.can_instantiate()):
		var new_enemy: BaseEnemy = shooting_enemy.instantiate()
		
		if(new_enemy != null):
			get_tree().get_first_node_in_group("Enemy_container").add_child(new_enemy)
		return new_enemy
	else:
		push_error("Canno't instantiate a new enemy")
		return null


func get_spawn_position() -> Vector2:
	var output_position: Vector2
	var invalid_spawn_position: bool = true
	while(invalid_spawn_position):
		output_position.x = randf_range(0.0, GlobalDataCollection.screen_size.x)
		output_position.y = randf_range(0.0, GlobalDataCollection.screen_size.y)
		query.transform = Transform2D(Vector2.RIGHT, Vector2.DOWN, Vector2(output_position.x, output_position.y))
		invalid_spawn_position = !space_state.intersect_shape(query).is_empty()
	return output_position


func set_spawn_properties() -> void:
	if(InteractibleManager.all_enemies.size() < 10):
		amount_to_spawn = 2
	elif(InteractibleManager.all_enemies.size() > 50):
		amount_to_spawn = 0
	else:
		amount_to_spawn = 1
	#Which enemy


func _on_timeout() -> void:
	set_spawn_properties()
	spawn_enemies()
	if(xd):
		safsgdgn()
		xd = false
	else:
		xd = true


func safsgdgn() -> void:
		var new_enemy: BaseEnemy = create_shooter_enemy()
		var spawn_position: Vector2 = get_spawn_position()
		new_enemy.global_position = spawn_position
