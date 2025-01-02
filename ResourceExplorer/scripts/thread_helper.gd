class_name  ThreadHelper extends RefCounted

# 多线程处理逻辑公共脚本

# 实例化线程对象
var _thread := Thread.new()
# 储存线程执行的函数
var _functions:=[]
# 线程持有节点
var _holder :Node

# 初始化方法
func _init(holder:Node) -> void:
	_holder = holder
	# 节点退出节点树的时候
	_holder.tree_exited.connect(end)

# 添加线程执行的函数
func join_function(function: Callable):
	_functions.append(function)
	
# 开始执行线程函数
func start():
	assert(_holder,"holder 必须存在")
	if _thread.is_alive():
		return
	
	if _thread.is_started():
		_thread.wait_to_finish()
	_thread.start(_start_thread)

# 当前线程是否在运行中
func is_running():
	return _thread.is_alive()

# 结束线程任务， 最初_end_thread，不直接写逻辑，为了后面逻辑拓展
func end():
	_end_thread()

# 真正要执行的线程函数
func _start_thread():
	while true:
		if not _functions:
			break
		var function = _functions.pop_front()
		function.call()

# 结束线程任务
func _end_thread():
	_functions = []
	
	if _thread.is_started():
		_thread.wait_to_finish()
