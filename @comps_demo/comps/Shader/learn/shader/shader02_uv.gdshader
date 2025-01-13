shader_type canvas_item;

//外部传参 指定默认值。
uniform float a = 3.5;
uniform int b = 1;
uniform vec2 c = vec2(1.0,3.5);
uniform vec3 d = vec3(1.0,3.5,0.5);
uniform vec4 e = vec4(1.0,3.5,0.5,1.0);
// 外部传参 指定类型为图片
uniform sampler2D Image;
// 颜色选择类型
uniform vec4 g : source_color;

// 函数体外varying  内部设置变量，可以从顶点着色器函数 传值到片段着色器函数中
varying float h;
// 常量
const int num = 1;

// 文档中 in可读 inout可读写

// uv 2d(x,y)
// 顶点着色剂
void vertex() {
	// 函数体外
	float aa = 1.0;
	aa = aa + 0.2;
	h = 0.1;
}

/*
COLOR = vec4(UV, 0.0,1.0);
左上角（黑色）0,0,0,1
右上角（红色）1,0,0,1
左下角（绿色）0,1,0,1
右下角（红+绿 = 黄）1,1,0,1
*/    
//片段着色剂
void fragment() {
	//COLOR = vec4(UV, 0.0,1.0); // 显示UV UV 只能读不能写
	vec2 uv_ = UV; 
	//uv_ = uv_.x + 0.5; //对x轴进行移动
	uv_ = uv_ + h; // 对UV 进行移动 
	COLOR = texture(Image,uv_);
}

void light() {
	// Called for every pixel for every light affecting the CanvasItem.
}
