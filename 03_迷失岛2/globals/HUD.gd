extends CanvasLayer

func _ready():
	SceneChanger.connect("game_entered",show)
	SceneChanger.connect("game_exited",hide)
	visible = get_tree().current_scene is Scene

# 菜单点击
func _on_menu_pressed():
	Game.save_game()
	Game.back_to_title()

