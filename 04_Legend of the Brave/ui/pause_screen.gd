extends Control

@onready var resume: Button = $V/Actions/HBoxContainer/Resume


func _ready() -> void:
	hide()
	SoundManger.setup_ui_sounds(self)
	
	# 监听当前场景是否显示
	visibility_changed.connect(func ():
		get_tree().paused =visible
	)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		hide()
		# 禁止esc 按键继续往下传
		get_window().set_input_as_handled()

# 显示暂停场景
func show_pause() -> void:
	show()
	# 默认聚焦继续游戏
	resume.grab_focus()


func _on_resume_pressed() -> void:
	hide()


func _on_quit_pressed() -> void:
	Game.back_to_title()
