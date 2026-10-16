class_name BaseEnemy extends CharacterBody2D

# VARIABLE -----------------------------------------------------------------------------------------

@export var stats: EnemyStats
@export var animation_sprite: AnimatedSprite2D

var is_in_hitstun: bool = false
var current_hitstun_frame: int = 0

# FUNCTION -----------------------------------------------------------------------------------------

func _ready() -> void:
	#super()
	InteractibleManager.all_enemies.append(self)
	stats.parent_enemy = self


func enemy_ai()->void:
	pass

# Healh & Damage -----------------------------------------------------------------------------------

#func hit_stun() -> bool:
	#if(!is_in_hitstun):
		#return false
	#reset_velocity()
	#current_hitstun_frame += 1
	#
	#if(current_hitstun_frame > stats.hitstun_frame_duration):
		#is_in_hitstun = false
		#current_hitstun_frame = 0
		#return false
	#else:
		#return true


func damaged()->void:
	animation_sprite.play("Hit")
	is_in_hitstun = true


func destroy()->void:
	InteractibleManager.all_enemies.erase(self)
	var interactible_node = $Interactible
	interactible_node.destroy()
	self.queue_free()

# Animation ----------------------------------------------------------------------------------------

func _on_animated_sprite_2d_animation_finished() -> void:
	animation_sprite.play("Idle")
