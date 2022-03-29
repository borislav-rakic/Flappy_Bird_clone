extends KinematicBody2D

signal screen_exited

export var gravity = 10
const flapping_speed = 200
const maximum_fallspeed = 200
const up = Vector2(0, -1)
var motion = Vector2()
var game_ongoing = false

func _physics_process(delta):
	motion.y += gravity
	if motion.y > maximum_fallspeed:
		motion.y = maximum_fallspeed
	
	if Input.is_action_just_pressed("ui_select") && game_ongoing:
		motion.y = -flapping_speed
		$FlapSound.playing = true
		flap_animation()
	
	motion = move_and_slide(motion, up)

func flap_animation():
	$AnimatedSprite.animation = "flap"
	$AnimatedSprite.play()
	yield($AnimatedSprite, "animation_finished")
	$AnimatedSprite.animation = "idle"


func _on_VisibilityNotifier2D_screen_exited():
	emit_signal("screen_exited")
