class_name ShootPlayer_state extends base_enemy_movement_state

@export var next_state: State
@export var shooting_animation_duration: int = 100
var bullet_scene: Resource = preload("res://Entities/Enemies/ShooterEnemy/EnemyBullet.tscn")
var did_not_shoot: bool

var current_frame: int = 0

func enter_state()-> void:
	reset_velocity()
	did_not_shoot = true


func exit_state()-> void:
	current_frame = 0


func update_physics(_delta: float)-> void:
	current_frame += 1
	
	if(current_frame >= shooting_animation_duration):
		switch_state.emit(next_state)
	elif(current_frame >= (shooting_animation_duration * 0.75) and did_not_shoot):
		shoot_player()


func shoot_player()->void:
	
	did_not_shoot = false
	
	if(bullet_scene.can_instantiate()):
		var new_bullet: EnemyBullet = bullet_scene.instantiate()
		
		if(new_bullet != null):
			new_bullet.direction = state_owner.global_position.direction_to(Player.get_player().position)
			new_bullet.damage = state_owner.stats.damage
			new_bullet.global_position = state_owner.global_position
			get_tree().get_first_node_in_group("Bullet_container").add_child(new_bullet)
		
