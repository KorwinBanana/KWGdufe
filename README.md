# KWGdufe
面向**广东财经大学在校学生**的iOS平台APP
连通学校各类信息系统，拥有查询课表、查询图书借阅、查询成绩等多种校园服务功能。

*项目进度：*
（任务：继续增加新功能和优化已完成的功能）
2017.11.4：**1.增加自动计算当前学期和计算大一到大四的八个学期的方法 2.已经增加选择各个学期课程表功能**
2017.11.5: **1.增加，选择查看课程表，当前周或其他周所对应的课程 2.以简单适配iPhone X 3.增加校园卡余额显示 4.增加校园卡余额查询的缓存逻辑：有网络连接的时候，网络请求并更新本地数据；无网络连接的时候，直接使用本地数据**

做了简单的本地缓存处理，应用NSUserDefaults存储请求的课表数据等数据。

* 课表展示界面（基本完成，补充：增加选择课表和设置周几）(**增加点击课程加载课程详细信息界面**)

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

**选择各学期的课程表**（点击导航栏右按钮，选择学期；点击左按钮，选择周期）

![image](https://github.com/KorwinBanana/KWGdufe/blob/master/READMEImage/%E9%80%89%E6%8B%A9%E5%90%84%E4%B8%AA%E5%AD%A6%E6%9C%9F%E8%AF%BE%E7%A8%8B%E8%A1%A8.png)

**选择个周的课程表**

![image](https://github.com/KorwinBanana/KWGdufe/blob/master/READMEImage/%E9%80%89%E6%8B%A9%E5%91%A8%E6%9C%9F%E7%9A%84%E8%AF%BE%E7%A8%8B%E8%A1%A8.png)

* 快捷功能界面（自定义tableViewCell，里面用collectionView实现每个cell中有不同的功能,通过代理方式，实现collectionViewCell点击跳转到相应页面）

![image](https://github.com/KorwinBanana/KWGdufe/blob/master/READMEImage/%E5%8A%9F%E8%83%BD%E7%95%8C%E9%9D%A2.png)

成绩信息（应用Masnory做了自动布局，展示成绩，下一步增加选择对应学期的成绩的功能)
![image](https://github.com/KorwinBanana/KWGdufe/blob/master/READMEImage/%E6%88%90%E7%BB%A9%E4%BF%A1%E6%81%AF.png)

素拓信息（基本完成)
![image](https://github.com/KorwinBanana/KWGdufe/blob/master/READMEImage/%E7%B4%A0%E6%8B%93%E4%BF%A1%E6%81%AF.png)

当前借阅信息（基本完成，需要再优化）
![image](https://github.com/KorwinBanana/KWGdufe/blob/master/READMEImage/%E5%BD%93%E5%89%8D%E5%80%9F%E9%98%85%E7%95%8C%E9%9D%A2.png)

历史借阅信息（基本完成，需要再优化）
![image](https://github.com/KorwinBanana/KWGdufe/blob/master/READMEImage/%E5%8E%86%E5%8F%B2%E5%80%9F%E9%98%85.png)

宿舍电费查询界面 （基本完成界面搭建）

![image](https://github.com/KorwinBanana/KWGdufe/blob/master/READMEImage/%E7%94%B5%E8%B4%B9%E6%9F%A5%E8%AF%A2.png)

* 我 界面（完成加载个人信息数据并展示，以及跳转至信息页面，**增加校园卡余额展示**）

![image](https://github.com/KorwinBanana/KWGdufe/blob/master/READMEImage/%E4%B8%AA%E4%BA%BA%E7%95%8C%E9%9D%A2.png)

**今日交易界面**

![image](https://github.com/KorwinBanana/KWGdufe/blob/master/READMEImage/%E4%BB%8A%E6%97%A5%E4%BA%A4%E6%98%93.png)

* 个人信息界面

![image](https://github.com/KorwinBanana/KWGdufe/blob/master/READMEImage/%E5%B1%8F%E5%B9%95%E5%BF%AB%E7%85%A7%202017-10-30%20%E4%B8%8A%E5%8D%881.04.18.png)

![image](https://github.com/KorwinBanana/KWGdufe/blob/master/READMEImage/%E9%80%89%E6%8B%A9%E6%97%A5%E6%9C%9F.png)

* 登陆（实现登陆功能（**使用Keychain存储账号密码**），界面待完善,添加密码错误警告提示,**使用AES给密码加密保存**）

![image](https://github.com/KorwinBanana/KWGdufe/blob/master/READMEImage/%E7%99%BB%E5%BD%95%E7%95%8C%E9%9D%A2%EF%BC%88%E5%B0%9A%E6%9C%AA%E7%BE%8E%E5%8C%96%EF%BC%89.png)



