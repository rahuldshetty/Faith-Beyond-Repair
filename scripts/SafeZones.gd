extends Area2D

func _on_body_entered(body):
	if body.is_in_group("player"):
		Game.state['SAFE_ZONE'] = true


func _on_body_exited(body):
	if body.is_in_group("player"):
		Game.state['SAFE_ZONE'] = false
