extends "res://Entities/Swords/BaseSword/BaseSword.gd"

var charge_start_location: Vector2
@export var damage_curve: Curve

# COMBO --------------------------------------------------------------------------------------------

func combo_attack_1(targeted_location: Vector2)->void:
	pass


func attack_1_damage()-> void:
	pass


func combo_attack_2(targeted_location: Vector2)->void:
	pass


func attack_2_damage()-> void:
	pass

# DASH ---------------------------------------------------------------------------------------------

func dash_attack_begin(_targeted_location: Vector2)->void:
	charge_start_location = global_position


func dash_attack_complete(_targeted_location: Vector2)->void:
	
	var charge_distance: float = charge_start_location.distance_squared_to(global_position)
	#print_debug("Charge distance = ", charge_distance)
	var charge_damage: float = damage_curve.sample(clampf(charge_distance, 0.0, 500000.0))
	#print_debug("Charge damage = ", charge_damage)
	#print_debug("-----------")
	
	attack_rotation = get_angle_to(_targeted_location)
	attack_scale = Vector2(1,1)
	attack_origin = global_position
	
	#attack_animation.rotate(attack_rotation)
	#attack_animation.visible = true
	#attack_animation.play("dash_anim")
	
	for enemy in check_for_area(attack_rotation, attack_scale, attack_origin, Shape.SEGMENT,100.0):
			deal_damage(enemy, charge_damage)
	super(_targeted_location)

# THROW --------------------------------------------------------------------------------------------

func throw_weapon(target_location: Vector2)->void:
	pass
