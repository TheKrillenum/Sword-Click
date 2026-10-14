class_name EnemyStats extends Resource

@export var speed: float = 75.0
@export var health: float = 10.0
@export var armor: float = 0.0
@export var damage: float = 1.0
@export var hitstun_frame_duration: int = 20 #Meaning around 0.1 second hit stun
var parent_enemy: BaseEnemy

func _init() -> void:
	resource_local_to_scene = true


func take_damage(damage_amount: float)->void:
	health -= damage_amount
	if(health <= 0):
		parent_enemy.destroy()
	else:
		parent_enemy.damaged()
