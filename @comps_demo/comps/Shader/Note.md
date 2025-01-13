## Shader

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