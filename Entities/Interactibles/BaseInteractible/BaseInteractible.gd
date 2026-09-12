class_name Interactible extends CharacterBody2D

@export var highlight: Sprite2D
@export var animation_sprite: AnimatedSprite2D
var object: bool = false
var speed: float = 75.0
var health: float = 10.0
var armor: float = 0.0
var damage: float = 1.0
const HITSTUN_DURATION: int = 20 #Meaning around 0.1 second hit stun
var is_in_hitstun: bool = false
var current_hitstun_frame: int = 0

func _init() -> void:
	set_process(false)
	set_physics_process(false)


func _ready() -> void:
	EnemyManager.all_interactibles.append(self)
	update_highlight_visibility(false)


func update_highlight_visibility(new_visibility: bool):
	highlight.visible = new_visibility


func take_damage(damage_amount: float)->void:
	health -= damage_amount
	if(health <= 0):
		death()
	else:
		animation_sprite.play("Hit")
		if(!object):
			is_in_hitstun = true


func death()->void:
	EnemyManager.all_interactibles.erase(self)
	self.queue_free()


func _on_animated_sprite_2d_animation_finished() -> void:
	animation_sprite.play("Idle")


func enemy_ai()->void:
	pass


func move_toward_player(distance_from_player: float) -> void:
	if(position.distance_squared_to(Player.get_player().position) > distance_from_player + 50):
		velocity += (Player.get_player().position - position).normalized() * speed
	elif(position.distance_squared_to(Player.get_player().position) < distance_from_player):
		velocity += (position - Player.get_player().position).normalized() * speed


func move_away_from_other_enemies() -> void:
	for enemy in EnemyManager.all_interactibles:
		if(enemy != self):
			if(position.distance_squared_to(enemy.position) < 400):
				velocity += (position - enemy.position).normalized() * speed


func reset_velocity() -> void:
	velocity = Vector2.ZERO


func hit_stun() -> bool:
	if(!is_in_hitstun):
		return false
	reset_velocity()
	current_hitstun_frame += 1
	
	if(current_hitstun_frame > HITSTUN_DURATION):
		is_in_hitstun = false
		current_hitstun_frame = 0
		return false
	else:
		return true
