# flutter_app

开发动机来自学习Google的通用开发组件（见项目ComponentsLearn），后来需要后台数据支持，又开始学习Ruby on Rails
（rails_demo_post），搭好基本的服务框架后，发现Google新推出的flutter很适合这种小项目，于是又开始了flutter的学习
，学习资料主要来自https://flutterchina.club/的相关翻译文章，非常感谢。

学习的过程也遇到了不少坑，比如dio支持beta版本，但是不支持master版本，后来统一更换成自带的http框架
还有早期在使用sqlite时遇到各种问题，自己不理解await的含义，造成了代码的各种冗余，（当然，现在重构也还未完毕）。当然更新至此 也算是一个
学习段落了，这个Free Feed已经基本成型。

## 现有的不足：
### 1.未找到类似eventbus类型的工具，登录状态的通知不够及时
### 2.图片加载貌似有点问题，如果网络断了再开 需要推出app才能显示图片
### 3.有时候键盘弹起需要几秒钟的时间
### 4.性能 内存占用还未测试

## 学习到的内容
### 1.各种UI显示，通用UI的公用
### 2.mvp，复杂页面交给presenter来代理，统一的数据仓库，
### 3.toaster、image_picker、SharePreferences、sqflite插件的使用
### 4.发送图片，网络请求，json，dialog解析等待页面
### 5.页面跳转，跳转 返回 传参数




## Getting Started

需要flutter版本切换成master，因为beta版的TextFiled有个致命问题，很多底部的布局在软键盘打开的适合会被遮挡

iOS的调试模式 会有点问题，build之后 数据库的位置会发生变化，导致openData的时候会报错，release版本不会这样，所以 如果使用的是iOS模拟器或者真机，打包前先删除原有app即可
（安卓没有这个问题）

后台服务需要自己run，项目地址是https://github.com/robotwai/rails_demo_post
注册账号使用的是邮箱验证，但是邮箱需要借助smtp服务，可以直接在rails的数据库里把账号的activated状态更改为true即可


