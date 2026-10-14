class_name Sword_stats extends Resource

# Sword data
@export var sword_range: int = 0
@export var combo_damage: Array[float] = [10.0]
@export var dash_damage: float = 5.0
@export var dash_cooldown: float = 0.1
@export var pushback: float = 1
@export var cooldown_time: Array[float] = [0.1]
@export var max_attack_combo:int = 0
@export var combo_attack_call: Array[String]
@export var durability: float = 100.0

# Throw data
@export var throw_damage: float = 10.0
@export var throw_speed: float = 3.0

func _init() -> void:
	resource_local_to_scene = true
