extends "res://scenes/Scene.gd"

@onready var dialog_bubble = $Granny/DialogBubble

func _on_granny_interact():
	# 当前老奶奶接到船票道具的时候更改对话
	var flag:="mail_accepted"
	
	var item = Game.inventory.active_item
	if item:
		if item == preload("res://items/mail.tres"):
			Game.flags.add(flag)
			Game.inventory.remove_item(item)
		else:
			return
	
	if 	Game.flags.has(flag):
		dialog_bubble.show_dialog(["没想到老头子的船票寄过来了，听我说谢谢你，温暖了四季"])
	else:
		dialog_bubble.show_dialog([
			"我年纪大了，很多事情想不起来了。",
			"你是谁？算了，我也不在乎你是谁。你能帮我找到信箱的钥匙吗？",
			"老头子说最近会给我寄船票过来，叫我和他一起出去看看。虽然我没有什么兴趣...",
			"他折腾了一辈子，不是躲在楼上捣鼓什么时间机器，就是出海找点什么东西。",
			"这些古怪的电视节目真没有什么意思。",
			"老头子说这个岛上有很多秘密，其实我知道，不过是岛上的日子太孤独，他找点事情做罢了。",
			"人嘛，谁没有年轻过。年轻的时候...算了，不说这些往事了。",
			"老了才明白，万物静默如迷。",
		])
