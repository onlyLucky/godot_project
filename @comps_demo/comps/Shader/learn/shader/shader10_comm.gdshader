shader_type canvas_item;

uniform vec4 value;
uniform vec4 iMouse;
uniform float iTime;

void vertex(){}

void fragment(){
	COLOR = vec4(iTime,iMouse.r,iMouse.g,1.0);
}