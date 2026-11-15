# 岁时

干净的节气农历文化日历。看公历、农历、二十四节气和传统节日。不做宜忌、运势和吉凶判断，也不放广告。

应用显示名暂定为「岁时」，还不是商店里的最终名字。工程标识是 `app.suishi.calendar`。

## 最低系统版本

**iOS 17。** 只做 iPhone。

小组件是这款应用的主界面之一。从 iOS 17 起，WidgetKit 要求用 `containerBackground` 绘制小组件背景，再往前兼容就要维持两套小组件代码。StoreKit 2 到 iOS 17 也已经稳定。写这个骨架的时候是 2026 年 11 月，iOS 17 已经发布三年，仍覆盖日常在用的机型。再把最低版本放到 iOS 16 或更早，省不下什么用户，却会把小组件和购买层拆成两支。

## 在没有 Mac 的情况下看结果

仓库是公开的。GitHub 托管的 macOS 运行器对公开仓库免费，不需要租云 Mac，也不需要本机安装 Xcode。

1. 打开本仓库的 **Actions**。
2. **CI** 在每次推送和每个拉取请求上运行：用 XcodeGen 生成工程，在 iOS 模拟器里编译应用和小组件，并跑单元测试。绿色勾表示通过。点进某一次运行可以看编译和测试日志。
3. **Screenshots** 会在拉取请求上跑一次。以后要再看界面，在 Actions 里选中 Screenshots，右侧 **Run workflow** 手动运行。它会启动模拟器、打开应用，并把截图上传为构建产物。
4. 打开某一次 Screenshots 运行，页面底部的 **Artifacts** 里有四份截图：
   - `screenshot-home`：2026-06-21 夏至的首页
   - `screenshot-month`：2026 年 6 月的月历
   - `screenshot-about`：关于页，含人工智能标识和字体许可
   - `screenshot-widgets`：小、中两款小组件的预览

截图把日期固定在 2026 年 6 月 21 日，所以每次看到的都是夏至，而不是运行当天。

模拟器编译不签名，现在不需要 Apple 开发者账号。

## 本地生成工程

工程描述在 `project.yml`，用 [XcodeGen](https://github.com/yonaskolb/XcodeGen) 生成 `Suishi.xcodeproj`。生成物不入库，避免和 `project.yml` 各写一套。

```bash
brew install xcodegen
xcodegen generate
```

然后用 Xcode 打开 `Suishi.xcodeproj`。运行方案已经挂上 `Config/Configuration.storekit`，可以在模拟器里测试 25 元的非消耗型商品。这个文件只供本地测试，App Store Connect 里还没有正式商品。

## 插画文件

成稿放在 `App/Resources/Illustrations/`，文件名是拼音，图里不要写字。应用按这个名字找图，找不到就用 `placeholder.png`。

已经放好的三张：

| 文件 | 节气 |
| --- | --- |
| `lichun.png` | 立春 |
| `xiazhi.png` | 夏至 |
| `dongzhi.png` | 冬至 |

其余 32 张按下面的文件名丢进同一目录，再运行一次 `xcodegen generate` 即可。目录是 Xcode 的 folder reference，生成工程时会整夹带走。

节气 24 个：`lichun` `yushui` `jingzhe` `chunfen` `qingming` `guyu` `lixia` `xiaoman` `mangzhong` `xiazhi` `xiaoshu` `dashu` `liqiu` `chushu` `bailu` `qiufen` `hanlu` `shuangjiang` `lidong` `xiaoxue` `daxue` `dongzhi` `xiaohan` `dahan`

节日 11 个（清明与节气共用 `qingming.png`，不再单独占一个名字）：`chunjie` `chuxi` `yuanxiao` `duanwu` `qixi` `zhongyuan` `zhongqiu` `chongyang` `laba` `beifangxiaonian` `nanfangxiaonian`

`placeholder.png` 是脚本画的素纸，不是节气成稿。重新生成：

```bash
python3 scripts/make-placeholder-art.py
```

## 字体

节气名使用思源宋体简体区域子集 **Source Han Serif CN**（与 Noto Serif CJK 是同一套字体），许可是 SIL Open Font License 1.1。许可全文在 `Licenses/OFL-SourceHanSerif.txt`，应用「关于」里也能打开。

嵌入的是裁过的子集 `App/Resources/Fonts/JieqiSong-Regular.otf`。OFL 把 **Source** 定为保留名称，改过的字体不能再叫 Source，所以程序里的字体名是 **Jieqi Song**。字体不单独出售。

要从上游字体重新裁字：

```bash
python3 scripts/subset-font.py /path/to/SourceHanSerifCN-Regular.otf
```

上游压缩包：<https://github.com/adobe-fonts/source-han-serif/releases/download/2.003R/14_SourceHanSerifCN.zip> 里的 `SubsetOTF/CN/SourceHanSerifCN-Regular.otf`。

## 历法库

使用 [lunar-swift 1.1.9](https://github.com/6tail/lunar-swift)（MIT，Copyright (c) 2023 6tail），通过 Swift Package Manager 按精确版本引入。它带有 Package.swift，可以在应用和小组件里直接调用，不必再包一层 JavaScript。

代码只使用公历、农历、节气和本应用列出的传统节日。不调用宜忌、八字、佛历、道历或吉神方位。许可全文在 `Licenses/LunarSwift-MIT.txt`。

交节时刻和「今天」都按北京时间（`Asia/Shanghai`）计算，不跟设备时区走。界面上写明这是用来读物候的，不是择日依据。库本身按「现状」提供，不附带官方认证；单元测试用若干已公布的日期做对照，例如 2026 年夏至是 6 月 21 日、农历五月初七。

## 这一版有什么，还没有什么

有：首页（当天公历、农历、当前节气和插画）、月历（农历日、节气、传统节日）、小和中两款小组件、关于页、StoreKit 2 购买层和本地测试配置、节气与农历的单元测试。

还没有：法定假日和调休、通知、大号月历小组件、第二套插画、真正的 App Store 商品。购买按钮在模拟器里读得到本地配置时才能点；点了也不会换上第二套图，因为那套图还没画。

## 买了每年 99 美元的 Apple Developer Program 之后

现在这条流水线只做模拟器编译和测试，不签名。加入付费开发者计划、并且要 TestFlight 或上架时，再改这几处。会费之外不要把证书写进仓库。

1. **签名。** 把开发者团队 ID、证书（`.p12`）和描述文件放进仓库的 Actions Secrets。流水线里把 `CODE_SIGNING_ALLOWED=NO` 换成正式签名，归档时指定这个团队。公开仓库的 macOS 运行器仍然免费；密钥只能走 Secrets，不能出现在日志或源码里。
2. **上传 TestFlight。** 在 App Store Connect 生成 API 密钥（Issuer ID、Key ID、`.p8`），同样放进 Secrets。可以用 `xcodebuild archive` 打出 ipa，再用 `xcrun altool` 或 App Store Connect API 上传；也可以用 fastlane 的 `pilot`。两条路都能跑在现在的 macOS 运行器上，不必另租云 Mac。
3. **内购。** 在 App Store Connect 创建非消耗型商品，产品 ID 用 `app.suishi.theme.premium`，价格 25 元人民币。`Config/Configuration.storekit` 继续只给模拟器测试，代替不了正式商品。免费下载和农历、节气查阅保持不变，付费只解锁第二套插画和进阶小组件。
