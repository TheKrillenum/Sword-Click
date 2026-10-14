class_name Interactible extends CharacterBody2D

@export var highlight: Sprite2D
@export var animation_sprite: AnimatedSprite2D

func _init() -> void:
	set_process(false)
	set_physics_process(false)


func _ready() -> void:
	update_highlight_visibility(false)


func update_highlight_visibility(new_visibility: bool):
	highlight.visible = new_visibility


func destroy()->void:
	self.queue_free()


func _on_animated_sprite_2d_animation_finished() -> void:
	animation_sprite.play("Idle")
