class_name ShooterEnemy extends Interactible

var bullet_scene: Resource = preload("uid://bhkql0u1yyvt5")
var shooting_distance: float = 60000.0
var shooting_cooldown_time: float = 4.0
@export var cooldown_timer: Timer
var can_shoot: bool = false


func _init() -> void:
	super()
	speed = 50.0
	health = 10.0
	armor = 0.0
	damage = 2.0


func _ready() -> void:
	super()
	cooldown_timer.start(shooting_cooldown_time)


func enemy_ai() -> void:
	if(hit_stun()):
		return
	move_toward_player(shooting_distance)
	move_away_from_other_enemies()
	move_and_slide()
	reset_velocity()
	
	if(can_shoot && (position.distance_squared_to(Player.get_player().position) < shooting_distance*1.5)):
		shoot_player()


func shoot_player() -> void:
	if(bullet_scene.can_instantiate()):
		var new_bullet: EnemyBullet = bullet_scene.instantiate()
		
		if(new_bullet != null):
			new_bullet.direction = position.direction_to(Player.get_player().position)
			new_bullet.damage = damage
			new_bullet.global_position = global_position
			get_tree().get_first_node_in_group("Bullet_container").add_child(new_bullet)
			cooldown_timer.start(shooting_cooldown_time)
			can_shoot = false


func _on_timer_timeout() -> void:
	can_shoot = true	
