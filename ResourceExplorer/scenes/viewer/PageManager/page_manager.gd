class_name PageManager extends PanelContainer


signal page_changed
# 分页组件

# 总页数
var total_page: int = 1
# 当前页
var current_page: int = 1

# 每一页的大小
var each_page_item_count = 1
# 总数
var total_item_count = 1

@onready var btn_prev: Button = %BtnPrev
@onready var page_info: Label = %PageInfo
@onready var btn_next: Button = %BtnNext

func _ready() -> void:
	btn_prev.pressed.connect(prev_page)
	btn_next.pressed.connect(next_page)
	#set_total_item_count(total_item_count)
	#set_each_page_item_count(each_page_item_count)
	update_page_info()

# 设置总数
func set_total_item_count(value: int):
	assert(value>=0, "not valid number")
	total_item_count = value
	auto_page()

# 设置分页大小
func set_each_page_item_count(value: int):
	assert(value>0, "not valid number")
	each_page_item_count = value
	auto_page()

# 设置总页数
func set_total_page(value: int):
	assert(value>0, "not valid number")
	total_page = value
	check_page()

func update_page_info():
	page_info.text = "%d/%d" %[current_page, total_page]
	btn_next.disabled = current_page == total_page
	btn_prev.disabled = current_page == 1
	
func next_page():
	current_page += 1
	check_page()
	update_page_info()

func prev_page():
	current_page -= 1
	check_page()
	update_page_info()

func check_page():
	current_page = max(1, min(current_page, total_page))
	page_changed.emit()


func auto_page():
	if total_item_count % each_page_item_count == 0 and total_item_count!=0:
		set_total_page(total_item_count/each_page_item_count)
	else:
		set_total_page(total_item_count/each_page_item_count + 1)
	update_page_info()

# 根据当前页数应该显示那些item  all_items 全部数据
func get_items(all_items:Array)->Array:
	return all_items.slice(each_page_item_count*(current_page-1),each_page_item_count*current_page)
