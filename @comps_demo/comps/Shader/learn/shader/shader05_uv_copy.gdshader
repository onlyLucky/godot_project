shader_type canvas_item;
// uv 复制
uniform sampler2D img;
uniform float offset = 0.0;

void vertex(){}

vec2 copy(vec2 uv){
	vec2 uv_ = uv;
	uv_ = uv_ * 2.0;
	// floor 向下取整
	vec2 id = floor(uv_);
	uv_ = uv_ - id;
	/*
		整体乘以2， 0-2 floor(uv_) 向下取整 0.25*2 = 0.5 floor(0.5)= 0 0.5-0=0.5
		0.75*2=1.5 floor(1.5)=1 1.5-1=0.5
		原来的0是0 0.25变成0.5 0.5变成1或者0 0.75 变成0.5
	*/
	// 只复制x 更改为uv_.x
	return uv_;
}

vec2 truncopy(vec2 uv){
	vec2 uv_ = uv;
	float x = uv.x;
	// 保存Y轴， 对X轴进行翻转
	float y = uv.y;
	
	float x02 = x * 2.0;
	// floor 向下取整
	float id = floor(x02);
	float x0101 = x02 - id;
	
	//step(a,b) 比较两个值 a>b 0 a<b 1
	float mask_x = step(x02, 1.0);
	float x0100 = x0101*(1.0 - mask_x);
	float x1010 = 1.0-x0101;// 取反
	float x0010 = x1010 * mask_x;
	
	float x0110 = x0100 + x0010;
	
	uv_.x = x0110 + offset;
	return uv_;
}

void fragment(){
	//vec2 uv_ = copy(UV);
	vec2 uv_ = truncopy(UV);
	
	//  确保图片不会有多余无用的像素。
	if(any(greaterThan(abs(uv_ - 0.5), vec2(0.5)))) discard;
	COLOR = texture(img, uv_);
	//COLOR = vec4(uv_.x,0.0,0.0,1.0);
}