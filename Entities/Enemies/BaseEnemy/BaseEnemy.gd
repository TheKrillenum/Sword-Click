class_name BaseEnemy extends CharacterBody2D

# VARIABLE -----------------------------------------------------------------------------------------

@export var stats: EnemyStats
@export var animation_sprite: AnimatedSprite2D
@export var state_machine: stateMachine
@export var hitReaction_state: State

# FUNCTION -----------------------------------------------------------------------------------------

func _init() -> void:
	set_process(false)
	set_physics_process(false)

func _ready() -> void:
	InteractibleManager.all_enemies.append(self)

# Healh & Damage -----------------------------------------------------------------------------------

func damage_enemy(damage_amount: float)->void:
	stats.health -= damage_amount
	
	if(stats.health <= 0):
		destroy()
	else:
		state_machine.update_state(hitReaction_state)


func destroy()->void:
	InteractibleManager.all_enemies.erase(self)
	var interactible_node = $Interactible
	interactible_node.destroy()
	self.queue_free()

# Animation ----------------------------------------------------------------------------------------

func _on_animated_sprite_2d_animation_finished() -> void:
	pass#animation_sprite.play("Idle")
