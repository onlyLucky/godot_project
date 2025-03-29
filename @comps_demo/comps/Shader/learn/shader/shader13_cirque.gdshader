shader_type canvas_item;

uniform float inner_circle_radius = 0.3;
uniform float width = 0.2;
uniform float inner_start = 0.;
uniform float outer_start = 1.;

// 映射范围函数
float ramp(float input, float in_start, float in_end, float out_start, float out_end){
	// 注意： in_start 不能于 out_start
	float t = (input-in_start)/(in_end-in_start);
	return out_start + (out_end-out_start)*t;
}

void fragment() {
	COLOR = vec4(1,1,1,1);
	
	vec2 vn = UV - vec2(0.5,0.5);
	float radius_vn = length(vn);
	float outer_crcle_radius = inner_circle_radius - width;
	float inner_value = smoothstep(inner_circle_radius, inner_circle_radius+0.005, radius_vn);
	float out_value = smoothstep(outer_crcle_radius,outer_crcle_radius+0.005,radius_vn);
	COLOR.a = abs(inner_value-out_value);
	
	// 添加渐变
	float deg = 0.;
	vec2 upvec = vec2(cos(radians(deg)),sin(radians(deg)));
	vec2 nv1 = normalize(vn);
	
	float theta = acos(dot(nv1,upvec)); // 0->PI
	vec3 n = cross(vec3(upvec,0),vec3(nv1,0));
	theta *= sign(n.z); // -PI， PI
	theta = ramp(theta,-PI,PI,0.,1.);
	//COLOR.a *= theta;
	
	
	float outer_theta = smoothstep(outer_start,outer_start+0.001, theta);
	float inner_theta = smoothstep(inner_start,inner_start+0.001, theta);
	COLOR.a *= inner_theta-outer_theta;
	//COLOR.rgb = vec3(theta);
	
	// 重复分段
	int count = 5;
	float mul = fract(theta*float(count));
	//mul = mul - floor(mul);
	
	// 间隙
	float start = 0.3;
	float offset = 0.001;
	float start_mul = smoothstep(start, start+offset, mul);
	float end_mul = smoothstep(start, start+offset, 1. - mul);
	
	COLOR.a *= end_mul;
}
