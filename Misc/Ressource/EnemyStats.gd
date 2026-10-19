class_name EnemyStats extends Resource

@export var speed: float = 75.0
@export var health: float = 10.0
@export var armor: float = 0.0
@export var damage: float = 1.0
@export var hitstun_frame_duration: int = 20 #Meaning around 0.1 second hit stun

func _init() -> void:
	resource_local_to_scene = true
