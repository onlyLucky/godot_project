extends Node2D

var thread

# 线程使用完记得关闭， 有可能会引发程序闪退
func _ready() -> void:
	# 创建一个线程实例化对象
	thread = Thread.new()
	# 线程一旦跑过了，再次执行线程对象的函数时候会报线程已经存在
	thread.start(func(): print(123))
	if not thread.is_alive():
		if thread.is_started():
			# 等待线程结束之后, 线程必须已经跑过，否则就会报错
			thread.wait_to_finish()
		thread.start(func(): print(123))
		
# 当前场景退出节点树,停止线程
func _exit_tree() -> void:
	if thread.is_started():
			# 等待线程结束之后, 线程必须已经跑过，否则就会报错
			thread.wait_to_finish()
