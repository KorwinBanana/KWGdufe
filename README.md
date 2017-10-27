# KWGdufe
面向**广东财经大学在校学生**的iOS平台APP
连通学校各类信息系统，拥有查询课表、查询图书借阅、查询成绩等多种校园服务功能。

*项目进度*(界面布局尚未优化，主要是实现功能)

* 基本完成课表展示界面（基本完成，补充：增加选择课表和设置周几）

```
/*
问题：直接生成格子，会产生大量格子UIView对象，会造成整个APP卡顿。
解决：
1. 先定义一个UIView容器：bgImageView.
2. 在UIView容器：bgImageView中生成格子.
3. 最后把bgImageView截图生成image保存到背景UIImageView里的Image中,并保持清晰度。
4. 最后把UIView容器：bgImageView中的所有UIView格子对象移除掉。
 */
 
```

![image](https://github.com/KorwinBanana/KWGdufe/blob/master/READMEImage/%E8%AF%BE%E8%A1%A8%E7%95%8C%E9%9D%A2.png)

* 快捷功能（自定义tableViewCell，里面用collectionView实现每个cell中有不同的功能,通过代理方式，实现collectionViewCell点击跳转到相应页面）

![image](https://github.com/KorwinBanana/KWGdufe/blob/master/READMEImage/%E5%BF%AB%E6%8D%B7%E5%8A%9F%E8%83%BD%E7%95%8C%E9%9D%A2.png)

* 个人（完成加载个人信息数据并展示，以及跳转至信息页面）

![image](https://github.com/KorwinBanana/KWGdufe/blob/master/READMEImage/%E6%88%91%E7%9A%84%E7%95%8C%E9%9D%A2.png)

* 登陆（实现登陆功能，界面待完善,添加密码错误警告提示,**使用AES给密码加密保存**）

![image](https://github.com/KorwinBanana/KWGdufe/blob/master/READMEImage/%E7%99%BB%E9%99%86%E7%95%8C%E9%9D%A2%EF%BC%88%E7%AE%80%E5%8D%95%EF%BC%89.png)


* 个人信息

![image](https://github.com/KorwinBanana/KWGdufe/blob/master/READMEImage/%E5%B1%8F%E5%B9%95%E5%BF%AB%E7%85%A7%202017-10-16%20%E4%B8%8B%E5%8D%8811.35.46.png)



