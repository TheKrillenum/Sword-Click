class_name Sword extends Node2D

# VARIABLES -----------------------------------------------------------------------

var space_state

# Sword Data
var sword_range: int = 0
var damage: Array[int] = [10]
var cooldown: Array[float] = [0.1]
var combo_attack_counter: int = 0
var max_attack_combo:int = 0
var combo_attack_call: Array[String]

# Timer
@export var cooldown_timer: Timer
var on_cooldown: bool = false

# shape enum for damage collision
enum Shape {SEGMENT, CIRCLE, RECTANGLE, SLASH}

# Slash shape
var slash_shape_properties: PackedVector2Array = PackedVector2Array([Vector2(0.0, -50.0), Vector2(20.0, -40.0), Vector2(35.0, -25.0), Vector2(40.0, 0.0), Vector2(35.0, 25.0), Vector2(20.0, 40.0), Vector2(0.0, 50.0)])

# Physics query
var query = PhysicsShapeQueryParameters2D.new()

# FUNCTIONS ----------------------------------------------------------------------
func _ready() -> void:
	space_state = get_viewport().find_world_2d().direct_space_state
	query.collision_mask = 2
	query.collide_with_areas = false
	query.collide_with_bodies = true


func perform_combo_attack(targeted_location: Vector2)->void:
	
	if(combo_attack_call.get(combo_attack_counter) == null):
		printerr("Combo counter out of range")
		reset_combo()
		return
		
	Callable(self, combo_attack_call.get(combo_attack_counter)).call(targeted_location)
	cooldown_timer.wait_time = cooldown[combo_attack_counter]
	
	combo_attack_counter += 1
	if (combo_attack_counter > (max_attack_combo - 1)):
		reset_combo()


func dash_attack_complete(_targeted_location: Vector2)->void:
	pass


func dash_attack_begin(_targeted_location: Vector2)->void:
	reset_combo()


func dash_attack_interupted()->void:
	pass


func reset_combo()->void:
	combo_attack_counter = 0


func throw_weapon()->void:
	#TO DO LATER
	pass


func deal_damage(target: Interactible, damage_amount: float)->void:
	target.take_damage(damage_amount)


func _on_cooldown_timeout() -> void:
	on_cooldown = false


## [enum Shape] represent the 4 possible shapes: SEGMENT, CIRCLE, RECTANGLE and SLASH.[br]
## the _shape_properties needs to be specific types for some of the shapes:[br]
## SEGMENT - is a [Rect2] with the first point of the segment in rect.position and the second point of the segment in rect.size[br]
## CIRCLE - a [float] representing it's radius[br]
## RECTANGLE - a [Vector2] representing the rectangles width and heights as half_extents[br]
## SLASH - no need for any shape properties
func check_for_area(area_rotation: float, area_scale: Vector2, area_origin: Vector2, requested_shape: Shape, _shape_properties = 0) -> Array[Interactible]:
	
	var collision_shape
	
	match requested_shape:
		0: #Segment
			
			if(_shape_properties is Rect2):
				collision_shape = PhysicsServer2D.segment_shape_create()
				PhysicsServer2D.shape_set_data(collision_shape, _shape_properties)
			else:
				push_error("incorrect segment properties")
		1: #Circle
			if(_shape_properties is float):
				collision_shape = PhysicsServer2D.circle_shape_create()
				PhysicsServer2D.shape_set_data(collision_shape, _shape_properties)
			else:
				push_error("incorrect Circle properties")
		2: #Rectangle
			if(_shape_properties is Vector2):
				collision_shape = PhysicsServer2D.rectangle_shape_create()
				PhysicsServer2D.shape_set_data(collision_shape, _shape_properties)
			else:
				push_error("incorrect rectangle properties")
		3: #Slash
			collision_shape = PhysicsServer2D.convex_polygon_shape_create()
			PhysicsServer2D.shape_set_data(collision_shape, slash_shape_properties)
		_: #Default
			push_error("Shape was not requested properly!")
	
	query.shape_rid = collision_shape
	query.transform = Transform2D(area_rotation, area_scale, 0.0, area_origin)
	
	var output: Array[Interactible]
	
	for n in space_state.intersect_shape(query):
		if(n["collider"] as Interactible):
			output.append(n["collider"])
	
	PhysicsServer2D.free_rid(collision_shape)
	return output
