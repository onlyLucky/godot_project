shader_type canvas_item;
// 引入图片
void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// 显示图片
	COLOR = texture(TEXTURE,UV);
	// 颜色计算 + - * / 调整图片颜色
	//COLOR = COLOR * vec4(1.0,0.0,0.0,1.0);
	// 调整背景某一个通道
	COLOR = vec4(COLOR.r,COLOR.g,COLOR.b,COLOR.b); // vec4(COLOR.r,COLOR.g,COLOR.b,COLOR.a)
}

void light() {
	// Called for every pixel for every light affecting the CanvasItem.
}
