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
            //拿出图片数据源
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
    let subClassScrollViewHeight : CGFloat = 188;
    //分类菜单模块曲线高度（建议固定值）
    let subClassScrollViewQuadCurveHeight : CGFloat = 30;
    //分类菜单pageControl
    var subClassPageControl : UIPageControl!
    let subClassPageControlHeight : CGFloat = 20;
    /*附近商家显示标签*/
    var nearByView : UIView!;
    let nearByViewHeight :CGFloat = 45;

    init() {
        super.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: bannerScrollViewHeight + subClassScrollViewHeight + subClassPageControlHeight-subClassScrollViewQuadCurveHeight/*减去曲线高度，因为要覆盖住上面轮播图这个高度*/ + nearByViewHeight));
        //轮播图
        bannerScrollView = SDCycleScrollView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: bannerScrollViewHeight), delegate: nil, placeholderImage: UIImage.init(named: ""));
        self.addSubview(bannerScrollView);
        bannerScrollView.backgroundColor = UIColor.yellow;
        bannerScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
        bannerScrollView.currentPageDotColor = UIColor.blue; // 自定义分页控件小圆标颜色
        bannerScrollView.autoScrollTimeInterval = 4.0;
        bannerScrollView.pageControlBottomOffset = 10;
        //轮播图pageControl
        
        /*分类菜单模块*/
        subClassScrollView = UIScrollView.init(frame: CGRect.init(x: 0, y: bannerScrollViewHeight - subClassScrollViewQuadCurveHeight/*减去曲线高度，因为要覆盖住上面轮播图这个高度*/, width: SCREEN_WIDTH, height: subClassScrollViewHeight));
        subClassScrollView.backgroundColor = UIColor.red;
        self.addSubview(subClassScrollView);
        subClassScrollView.isPagingEnabled = true;
        let bezierPath :UIBezierPath? = UIBezierPath();
        bezierPath?.move(to: CGPoint.zero);
        bezierPath?.addQuadCurve(to: CGPoint.init(x:subClassScrollView.frame.size.width, y:0), controlPoint: CGPoint.init(x:subClassScrollView.frame.size.width*0.5, y:subClassScrollViewQuadCurveHeight));
        bezierPath?.addLine(to: CGPoint.init(x: subClassScrollView.frame.size.width, y: subClassScrollView.frame.size.height))
        bezierPath?.addLine(to: CGPoint.init(x: 0, y: subClassScrollView.frame.size.height))
        bezierPath?.addLine(to: CGPoint.init(x: 0, y: 0))
        bezierPath?.close();
        
        let maskLayer :CAShapeLayer? = CAShapeLayer();
        maskLayer?.path = bezierPath?.cgPath;
        maskLayer?.fillColor = UIColor.white.cgColor;
        maskLayer?.frame = subClassScrollView.bounds;
        subClassScrollView.layer.mask = maskLayer;

        //分类菜单pageControl
        subClassPageControl = UIPageControl.init(frame: CGRect.init(x: 0, y: bannerScrollViewHeight + subClassScrollViewHeight  - subClassScrollViewQuadCurveHeight/*减去曲线高度，因为要覆盖住上面轮播图这个高度*/, width: SCREEN_WIDTH, height: subClassPageControlHeight));
        self.addSubview(subClassPageControl);
        subClassPageControl.isEnabled = false;
        subClassPageControl.numberOfPages = 3;
        subClassPageControl.pageIndicatorTintColor = UIColor.blue;
        subClassPageControl.currentPageIndicatorTintColor = UIColor.green;
        
        /*附近商家标签*/
        nearByView  = Bundle.main.loadNibNamed("IndexSectionHeaderView", owner: nil, options: nil)?.first as?UIView;
        nearByView.frame = CGRect.init(x: 0, y: bannerScrollViewHeight + subClassScrollViewHeight + subClassPageControlHeight - subClassScrollViewQuadCurveHeight/*减去曲线高度，因为要覆盖住上面轮播图这个高度*/, width: SCREEN_WIDTH, height: nearByViewHeight);
        self.addSubview(nearByView);
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
