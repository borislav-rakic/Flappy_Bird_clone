extends Area2D

signal pipe_hit

var speed = 70
var velocity = Vector2(-1, 0)

func _process(delta):
	position.x += velocity.x * speed * delta

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

func _on_GreenPipe_body_entered(body):
	emit_signal("pipe_hit")
