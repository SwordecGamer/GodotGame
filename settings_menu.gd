extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	$ExitSettingsButton.connect("pressed", Callable(self, "_on_ExitSettingsButton_pressed"))

func _on_ExitSettingsButton_pressed():
	print("Exited Settings")
	get_tree().change_scene_to_file("res://main_menu.tscn")
