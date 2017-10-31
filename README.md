# KWGdufe
面向**广东财经大学在校学生**的iOS平台APP
连通学校各类信息系统，拥有查询课表、查询图书借阅、查询成绩等多种校园服务功能。

*项目进度：*

做了简单的本地缓存处理，应用NSUserDefaults存储请求的课表数据等数据。

* 课表展示界面（基本完成，补充：增加选择课表和设置周几）

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

![image](https://github.com/KorwinBanana/KWGdufe/blob/master/READMEImage/%E8%AF%BE%E7%A8%8B%E8%A1%A8%E9%A1%B5%E9%9D%A2%EF%BC%88%E5%BE%85%E5%AE%8C%E5%96%84%E5%85%B6%E4%BB%96%E5%8A%9F%E8%83%BD%EF%BC%89.png)

* 快捷功能界面（自定义tableViewCell，里面用collectionView实现每个cell中有不同的功能,通过代理方式，实现collectionViewCell点击跳转到相应页面）

![image](https://github.com/KorwinBanana/KWGdufe/blob/master/READMEImage/%E5%8A%9F%E8%83%BD%E7%95%8C%E9%9D%A2.png)

成绩信息（展示成绩，下一步增加选择对应学期的成绩的功能)
![image](https://github.com/KorwinBanana/KWGdufe/blob/master/READMEImage/%E6%88%90%E7%BB%A9%E4%BF%A1%E6%81%AF%EF%BC%88%E6%9C%AA%E6%8A%8A%E6%95%B0%E6%8D%AE%E5%AE%8C%E5%85%A8%E5%B1%95%E7%A4%BA%EF%BC%89.png)

素拓信息（未把数据完全展示，下一步自定义cell展示素拓详细信息)
![image](https://github.com/KorwinBanana/KWGdufe/blob/master/READMEImage/%E7%B4%A0%E6%8B%93%E4%BF%A1%E6%81%AF%EF%BC%88%E6%9C%AA%E6%8A%8A%E6%95%B0%E6%8D%AE%E5%AE%8C%E5%85%A8%E5%B1%95%E7%A4%BA%EF%BC%89.png)

* 我 界面（完成加载个人信息数据并展示，以及跳转至信息页面）

![image](https://github.com/KorwinBanana/KWGdufe/blob/master/READMEImage/%E4%B8%AA%E4%BA%BA%E7%95%8C%E9%9D%A2.png)

* 个人信息界面

![image](https://github.com/KorwinBanana/KWGdufe/blob/master/READMEImage/%E5%B1%8F%E5%B9%95%E5%BF%AB%E7%85%A7%202017-10-30%20%E4%B8%8A%E5%8D%881.04.18.png)

* 登陆（实现登陆功能（**使用Keychain存储账号密码**），界面待完善,添加密码错误警告提示,**使用AES给密码加密保存**）

![image](https://github.com/KorwinBanana/KWGdufe/blob/master/READMEImage/%E7%99%BB%E5%BD%95%E7%95%8C%E9%9D%A2%EF%BC%88%E5%B0%9A%E6%9C%AA%E7%BE%8E%E5%8C%96%EF%BC%89.png)



