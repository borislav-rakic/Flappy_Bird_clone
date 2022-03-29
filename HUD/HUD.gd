extends CanvasLayer

signal game_started

func _on_GameStart_pressed():
	emit_signal("game_started")
