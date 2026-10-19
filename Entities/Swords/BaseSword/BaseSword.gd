class_name Sword extends Node2D

# VARIABLES -----------------------------------------------------------------------

# Animation
@export var attack_animation: AnimatedSprite2D
@export var sprite_animation: AnimatedSprite2D

# Sword Data
@export var stats: Sword_stats
var combo_attack_counter: int = 0

# Throw data
var throw_target_location: Vector2
var attached_to_player: bool = true
var on_the_ground: bool = false
@export var throw_collision: Area2D

# Timer
@export var cooldown_timer: Timer
var is_on_cooldown: bool = false
@export var windup_timer: Timer
var callable_damage_func: String = "null"

# shape enum for damage collision
enum Shape {SEGMENT, CIRCLE, RECTANGLE, SLASH}

# attack transform
var attack_rotation: float = 0.0
var attack_scale: Vector2 = Vector2.ONE
var attack_origin: Vector2 = Vector2.ZERO

# Slash shape
var slash_shape_properties: PackedVector2Array = PackedVector2Array([
	Vector2(0.0, -47.0), 
	Vector2(20.0, -47.0), 
	Vector2(38.0, -41.0), 
	Vector2(55.0, -23.0), 
	Vector2(60.0, -9.0), 
	Vector2(60.0, 9.0), 
	Vector2(55.0, 23.0), 
	Vector2(43.0, 38.0), 
	Vector2(20.0, 47.0), 
	Vector2(0.0, 47.0)])

# Physics query & space_state
var space_state: PhysicsDirectSpaceState2D
var query = PhysicsShapeQueryParameters2D.new()

# FUNCTIONS ----------------------------------------------------------------------

func _init() -> void:
	set_process(false)
	set_physics_process(false)


func _ready() -> void:
	space_state = get_viewport().find_world_2d().direct_space_state
	query.collision_mask = 2
	query.collide_with_areas = false
	query.collide_with_bodies = true
	
	attack_animation.visible = false


func _physics_process(delta: float) -> void:
	if(!attached_to_player and !on_the_ground):
		position = position.move_toward(throw_target_location, stats.throw_speed)
		if(position.is_equal_approx(throw_target_location)):
			set_physics_process(false)
			on_the_ground = true
			throw_collision.monitoring = false
			sword_power()


# DASH --------------------------------------------------------------------------------------------

func dash_attack_complete(_targeted_location: Vector2)->void:
	start_cooldown(stats.dash_cooldown)


func dash_attack_begin(_targeted_location: Vector2)->void:
	reset_combo()


func dash_attack_interupted()->void:
	pass

# THROW WEAPON -------------------------------------------------------------------------------------

func throw_weapon(target_location: Vector2)->void:
	self.reparent(get_tree().get_first_node_in_group("Sword_container"))
	attached_to_player = false
	throw_target_location = target_location
	throw_collision.monitoring = true
	set_physics_process(true)


func sword_power() -> void:
	pass


func pick_up_sword()->void:
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	if(body as BaseEnemy):
		deal_damage(body, stats.throw_damage)

# COMBO DAMAGE AND AREAS----------------------------------------------------------------------------

func perform_combo_attack(targeted_location: Vector2)->void:
	
	if(is_on_cooldown):
		print_debug("on cooldown !")
		return
	
	if(stats.combo_attack_call.get(combo_attack_counter) == null):
		printerr("Combo counter out of range")
		reset_combo()
		return
		
	Callable(self, stats.combo_attack_call.get(combo_attack_counter)).call(targeted_location)
	
	start_cooldown(stats.cooldown_time[combo_attack_counter])
	
	combo_attack_counter += 1
	if (combo_attack_counter > (stats.max_attack_combo - 1)):
		reset_combo()


func deal_damage(target: BaseEnemy, damage_amount: float)->void:
	target.damage_enemy(damage_amount)


## [enum Shape] represent the 4 possible shapes: SEGMENT, CIRCLE, RECTANGLE and SLASH.[br]
## the _shape_properties needs to be specific types for some of the shapes:[br]
## SEGMENT - is a float representing the segment's length[br]
## CIRCLE - a [float] representing it's radius[br]
## RECTANGLE - a [Vector2] representing the rectangles width and heights as half_extents[br]
## SLASH - no need for any shape properties
func check_for_area(area_rotation: float, area_scale: Vector2, area_origin: Vector2, requested_shape: Shape, _shape_properties = 0) -> Array[BaseEnemy]:
	
	var output: Array[BaseEnemy]
	var collision_shape
	
	match requested_shape:
		0: #Segment
			if(_shape_properties is float):
				collision_shape = PhysicsServer2D.segment_shape_create()
				var correct_segment_properties = Rect2(Vector2(0,0), Vector2(_shape_properties, 0))
				PhysicsServer2D.shape_set_data(collision_shape, correct_segment_properties)
			else:
				push_error("incorrect segment properties")
				return output
		1: #Circle
			if(_shape_properties is float):
				collision_shape = PhysicsServer2D.circle_shape_create()
				PhysicsServer2D.shape_set_data(collision_shape, _shape_properties)
			else:
				push_error("incorrect Circle properties")
				return output
		2: #Rectangle
			if(_shape_properties is Vector2):
				collision_shape = PhysicsServer2D.rectangle_shape_create()
				PhysicsServer2D.shape_set_data(collision_shape, _shape_properties)
			else:
				push_error("incorrect rectangle properties")
				return output
		3: #Slash
			collision_shape = PhysicsServer2D.convex_polygon_shape_create()
			PhysicsServer2D.shape_set_data(collision_shape, slash_shape_properties)
		_: #Default
			push_error("Shape was not requested properly!")
			return output
	
	query.shape_rid = collision_shape
	query.transform = Transform2D(area_rotation, area_scale, 0.0, area_origin)
	
	for n in space_state.intersect_shape(query, 1000.0):
		if(n["collider"] as BaseEnemy):
			output.append(n["collider"])
	
	PhysicsServer2D.free_rid(collision_shape)
	return output

# TIMERS AND COOLDOWN ------------------------------------------------------------------------------

func start_cooldown(time: float):
	cooldown_timer.start(time)
	is_on_cooldown = true


func _on_windup_timer_timeout() -> void:
	if(callable_damage_func != "null"):
		Callable(self, callable_damage_func).call()
		callable_damage_func = "null"


func _on_cooldown_timeout() -> void:
	is_on_cooldown = false
	attack_rotation = 0.0
	attack_scale = Vector2.ONE
	attack_origin = Vector2.ZERO

# MISC ---------------------------------------------------------------------------------------------

func _on_animated_sprite_2d_animation_finished() -> void:
	reset_animation()


func reset_combo()->void:
	combo_attack_counter = 0


func reset_animation() -> void:
	attack_animation.visible = false
	attack_animation.rotation = 0.0
	attack_animation.position = Vector2.ZERO


func sprite_visibility(new_visibility: bool)->void:
	sprite_animation.visible = new_visibility
