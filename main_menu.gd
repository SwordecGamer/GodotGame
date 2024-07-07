extends Control

func _ready():
	$StartGameButton.connect("pressed", Callable(self, "_on_StartButton_pressed"))
	$SettingsButton.connect("pressed", Callable(self, "_on_SettingsButton_pressed"))
	$ExitGameButton.connect("pressed", Callable(self, "_on_ExitButton_pressed"))

func _on_StartButton_pressed():
	print("Start Button Pressed")  # Debugging output
	get_tree().change_scene_to_file("res://Level.tscn")

func _on_SettingsButton_pressed():
	print("Settings Button Pressed")  # Debugging output
	get_tree().change_scene_to_file("res://settings_menu.tscn")

func _on_ExitButton_pressed():
	print("Exit Button Pressed")  # Debugging output
	get_tree().quit()
