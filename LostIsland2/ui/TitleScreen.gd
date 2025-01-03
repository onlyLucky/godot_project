extends TextureRect

@onready var load_button = $VBoxContainer/Load

func _ready():
	load_button.disabled = not Game.has_save_file()

func _on_new_pressed():
	Game.new_game()


func _on_load_pressed():
	Game.load_game()


func _on_quit_pressed():
	get_tree().quit()
