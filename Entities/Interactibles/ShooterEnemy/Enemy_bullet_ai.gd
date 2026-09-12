class_name EnemyBullet extends Node2D

const SPEED: float = 1.0
var damage: float
var direction: Vector2

func _init() -> void:
	set_process(false)


func _physics_process(delta: float) -> void:
	position = position + direction * SPEED


func _on_timer_timeout() -> void:
	deactivate_bullet()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if(body as Player):
		Player.get_player().take_damage(damage)
		deactivate_bullet()


func deactivate_bullet() -> void:
	set_physics_process(false)
	var sprite: AnimatedSprite2D = $AnimatedSprite2D
	sprite.stop()
	sprite.visible = false
