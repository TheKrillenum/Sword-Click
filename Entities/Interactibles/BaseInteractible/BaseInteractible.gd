class_name Interactible extends Node2D

@export var highlight: Sprite2D

func _init() -> void:
	set_process(false)
	set_physics_process(false)


func _ready() -> void:
	update_highlight_visibility(false)


func update_highlight_visibility(new_visibility: bool):
	highlight.visible = new_visibility


func destroy()->void:
	InteractibleManager.all_interactible.erase(self)
	self.queue_free()
