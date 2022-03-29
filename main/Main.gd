extends Node

export (PackedScene) var GreenPipe
var screen_size
var score = 0
var second_pipe_reached = false
var pipe_was_hit = false

func _ready():
	randomize()
	screen_size = get_viewport().size
	$Player.gravity = 0
	$Player/AnimatedSprite.animation = "flap"
	$Player/AnimatedSprite.playing = true
	$Player.position.x = screen_size.x / 2
	$Player.position.y = screen_size.y / 2

func _on_HUD_game_started():
	$Player.gravity = 10
	$Player/AnimatedSprite.animation = "idle"
	$Player.game_ongoing = true
	$HUD/GameStart.visible = false
	$HUD/Score.visible = true
	$HUD/Score.text = str(0)
	score = 0
	$SpawnPipesTimer.start()
	pipe_was_hit = false
	second_pipe_reached = false

func _on_SpawnPipesTimer_timeout():
	var pipe_spawn_location = $PipeSpawn/PipeSpawnLocation
	pipe_spawn_location.offset = randi()
	
	var lower_pipe = GreenPipe.instance()
	add_child(lower_pipe)
	
	var upper_pipe = GreenPipe.instance()
	add_child(upper_pipe)
	upper_pipe.get_child(0).flip_v = true
	
	lower_pipe.connect("pipe_hit", self, "pipe_hit")
	upper_pipe.connect("pipe_hit", self, "pipe_hit")
	
	lower_pipe.position = pipe_spawn_location.position
	upper_pipe.position.x = pipe_spawn_location.position.x
	upper_pipe.position.y = pipe_spawn_location.position.y - 400
	
	$SpawnPipesTimer.start()
	
	var t = Timer.new()
	add_child(t)
	t.set_wait_time(2)
	t.set_one_shot(true)
	t.start()
	yield(t, "timeout")
	if second_pipe_reached:
		update_score()
	second_pipe_reached = true

func update_score():
	$PointSound.playing = true
	score += 1
	$HUD/Score.text = str(score)

func pipe_hit():
	if !pipe_was_hit:
		$HitSound.playing = true
		$DeathSound.playing = true
		pipe_was_hit = true
		second_pipe_reached = false
		$Player.game_ongoing = false
		$Player.gravity = 100
		$Player/AnimatedSprite.animation = "flap"
		$Player/AnimatedSprite.playing = true
		$HUD/Message.visible = true
		$SpawnPipesTimer.stop()
		var t = Timer.new()
		add_child(t)
		t.set_wait_time(3)
		t.set_one_shot(true)
		t.start()
		yield(t, "timeout")
		$HUD/Message.visible = false
		$Player.gravity = 0
		$Player.motion = Vector2()
		$Player.position.y = screen_size.y / 2
		$Player/AnimatedSprite.animation = "flap"
		$Player/AnimatedSprite.playing = true
		$HUD/GameStart.visible = true
		var pipes = get_tree().get_nodes_in_group("pipes")
		for i in pipes:
			i.queue_free()
