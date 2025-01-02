class_name BasePanel
extends PanelContainer

# 单个文件 基础面板 后续根据不同类型文件展示不同文件的基础面板

@onready var tr_main_image: TextureRect = %TR_MainImage as TextureRect
@onready var default_texture: MarginContainer = %DefaultTexture
@onready var label_title: Label = %LabelTitle as Label

func set_title(text:String):
	label_title.text = text

func set_image(texture: Texture2D):
	tr_main_image.texture = texture
	if not texture:
		default_texture.show()
		tr_main_image.hide()
	else:
		default_texture.hide()
		tr_main_image.show()
