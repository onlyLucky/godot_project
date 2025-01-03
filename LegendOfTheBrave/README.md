### 勇者传说 Godot 4.2

### 1. 初始化项目
1. 新创建项目，项目设置，勾选高级设置，设置窗口宽高覆盖为原本视口宽高度。将原本视口宽高度/3，更改拉伸模式为canvas_item。就能获取到三倍像素的像素游戏了。

游戏引擎： Godot 4.2.1
人物素材： https://brullov.itch.io/generic-char-asset
环境素材： https://anokolisa.itch.io/sidescroller-pixelart-sprites-asset-pack-forest-16x16
按键提示： https://greatdocbrown.itch.io/gamepad-ui
代码仓库： https://github.com/timothyqiu/godot-2d-adventure-tutorial
字体素材： https://www.bilibili.com/video/BV1sP411g7PZ
音效素材： https://www.kenney.nl/assets/impact-sounds https://leohpaz.itch.io/minifantasy-dungeon-sfx-pack
音乐素材： https://sonatina.itch.io/infinity-crystal


### 打包流程

#### android

注意事项

1. **生成密钥库**：
   打开命令提示符（CMD）并导航到java JDK的`bin`目录，然后使用以下命令生成密钥库文件：

   ```shell
   keytool -keyalg RSA -genkeypair -alias androiddebugkey -keypass android -keystore debug.keystore -storepass android -dname "CN=Android Debug,O=Android,C=US" -validity 9999
   ```

   在这个命令中：
   - `-keyalg RSA` 指定密钥算法为RSA。
   - `-genkeypair` 生成密钥对。
   - `-alias androiddebugkey` 设置别名为`androiddebugkey`。
   - `-keypass android` 设置密钥密码为`android`。
   - `-keystore debug.keystore` 指定密钥库文件名为`debug.keystore`，保存在当前目录下面。
   - `-storepass android` 设置密钥库密码为`android`。
   - `-dname` 设置密钥的DName属性。
   - `-validity 9999` 设置密钥的有效期限为9999天。

2. 配置JAVA_HOME 环境变量