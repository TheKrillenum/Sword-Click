class_name HitReaction_state extends base_enemy_movement_state

@export var next_state: State
var amount_frame_hitstuned: int = 0

# FUNCTION -----------------------------------------------------------------------------------------

func enter_state()-> void:
	reset_velocity()
	state_owner.animation_sprite.play("Hit")


func exit_state()-> void:
	amount_frame_hitstuned = 0


func update_physics(_delta: float)-> void:
	amount_frame_hitstuned += 1
	
	if(amount_frame_hitstuned >= state_owner.stats.hitstun_frame_duration):
		switch_state.emit(next_state)
