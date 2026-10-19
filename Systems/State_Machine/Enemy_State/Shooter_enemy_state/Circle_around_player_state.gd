class_name CircleAroundPlayer_State extends base_enemy_movement_state

@export var shoot_player: State
@export var shooting_distance: float = 60000.0
@export var frame_until_next_shot: int = 500

var current_frame_count: int = 0

func enter_state()-> void:
	state_owner.animation_sprite.play("Run")


func exit_state()-> void:
	current_frame_count = 0


func update_physics(_delta: float)-> void:
	
	move_toward_distance_from_player(shooting_distance)
	move_away_from_other_enemies()
	circle_around_position(Player.get_player().position)
	state_owner.move_and_slide()
	reset_velocity()
	
	current_frame_count += 1
	if(current_frame_count >= frame_until_next_shot):
		switch_state.emit(shoot_player)
