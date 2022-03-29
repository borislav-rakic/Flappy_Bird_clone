extends CanvasLayer

var original_position
var screen_size
var speed = 40
var velocity = Vector2(-1, 0)

func _ready():
	original_position = get_viewport().size

func _process(delta):
	offset.x += velocity.x * speed * delta
	
	if offset.x <= -original_position.x:
		offset.x = 0
