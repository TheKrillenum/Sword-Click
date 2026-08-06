class_name Interactible extends Node2D

@export var highlight: Sprite2D
@export var animation_sprite: AnimatedSprite2D
var health: float = 5.0
var armor: float = 0.0
var damage: float = 1.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GlobalDataCollection.all_interactibles.append(self)
	update_highlight_visibility(false)


func update_highlight_visibility(new_visibility: bool):
	highlight.visible = new_visibility


func take_damage(damage_amount: float)->void:
	health -= damage_amount
	if(health <= 0):
		death()
	else:
		animation_sprite.play("Hit")


func death()->void:
	GlobalDataCollection.all_interactibles.erase(self)
	self.queue_free()


func _on_animated_sprite_2d_animation_finished() -> void:
	animation_sprite.play("Idle")
