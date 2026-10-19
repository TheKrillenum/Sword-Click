extends "res://Entities/Swords/BaseSword/BaseSword.gd"


func combo_attack_1(targeted_location: Vector2)->void:
	attack_rotation = get_angle_to(targeted_location)
	attack_origin = global_position
	
	attack_animation.rotate(attack_rotation)
	attack_animation.visible = true
	attack_animation.play("combo1_anim")
	
	callable_damage_func = "attack_1_damage"
	windup_timer.start(0.15)

func attack_1_damage()-> void:
	for enemy in check_for_area(attack_rotation, attack_scale, attack_origin, Shape.SLASH):
		deal_damage(enemy, stats.combo_damage[combo_attack_counter - 1])

# --------------------------------------------------------------------------------------------------

func combo_attack_2(targeted_location: Vector2)->void:
	attack_rotation = get_angle_to(targeted_location)
	attack_scale = Vector2(1,1)
	attack_origin = global_position + global_position.direction_to(targeted_location) * 50
	
	attack_animation.rotate(attack_rotation)
	attack_animation.visible = true
	attack_animation.play("combo2_anim")
	callable_damage_func = "attack_2_damage"
	windup_timer.start(0.15)

func attack_2_damage():
	for enemy in check_for_area(attack_rotation, attack_scale, attack_origin, Shape.RECTANGLE, Vector2(50.0, 10.0)):
		deal_damage(enemy, stats.combo_damage[combo_attack_counter - 1])

# --------------------------------------------------------------------------------------------------

func combo_attack_3(targeted_location: Vector2)->void:
	attack_scale = Vector2(1,1)
	attack_origin = global_position
	
	attack_animation.visible = true
	attack_animation.play("combo3_anim")
	callable_damage_func = "attack_3_damage"
	windup_timer.start(0.15)

func attack_3_damage():
	for enemy in check_for_area(attack_rotation, attack_scale, attack_origin, Shape.CIRCLE,50.0):
		deal_damage(enemy, stats.combo_damage[combo_attack_counter - 1])

# --------------------------------------------------------------------------------------------------

func dash_attack_complete(_targeted_location: Vector2)->void:
	
	attack_rotation = get_angle_to(_targeted_location)
	attack_scale = Vector2(1,1)
	attack_origin = global_position
	
	attack_animation.rotate(attack_rotation)
	attack_animation.visible = true
	attack_animation.play("dash_anim")
	
	for enemy in check_for_area(attack_rotation, attack_scale, attack_origin, Shape.SEGMENT,100.0):
		deal_damage(enemy, stats.dash_damage)
	super(_targeted_location)

# --------------------------------------------------------------------------------------------------

func throw_weapon(target_location: Vector2)->void:
	#super(target_location)
	print_debug("Can't throw the default sword")
