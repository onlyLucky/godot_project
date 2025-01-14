## Shader

### shader代码转换

转化前

``` glsl
//square root of 3 because hexagon stuff
#define SQRT3 (1.7320508)
//two pi for rotation stuff
#define TURN (6.283185307)
//rotation matrix
#define HALFPI (1.57079632679)
#define ROT(theta)mat2(cos(theta+vec4(0,-HALFPI,HALFPI,0)))
//converts rgb hex code to a vec3
#define HEX(x)(vec3((x>>16)&255,(x>>8)&255,x&255)/255.)
//saw wave to trianglewave
#define ZIG(x)1.-abs(1. - 2. * x)

// calculate the distance from the center of a hexagon
float hex(vec2 uv)
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
float hexHelper(vec2 uv,float otherOne){
	const vec2 tileSize =vec2(1.0,SQRT3);
	uv +=
		vec2(0.,SQRT3*2./3.)
		+otherOnevec2(3.,SQRT3);
	vec2 tiled =abs(
		tileSize *vec2(3.,1.) - mod(
			uv,tileSizevec2(6.,2.)
		)
	);
	float diag = dot(tiled,tileSize);
	return step(max(tiled.x,diag *0.5),1.0);
}

float hex2(vec2 uv){
	return max(hexHelper(uv,0.),hexHelper(uv,1.));
}

//map the range [e,1)to stripes of colors
float map(float minv;float maxv,float x){
	if(minv ==maxv)(return step(minv,x);}
	return clamp(0.,1.,(x-minv)/(maxv-minv));
};

//set to 1 to enable antialiasing
#define ANTIALIAS 1

void mainImage(out vec4 fragColor,in vec2 fragCoord){
	float time = fract(iTime/30.);
	// Scales coords so that theTdiagonals are all the same distance from the center
	vec2 uv =(2.*fragCoord.xy-iResolution.xy)/1ength(iResolution.xy);
	uv+=0.125*cos((time+vec2(0.25,0))*TURN);
	//persp
	uv/=1.0.5*uv.y;uv*=ROT(-time*TURN);
	uv.x*=.87;
	uv=8.;
	
	float turnMax =2.*TURN/3.;
	uv*=ROT(time*turnMax);
	//shift center of grid
	uV +=vec2(1,1./SQRT3);
	
	float dist = hex(uv);
	float hexCol1 = hex2(uv);
	float hexCo12=hex2(uv+vec2(1,SQRT3));
	vec3 baseCol = (
		HEX(0x009be8) * hexCol1 +
		HEX(0xEB0072) * hexCo12 +
		HEX(0xfff100) * (1.-hexCol1-hexCol2)
	);	
	float distTemp = ZIG(fract(
		4.5*dist*dist+
		-10.*time +
		0.111 *hexCol1+
		-0.777 *hexCo12
	));
	#if ANTIALIAS ==1
		float aaWidth = fwidth(distTemp)*0.75;
		float bright =
			smoothstep(
				-aaWidth,aaWidth,distTemp -0.5
			) * smoothstep(-fwidth(dist),fwidth(dist),0.9-dist)
	#else
		float bright = min(
			step(
				0.5,distTemp
			),
			step(
				dist, 0.9
			)
		);
	#endif
		vec3 col = mix(HEX(0x010a31),baseCol,bright);
		//Output to screen
		fragColor=vec4(col,3.0);
}	
```

转化后
``` glsl
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
```

``` glsl
#define SQRT3 (1.7320508)
// 转换后
const float SQRT3 = 1.7320508;

#define ROT(theta)mat2(cos(theta+vec4(0,-HALFPI,HALFPI,0)))
// 转换后
mat2 ROT(float theta){
	vec4 _out = cos(theta+vec4(0,-HALFPI,HALFPI,0));
	return mat2(vec2(_out.r,_out_g),vec2(_out.b,_out_a));
}

#define HEX(x)(vec3((x>>16)&255,(x>>8)&255,x&255)/255.)
// 转换后
vec3 HEX(int x){
  return vec3((x>>16)&255,(x>>8)&255,x&255)/255.0;
}

#define ZIG(x)1.-abs(1. - 2. * x)
// 转换后
float ZIG(float x){
  return 1.0 - abs(1.0 - 2.0 * x);
}

precision highp float;
// 转换后






```

### 基础知识

#### 1.旋转矩阵

旋转矩阵是一种用于在二维或三维空间中进行旋转操作的矩阵。它在图形学、计算机视觉、机器人学等领域有广泛应用。下面分别介绍二维和三维空间中的旋转矩阵。

##### 二维旋转矩阵

在二维空间中，假设有一个点 $(x, y)$ 绕原点旋转角度 $\theta$（逆时针方向），旋转后的点 $(x', y')$ 可以通过以下旋转矩阵计算得到：

$$
\begin{pmatrix}
x' \\
y'
\end{pmatrix}
=
\begin{pmatrix}
\cos \theta & -\sin \theta \\
\sin \theta & \cos \theta
\end{pmatrix}
\begin{pmatrix}
x \\
y
\end{pmatrix}
$$

其中，旋转矩阵 $R$ 为：

$$
R = \begin{pmatrix}
\cos \theta & -\sin \theta \\
\sin \theta & \cos \theta
\end{pmatrix}
$$

##### 三维旋转矩阵

在三维空间中，旋转可以绕任意轴进行。常见的旋转轴包括 x 轴、y 轴和 z 轴。假设旋转角度为 $\theta$（逆时针方向），以下是绕三个主轴的旋转矩阵：

##### 绕 x 轴旋转

$$
R_x(\theta) = \begin{pmatrix}
1 & 0 & 0 \\
0 & \cos \theta & -\sin \theta \\
0 & \sin \theta & \cos \theta
\end{pmatrix}
$$

##### 绕 y 轴旋转

$$
R_y(\theta) = \begin{pmatrix}
\cos \theta & 0 & \sin \theta \\
0 & 1 & 0 \\
-\sin \theta & 0 & \cos \theta
\end{pmatrix}
$$

##### 绕 z 轴旋转

$$
R_z(\theta) = \begin{pmatrix}
\cos \theta & -\sin \theta & 0 \\
\sin \theta & \cos \theta & 0 \\
0 & 0 & 1
\end{pmatrix}
$$

##### 绕任意轴旋转

如果需要绕任意轴 $\mathbf{u} = (u_x, u_y, u_z)$ 旋转角度 $\theta$，可以使用罗德里格斯公式（Rodrigues' rotation formula）来构造旋转矩阵：

$$
R = I + (\sin \theta) K + (1 - \cos \theta) K^2
$$

其中，$I$ 是单位矩阵，$K$ 是反对称矩阵：

$$
K = \begin{pmatrix}
0 & -u_z & u_y \\
u_z & 0 & -u_x \\
-u_y & u_x & 0
\end{pmatrix}
$$

##### 示例

假设有一个点 $(1, 0, 0)$ 绕 z 轴旋转 $90^\circ$（逆时针方向），旋转后的点 $(x', y', z')$ 可以通过以下计算得到：


$$
\theta = 90^\circ = \frac{\pi}{2} \text{ 弧度}
$$

$$
R_z\left(\frac{\pi}{2}\right) = \begin{pmatrix}
\cos \frac{\pi}{2} & -\sin \frac{\pi}{2} & 0 \\
\sin \frac{\pi}{2} & \cos \frac{\pi}{2} & 0 \\
0 & 0 & 1
\end{pmatrix}
= \begin{pmatrix}
0 & -1 & 0 \\
1 & 0 & 0 \\
0 & 0 & 1
\end{pmatrix}
$$

$$
\begin{pmatrix}
x' \\
y' \\
z'
\end{pmatrix}
=
\begin{pmatrix}
0 & -1 & 0 \\
1 & 0 & 0 \\
0 & 0 & 1
\end{pmatrix}
\begin{pmatrix}
1 \\
0 \\
0
\end{pmatrix}
=
\begin{pmatrix}
0 \\
1 \\
0
\end{pmatrix}
$$

旋转后的点为 $(0, 1, 0)$。

#### 2.两个向量的点积

**点积的用途**
1. 计算两个向量之间的夹角：
2. 检测向量的方向：

### 参考资料
- [godot 4X shader docs](https://docs.godotengine.org/zh-cn/4.x/tutorials/shaders/index.html)