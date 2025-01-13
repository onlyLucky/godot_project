shader_type canvas_item;

// 四个顶点执行
void vertex() {
	// Called for every vertex the material is visible on.
}
// 每个像素执行
void fragment() {
	// 更改颜色
	COLOR = vec4(1.0,1.0,0.0,1.0);
}

void light() {
	// Called for every pixel for every light affecting the CanvasItem.
}
