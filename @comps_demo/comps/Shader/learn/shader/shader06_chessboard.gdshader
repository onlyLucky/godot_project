shader_type canvas_item;
// 实现一个格式棋盘背景
// 本质上实现一个获取0 或者 1

void fragment(){
	vec2 uv = UV;
	vec4 res = vec4(1.0,1.0,1.0,1.0);
	// 方法一
	/*float size = 5.0;
	uv = uv * size;
	// fract 取小数 1.5 0.5
	float xOffset = step(fract(uv.y),0.5) * 0.5;
	float xyOffset = step(fract(uv.x + xOffset),0.5);
	if(xyOffset==0.0){
		res = vec4(0.0,0.0,0.0,1.0);
	}
	COLOR = res;*/
	// 方法二
	/*uv = sin(uv*50.); // 25 sin 缩放 0-50  -1 到 +1 
	float r = ceil(uv.x*uv.y); // 向上取整 （x*y 得出是-1 到 +1之间 向上取整 0 或者 1）
	if(r==0.0){
		res = vec4(0.0,0.0,0.0,1.0);
	}
	COLOR = res;*/
	// 方法三
	/*uv = floor(uv*5.0);
	// mod 取余数
	float r = mod(uv.x+uv.y,2.0);
	
	if(r==0.0){
		res = vec4(0.0,0.0,0.0,1.0);
	}
	COLOR = res;*/
	// 方法四
	float size = 25.0;
	uv = sin(uv * size);
	float x = 0.0;
	if(uv.x*uv.y >0.){
		x=1.0;
	}
	if(x==0.0){
		res = vec4(0.0,0.0,0.0,1.0);
	}
	COLOR = res;
	// 少使用if 除法减法 尽量使用乘法加法 对性能有帮助
}