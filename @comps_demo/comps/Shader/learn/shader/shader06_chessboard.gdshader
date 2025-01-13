shader_type canvas_item;
// 实现一个格式棋盘背景

void fragment(){
	vec2 uv = UV;
	// 方法一
	float size = 5.0;
	uv = uv * size;
	// fract 取小数 1.5 0.5
	float xOffset = step(fract(uv.y),0.5) * 0.5;
	float xyOffset = step(fract(uv.x + xOffset),0.5);
	vec4 res = vec4(1.0,1.0,1.0,1.0);
	if(xyOffset==0.0){
		res = vec4(0.0,0.0,0.0,1.0);
	}
	COLOR = res;
}