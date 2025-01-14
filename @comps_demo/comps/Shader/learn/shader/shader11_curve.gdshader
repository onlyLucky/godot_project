shader_type canvas_item;

// 使用过渡曲线
uniform float iTime;
uniform sampler2D curve;


void vertex(){}

void fragment(){
	vec4 curve_value = texture(curve,vec2(iTime,0.0));
	COLOR = vec4(curve_value.r,0.0,0.0,1.0);
}