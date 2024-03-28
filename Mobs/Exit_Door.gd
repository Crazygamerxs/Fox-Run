extends Area2D

func _on_body_entered(body):
	if body.name == "Player":
		var player_gold = Game.Gold
		if player_gold >= 50:
			# Player won
			print("You won, you got 50 or more gold Coins!")
			get_tree().change_scene_to_file("res://main.tscn")

		else:
			# Player lost
			print("You lost, not enough Gold Coins!")
			# Pop up message here
