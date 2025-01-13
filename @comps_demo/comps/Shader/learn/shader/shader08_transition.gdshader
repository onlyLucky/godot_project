shader_type canvas_item;

uniform vec3 iResolution; //viewport resolution (in pixels)
uniform float iTime; //shader playback time(in seconds)
uniform float iTimeDelta; //render time （in seconds)
uniform float iFrameRate; //shader frame rate
uniform int iFrame; //shader playback frame
uniform vec4 iMouse;//mouse pixellcoords. xy:current （if MLB down),zw:click
uniform vec4 iDate; // (year，month,day, time in seconds)

//square root of 3 because hexagon stuff
const float SQRT3 = 1.7320508; // sqrt(3.0)
//two pi for rotation stuff
const float TURN = 6.283185307;
//rotation matrix
const float HALFPI = 1.57079632679;

mat2 ROT(float theta){
	vec4 _out = cos(theta+vec4(0,-HALFPI,HALFPI,0));
	return mat2(vec2(_out.r,_out.g),vec2(_out.b,_out.a));
}

//converts rgb hex code to a vec3
//#define HEX(x)(vec3((x>>16)&255,(x>>8)&255,x&255)/255.)
vec3 HEX(int x){
  return vec3(float((x>>16)&255),float((x>>8)&255),float(x&255))/255.0;
}
//saw wave to trianglewave
//#define ZIG(x)1.-abs(1. - 2. * x)
float ZIG(float x){
  return 1.0 - abs(1.0 - 2.0 * x);
}

// calculate the distance from the center of a hexagon
float hex(vec2 uv){
	const vec2 tileSize=vec2(1.0,SQRT3);
	vec2 tiled =abs(tileSize -mod(
		uv+vec2(0.,SQRT3*2./3.),tileSize * 2.
	));
	float diag =dot(tiled,tileSize /2.);
	float thres =step(1.0,diag);
	return mix(
		max(tiled.x,diag),
		max(1.-tiled.x,2.-diag),
	thres);
}

float hexHelper(vec2 uv,float otherOne){
	const vec2 tileSize =vec2(1.0,SQRT3);
	uv +=
		vec2(0.,SQRT3*2./3.)
		+otherOne * vec2(3.,SQRT3);
	vec2 tiled =abs(
		tileSize * vec2(3.,1.) - mod(uv,tileSize * vec2(6.,2.))
	);
	float diag = dot(tiled,tileSize);
	return step(max(tiled.x,diag *0.5),1.0);
}

float hex2(vec2 uv){
	return max(hexHelper(uv,0.),hexHelper(uv,1.));
}

//map the range [e,1)to stripes of colors
float map(float minv,float maxv,float x){
	if(minv ==maxv){return step(minv,x);}
	return clamp(0.,1.,(x-minv)/(maxv-minv));
}

//set to 1 to enable antialiasing
const int ANTIALIAS = 1;

vec4 mainImage(in vec4 fragCoord){
	float time = fract(TIME/30.); // iTime 暂时保留
	// Scales coords so that theTdiagonals are all the same distance from the center
	
	// 相当于UV
	vec2 uv =(2.*fragCoord.xy-iResolution.xy)/length(iResolution.xy);
	//persp
	uv+=0.125*cos((time+vec2(0.25,0))*TURN);
	uv*=ROT(-time*TURN);
	uv/=1. - 0.5*uv.y;
	uv.x*=.875;
	uv*=8.;
	
	float turnMax =2.*TURN/3.;
	uv*=ROT(time*turnMax);
	//shift center of grid
	uv +=vec2(1,1./SQRT3);
	
	float dist = hex(uv);
	float hexCol1 = hex2(uv);
	float hexCol2=hex2(uv+vec2(1,SQRT3));
	vec3 baseCol = (
		HEX(0x009be8) * hexCol1 +
		HEX(0xEB0072) * hexCol2 +
		HEX(0xfff100) * (1.-hexCol1-hexCol2)
	);	
	float distTemp = ZIG(fract(
		4.5*dist*dist+
		-10.*time +
		0.111 *hexCol1+
		-0.777 *hexCol2
	));
	
	float bright;
	if (ANTIALIAS ==1){
		float aaWidth = fwidth(distTemp)*0.75;
		bright =
			smoothstep(
				-aaWidth,aaWidth,distTemp -0.5
			) * smoothstep(-fwidth(dist),fwidth(dist),0.9-dist);
	}else{
		bright = min(
			step(
				0.5,distTemp
			),
			step(
				dist, 0.9
			)
		);
	}
	vec3 col = mix(HEX(0x010a31),baseCol,bright);
	//Output to screen
	return vec4(col,3.0);
}	
	
	

void vertex(){
	
}

void fragment(){
	COLOR = mainImage(FRAGCOORD);
}