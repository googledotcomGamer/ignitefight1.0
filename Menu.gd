extends Control

func _on_StartButton_pressed():
	get_tree().change_scene("res://LevelSelect.tscn")


func _on_OptionsButton_pressed():
	pass


func _on_QuitButton_pressed():
	get_tree().quit()
