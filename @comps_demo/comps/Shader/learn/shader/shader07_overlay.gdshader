shader_type canvas_item;

// 圆形遮罩

uniform sampler2D img;

// 绘制圆形
float circle(vec2 position, float radius, float feather){
	return smoothstep(radius, radius + feather, length(position - vec2(0.5)));
}

// 圆角矩形
vec4 square_rounded(vec2 uv, float width, float radius){
	uv = uv * 2.0 - 1.0;
	
	radius *= width; // make radius go from 0-1 instead of 0-width
	vec2 abs_uv = abs(uv.xy) - radius;
	vec2 dist = vec2(max(abs_uv.xy, 0.0));
	float square = step(width - radius, length(dist));
	return vec4(vec3(square), 1.0);
}

void fragment(){
	/*vec2 uv = UV;
	uv = uv - 0.5; // 将uv移动到中心
	float d = length(uv)*3.0;
	// clamp 将d 的值限制到0.0 1.0之间
	d = clamp(d,0.0,1.0);
	
	COLOR = vec4(1.0-d,0.0,0.0,1.0);
	vec4 color_tex = texture(img, UV);
	//COLOR = vec4(color_tex.r,color_tex.g,color_tex.b,1.0-d); // 过滤r通道*/
	
	//另外一种圆形遮罩
	/*vec4 color_tex = texture(img, UV);
	COLOR = vec4(color_tex.r,color_tex.g,color_tex.b,1.0 - circle(UV, 0.4, 0.005)); // res 反向 1.0 - res*/
	
	// 圆角矩形遮罩
	vec4 color_tex = texture(img, UV);
	vec4 d = square_rounded(UV, 0.8, 0.8);
	COLOR = vec4(color_tex.r,color_tex.g,color_tex.b,1.0 - d.r);
}