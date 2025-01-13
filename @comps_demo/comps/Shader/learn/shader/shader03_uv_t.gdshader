shader_type canvas_item;
uniform sampler2D img;

uniform float angle = 0.0;

/*
虚幻引擎的自定义旋转的函数
RotationAngle： 为旋转角度输入一个0-1的值 1为360度
RotationCenter： 为旋转中心
UVs 插入UV 
*/
vec2 customRotator(vec2 UVs, vec2 RotationCenter, float RotationAngle){
	vec2 _uv = UVs + RotationCenter * -1.0;
	float angle_cos = cos(RotationAngle);
	float angle_sin = sin(RotationAngle);
	vec2 _a = vec2(angle_cos, angle_sin * -1.0);
	vec2 _b = vec2(angle_sin, angle_cos);
	
	return vec2(dot(_uv,_a), dot(_uv, _b)) + RotationCenter;
}

void fragment(){
	vec2 uv_ = UV;
	//uv_ = uv_ + 0.5;
	//uv_ = uv_ * 0.5;
	//uv_.x = uv_.x + 0.5; // 加减移动 乘除缩放
	
	// 旋转矩阵 mat2 二维矩阵2*2
	/*
	uv_ = uv_ - 0.5;
	mat2 m = mat2(
		vec2(cos(angle),-sin(angle)),
		vec2(sin(angle),cos(angle))
	);
	uv_ = uv_ * m;
	uv_ = uv_ + 0.5; // 居中旋转 设置矩阵之前减去或加上 设置过矩阵之后再减去或加上
	*/
	// 翻转 
	//uv_.y = 1.0 - uv_.y; // x轴翻转
	//uv_.x = 1.0 - uv_.x; // y 轴翻转
	
	// 定义函数调用
	uv_ = customRotator(uv_, vec2(0.5,0.5), angle);
	
	COLOR = texture(img,uv_);
	//COLOR = vec4(uv_,0.0,1.0);
}
