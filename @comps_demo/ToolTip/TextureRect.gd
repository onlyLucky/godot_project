extends TextureRect


func _ready()->void:
	tooltip_text = "新的提示信息"

# 重写 tooltip
func _make_custom_tooltip(for_text: String) -> Object:
	var tip = load("res://ToolTip/tip.tscn").instantiate()
	tip.set_tip(for_text)
	return tip
 
