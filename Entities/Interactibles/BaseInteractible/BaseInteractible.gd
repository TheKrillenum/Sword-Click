class_name Interactible extends Node2D

@export var highlight: Sprite2D
@export var selected_texture: Texture2D
@export var unselected_texture: Texture2D

func _init() -> void:
	set_process(false)
	set_physics_process(false)
	InteractibleManager.all_interactible.append(self)


func _ready() -> void:
	update_highlight_visibility(false)


func interact()->void:
	pass


func update_highlight_visibility(new_visibility: bool):
	if(new_visibility):
		highlight.texture = selected_texture
	else:
		highlight.texture = unselected_texture


func destroy()->void:
	InteractibleManager.all_interactible.erase(self)
