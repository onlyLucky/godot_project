shader_type canvas_item;


uniform vec3      iResolution;           // viewport resolution (in pixels)
uniform float     iTime;                 // shader playback time (in seconds)
uniform float     iTimeDelta;            // render time (in seconds)
uniform float     iFrameRate;            // shader frame rate
uniform int       iFrame;                // shader playback frame
uniform vec4      iMouse;                // mouse pixel coords. xy: current (if MLB down), zw: click
uniform vec4      iDate;                 // (year, month, day, time in seconds)

//precision highp float;


varying float gTime; //  = 0.
const float REPEAT = 5.0;

// 回転行列
mat2 rot(float a) {
	float c = cos(a);
	float s = sin(a);
	return mat2(vec2(c,s),vec2(-s,c));
}

float sdBox( vec3 p, vec3 b )
{
	vec3 q = abs(p) - b;
	return length(max(q,0.0)) + min(max(q.x,max(q.y,q.z)),0.0);
}

float box(vec3 pos, float scale) {
	pos *= scale;
	float base = sdBox(pos, vec3(.4,.4,.1)) /1.5;
	pos.xy *= 5.;
	pos.y -= 3.5;
	pos.xy *= rot(.75);
	float result = -base;
	return result;
}

float box_set(vec3 pos, float time) {
	vec3 pos_origin = pos;
	pos = pos_origin;
	pos .y += sin(gTime * 0.4) * 2.5;
	pos.xy *=   rot(.8);
	float box1 = box(pos,2. - abs(sin(gTime * 0.4)) * 1.5);
	pos = pos_origin;
	pos .y -=sin(gTime * 0.4) * 2.5;
	pos.xy *=   rot(.8);
	float box2 = box(pos,2. - abs(sin(gTime * 0.4)) * 1.5);
	pos = pos_origin;
	pos .x +=sin(gTime * 0.4) * 2.5;
	pos.xy *=   rot(.8);
	float box3 = box(pos,2. - abs(sin(gTime * 0.4)) * 1.5);	
	pos = pos_origin;
	pos .x -=sin(gTime * 0.4) * 2.5;
	pos.xy *=   rot(.8);
	float box4 = box(pos,2. - abs(sin(gTime * 0.4)) * 1.5);	
	pos = pos_origin;
	pos.xy *=   rot(.8);
	float box5 = box(pos,.5) * 6.;	
	pos = pos_origin;
	float box6 = box(pos,.5) * 6.;	
	float result = max(max(max(max(max(box1,box2),box3),box4),box5),box6);
	return result;
}

float map(vec3 pos, float time) {
	vec3 pos_origin = pos;
	float box_set1 = box_set(pos, time);

	return box_set1;
}


//vec4 mainImage( in vec2 fragCoord ) {}

/** SHADERDATA
{
	"title": "Octgrams",
	"description": "Lorem ipsum dolor",
	"model": "person"
}
*/

void vertex(){}

void fragment(){
	vec2 p = (FRAGCOORD.xy * 2. - iResolution.xy) / min(iResolution.x, iResolution.y);
	vec3 ro = vec3(0., -0.2 ,TIME * 4.);
	vec3 ray = normalize(vec3(p, 1.5));
	ray.xy = ray.xy * rot(sin(TIME * .03) * 5.);
	ray.yz = ray.yz * rot(sin(TIME * .05) * .2);
	float t = 0.1;
	vec3 col = vec3(0.);
	float ac = 0.0;


	for (int i = 0; i < 99; i++){
		vec3 pos = ro + ray * t;
		pos = mod(pos-2., 4.) -2.;
		gTime = TIME - float(i) * 0.01;
		
		float d = map(pos, TIME);

		d = max(abs(d), 0.01);
		ac += exp(-d*23.);

		t += d* 0.55;
	}

	col = vec3(ac * 0.02);

	col +=vec3(0.,0.2 * abs(sin(TIME)),0.5 + sin(TIME) * 0.2);


	COLOR = vec4(col ,1.0 - t * (0.02 + 0.02 * sin (TIME)));
}