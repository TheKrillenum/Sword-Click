extends "res://Swords/BaseSword/BaseSword.gd"


# Called when the node enters the scene tree for the first time.
func _init() -> void:
	sword_range = 100
	max_attack_combo = 3
	damage = [10, 20, 40, 5]
	cooldown = [0.1, 0.1, 0.2]
	combo_attack_call = ["combo_attack_1", "combo_attack_2", "combo_attack_3"]


func combo_attack_1(targeted_location: Vector2)->void:
	print_debug("Slash left test")


func combo_attack_2(targeted_location: Vector2)->void:
	print_debug("Slash right test")


func combo_attack_3(targeted_location: Vector2)->void:
	print_debug("Slam test")


func dash_attack_complete(_targeted_location: Vector2)->void:
	print_debug("Dash attack test")
	super(_targeted_location)
