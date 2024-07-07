extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	$ContinueGameButton.connect("pressed", Callable(self, "_on_ContinuegameButton_pressed"))
	$SettingsButton.connect("pressed", Callable(self, "_on_SettingsButton_pressed"))
	$MainMenuButton.connect("pressed", Callable(self, "_on_MainMenuButton_pressed"))

func _on_ContinueGameButton_pressed():
	print("Resuming Game")
	get_tree().change_scene_to_file("res://Level.tscn")

func _on_SettingsButton_pressed():
	print("Opening in-game Settings")
	get_tree().change_scene_to_file("res://settings_menu.tscn")
	
func _on_MainMenuButton_pressed():
	print("Exiting to Main Menu")
	get_tree().change_scene_to_file("res://main_menu.tscn")
