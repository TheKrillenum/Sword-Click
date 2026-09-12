extends "res://Entities/Swords/BaseSword/BaseSword.gd"


# Called when the node enters the scene tree for the first time.
func _init() -> void:
	sword_range = 75
	max_attack_combo = 3
	combo_damage = [10.0, 20.0, 40.0]
	dash_damage = 5.0
	dash_cooldown = 0.1
	cooldown_time = [0.4, 0.2, 0.6]
	combo_attack_call = ["combo_attack_1", "combo_attack_2", "combo_attack_3"]


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
		deal_damage(enemy, combo_damage[combo_attack_counter - 1])


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
		deal_damage(enemy, combo_damage[combo_attack_counter - 1])


func combo_attack_3(targeted_location: Vector2)->void:
	attack_scale = Vector2(1,1)
	attack_origin = global_position
	
	attack_animation.visible = true
	attack_animation.play("combo3_anim")
	callable_damage_func = "attack_3_damage"
	windup_timer.start(0.15)

func attack_3_damage():
	for enemy in check_for_area(attack_rotation, attack_scale, attack_origin, Shape.CIRCLE,50.0):
		deal_damage(enemy, combo_damage[combo_attack_counter - 1])


func dash_attack_complete(_targeted_location: Vector2)->void:
	attack_rotation = get_angle_to(_targeted_location)
	attack_scale = Vector2(1,1)
	attack_origin = global_position
	attack_animation.rotate(attack_rotation)
	attack_animation.visible = true
	attack_animation.play("dash_anim")
	for enemy in check_for_area(attack_rotation, attack_scale, attack_origin, Shape.SEGMENT,100.0):
			deal_damage(enemy, dash_damage)
	super(_targeted_location)


func throw_weapon(target_location: Vector2)->void:
	#super(target_location)
	print_debug("Can't throw the default sword")
