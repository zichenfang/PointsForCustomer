//
//  IndexHeaderView.swift
//  PointsForCustomer
//
//  Created by 殷玉秋 on 2017/9/15.
//  Copyright © 2017年 fff. All rights reserved.
//

import UIKit

class IndexHeaderView: UIView {
    //轮播图
    var bannerScrollView : SDCycleScrollView!
    //轮播图高度
    let bannerScrollViewHeight :CGFloat = SCREEN_WIDTH * (1/2.0);
    //轮播图pageControl
    var bannerPageControl : UIPageControl!
    //轮播图图片数据源
    var _bannerDatas :NSArray?
    var bannerDatas :NSArray?{
        set{
            _bannerDatas = newValue;
            let bannerImages : NSMutableArray? = NSMutableArray();
            for  abanner in  bannerDatas! {
                let bannerObj : PPBannerObject! = abanner as! PPBannerObject;
                bannerImages?.add(bannerObj.imageUrl ?? "默认图");
            }
            bannerScrollView.imageURLStringsGroup = bannerImages as! [Any];
        }
        get{
            return _bannerDatas;
        }
    };
    //轮播图代理
    var _delegate :SDCycleScrollViewDelegate?
    var delegate :SDCycleScrollViewDelegate?{
        set{
            _delegate = newValue;
            bannerScrollView.delegate = delegate;
        }
        get{
            return _delegate;
        }
    }


    //分类菜单模块
    var subClassScrollView : UIScrollView!
    //分类菜单模块高度（建议固定值）
    let subClassScrollViewHeight : CGFloat = 100;
    //分类菜单pageControl
    var subClassPageControl : UIPageControl!
    let subClassPageControlHeight : CGFloat = 20;

    init() {
        super.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: bannerScrollViewHeight + subClassScrollViewHeight + subClassPageControlHeight));
        //轮播图
        bannerScrollView = SDCycleScrollView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: bannerScrollViewHeight), delegate: nil, placeholderImage: UIImage.init(named: ""));
        self.addSubview(bannerScrollView);
        bannerScrollView.backgroundColor = UIColor.yellow;
        bannerScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
        bannerScrollView.currentPageDotColor = UIColor.blue; // 自定义分页控件小圆标颜色
        bannerScrollView.autoScrollTimeInterval = 4.0;
//        print(bannerDatas ?? []);


//        bannerScrollView.imageURLStringsGroup = ["https://images2017.cnblogs.com/news/24442/201709/24442-20170906183359226-1435856414.jpg",
//                                                 "https://images2017.cnblogs.com/news/24442/201709/24442-20170906183359226-1435856414.jpg",
//                                                 "https://images2017.cnblogs.com/news/24442/201709/24442-20170906183359226-1435856414.jpg"];

        //轮播图pageControl
        
        //分类菜单模块
        subClassScrollView = UIScrollView.init(frame: CGRect.init(x: 0, y: bannerScrollViewHeight, width: SCREEN_WIDTH, height: subClassScrollViewHeight));
        subClassScrollView.backgroundColor = UIColor.red;
        self.addSubview(subClassScrollView);
        subClassScrollView.isPagingEnabled = true;
        //分类菜单pageControl
        subClassPageControl = UIPageControl.init(frame: CGRect.init(x: 0, y: bannerScrollViewHeight + subClassScrollViewHeight, width: SCREEN_WIDTH, height: subClassPageControlHeight));
        self.addSubview(subClassPageControl);
        subClassPageControl.isEnabled = false;
        subClassPageControl.numberOfPages = 3;
        subClassPageControl.pageIndicatorTintColor = UIColor.blue;
        subClassPageControl.currentPageIndicatorTintColor = UIColor.green;
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
