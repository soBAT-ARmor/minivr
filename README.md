# minivr

面向 AR/VR 眼镜的轻量级实时渲染与位姿追踪系统（本科项目）。

## 环境

不需要装任何东西，你的机器上 Visual Studio 2022 已经自带全部工具链：

| 工具 | 位置 | 版本 |
|---|---|---|
| MSVC (cl.exe) | `C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Tools\MSVC\14.41.34120` | 14.41 |
| CMake | `...\Common7\IDE\CommonExtensions\Microsoft\CMake\CMake\bin\cmake.exe` | 3.29.5 |
| Ninja | `...\Common7\IDE\CommonExtensions\Microsoft\CMake\Ninja\ninja.exe` | 1.11 |
| Git | `...\Common7\IDE\CommonExtensions\Microsoft\TeamFoundation\Team Explorer\Git\cmd\git.exe` | 2.45.2 |

## 编译运行

```powershell
.\build.ps1
```

输出 `out.bmp`，用 Windows 照片直接打开。

## 用 git

```powershell
. .\dev.ps1        # 把 git / cmake 加进当前会话 PATH
git init
git add .
git commit -m "init: PPM/BMP output"
```

## 目录

```
minivr/
├── src/           # 源码
├── docs/
│   ├── devlog.md  # 每周记录
│   └── images/    # 每周截图归档
├── assets/        # 模型、纹理
├── build.ps1      # 一键编译运行
└── dev.ps1        # 载入 git / cmake
```

## 进度

- [x] M0 输出一张图
- [ ] M1 三角形光栅化 + z-buffer
- [ ] M2 纹理 + 光照
- [ ] M3 阴影
- [ ] M4 双目渲染 + 畸变校正
- [ ] M5 性能优化

## 笔记

开发日志见 `docs/devlog.md`。每次会话结束前必须写一条。
