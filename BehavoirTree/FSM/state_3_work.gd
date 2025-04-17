extends StateBase

func _ready():
	state_name = "state_3_work"
	
# 非强类型声明  状态机就不能强制声明 StateBase 还需要判断类型是否存在StateBase 抽象类的方法 has_method
#const state_name = "state_3_work"
