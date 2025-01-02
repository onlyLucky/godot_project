extends Node2D

func test(a, b):
	print(a,b)

func _ready() -> void:
	test(1,2)
	#Callable
	test.call(1,2) # 等效于test(1,2)
	var test2 = test.bind(2,3)
	test2.call()
	
	var test3 = Callable(self,"test")
	test3.call(3,4)
	
	var test4 = func(a,b): 
		print(a,b)
		print("run end")
	
	test4.call(4,5)
	
