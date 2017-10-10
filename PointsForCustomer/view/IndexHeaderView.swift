//
//  IndexHeaderView.swift
//  PointsForCustomer
//
//  Created by 殷玉秋 on 2017/9/15.
//  Copyright © 2017年 fff. All rights reserved.
//

import UIKit

class IndexHeaderView: UIView ,UIScrollViewDelegate {
   //    MARK: /*轮播图*/
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
//    MARK:/*分类菜单模块*/
    var subClassBackView : UIView!
    //分类菜单模块背景view高度（建议固定值）
    let subClassBackViewHeight : CGFloat = 185;

    var subClassScrollView : UIScrollView!
    //分类菜单模块高度（建议固定值）
    let subClassScrollViewHeight : CGFloat = 150;
    //分类菜单模块曲线高度（建议固定值）
    let subClassBackViewQuadCurveHeight : CGFloat = 15;
    //分类菜单pageControl
    var subClassPageControl : UIPageControl!
    let subClassPageControlHeight : CGFloat = 20;
    //分类菜单点击回掉
    var classSelectedHandler : ((_ item : PPIndexClassObj) -> Void)?
    //分类数据源
    var _subClassDatas :NSMutableArray?
    var subClassDatas :NSMutableArray?{
        set{
            if _subClassDatas == nil{
                _subClassDatas = NSMutableArray.init();
            }
            else{
                _subClassDatas?.removeAllObjects();
            }
            //清除上次add的view
            for pageView in subClassScrollView.subviews {
                pageView.removeFromSuperview();
            }
            if (newValue?.count)!<=0 {
                return;
            }
            //10个为一组，重新处理数据，组成二维数组
            var index = 0;
            while index < (newValue?.count)! {
                //页码下标
                let page = index/10;
                //该页码下标对应的子数组
                var classesInPage :NSMutableArray?
                //如果不存在该页码下标对应的子数组，则初始化
                if (_subClassDatas?.count)! < page + 1 {
                    classesInPage = NSMutableArray.init();
                    _subClassDatas?.add(classesInPage!)
                }
                else{
                    classesInPage = _subClassDatas?.object(at: page) as? NSMutableArray;
                }
                classesInPage?.add(newValue?.object(at: index) ?? PPIndexClassObj.init(info: [:]));
                index = index + 1;
            }
            
            //10个为一组，循环铺设view
            var page = 0
//            let subclassItemHeight = subClassScrollViewHeight * 0.5//item高度
            while page < (_subClassDatas?.count)! {
                let pageView : UIView? = UIView.init(frame: CGRect.init(x: CGFloat(page) * SCREEN_WIDTH, y: 0, width: SCREEN_WIDTH, height: subClassScrollViewHeight))
                subClassScrollView.addSubview(pageView!);
                pageView?.tag = page;
                //取出一页的数据
                let classesInPage : NSMutableArray? = _subClassDatas?.object(at: page) as? NSMutableArray;
                var index = 0;
                let itemWidth :CGFloat = SCREEN_WIDTH/5;
                let itemHeight :CGFloat = subClassScrollViewHeight/2;
                //在pageView上面铺设itemView
                while index < (classesInPage?.count)! {
                    //取出一页当中的一条数据
                    let classObj :PPIndexClassObj! = classesInPage?.object(at: index) as! PPIndexClassObj;
                    let itemView : IndexClassItemView? = Bundle.main.loadNibNamed("IndexClassItemView", owner: nil, options: nil)?.first as! IndexClassItemView?
                    itemView?.tag = index;
                    let item_x :CGFloat = CGFloat(index%5) * itemWidth;
                    let item_y :CGFloat = CGFloat(index/5) * itemHeight;

                    itemView?.frame = CGRect.init(x: item_x, y: item_y, width: itemWidth, height: itemHeight);
                    pageView?.addSubview(itemView!)
                    itemView?.nameLabel.text = classObj?.name;
                    itemView?.imgView.sd_setImage(with: URL.init(string: (classObj?.imageUrl!)!), placeholderImage: PLACE_HOLDER_IMAGE_GENERAL);
                    // MARK:分类点击动作
                    itemView?.btn.addTarget(self, action: #selector(classItemDidSelected), for: UIControlEvents.touchUpInside)
                    index = index + 1;
                }
                page = page + 1;
            }
            //设置pageSize
            subClassScrollView.contentSize = CGSize.init(width: SCREEN_WIDTH * CGFloat((subClassDatas?.count)!), height: 0);
            //设置pageControl
            subClassPageControl.numberOfPages = (subClassDatas?.count)!
            subClassPageControl.currentPage = 0;
            
        }
        get{
            return _subClassDatas;
        }
    }
    //    MARK:/*附近商家显示标签*/
    var nearByView : UIView!;
    let nearByViewHeight :CGFloat = 45;

    init() {
        super.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: bannerScrollViewHeight + subClassBackViewHeight + subClassPageControlHeight-subClassBackViewQuadCurveHeight/*减去曲线高度，因为要覆盖住上面轮播图这个高度*/ + nearByViewHeight));
        //轮播图
        bannerScrollView = SDCycleScrollView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: bannerScrollViewHeight), delegate: nil, placeholderImage: UIImage.init(named: ""));
        self.addSubview(bannerScrollView);
        bannerScrollView.backgroundColor = UIColor.yellow;
        bannerScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
        bannerScrollView.currentPageDotColor = UIColor.styleRed(); // 自定义分页控件小圆标颜色
        bannerScrollView.pageDotColor = UIColor.darkGray; //
        bannerScrollView.autoScrollTimeInterval = 4.0;
        bannerScrollView.pageControlBottomOffset = 10;
        bannerScrollView.bannerImageViewContentMode = UIViewContentMode.scaleAspectFill;
        bannerScrollView.placeholderImage = PLACE_HOLDER_IMAGE_GENERAL
        //轮播图pageControl
        
        /*分类菜单模块*/
        subClassBackView = UIView.init(frame: CGRect.init(x: 0, y: bannerScrollViewHeight - subClassBackViewQuadCurveHeight, width: SCREEN_WIDTH, height: subClassBackViewHeight));
        self.addSubview(subClassBackView);
        subClassBackView.backgroundColor = UIColor.white;
        
        let bezierPath :UIBezierPath? = UIBezierPath();
        bezierPath?.move(to: CGPoint.zero);
        bezierPath?.addQuadCurve(to: CGPoint.init(x:subClassBackView.frame.size.width, y:0), controlPoint: CGPoint.init(x:subClassBackView.frame.size.width*0.5, y:subClassBackViewQuadCurveHeight));
        bezierPath?.addLine(to: CGPoint.init(x: subClassBackView.frame.size.width, y: subClassBackView.frame.size.height))
        bezierPath?.addLine(to: CGPoint.init(x: 0, y: subClassBackView.frame.size.height))
        bezierPath?.addLine(to: CGPoint.init(x: 0, y: 0))
        bezierPath?.close();
        
        let maskLayer :CAShapeLayer? = CAShapeLayer();
        maskLayer?.path = bezierPath?.cgPath;
        maskLayer?.fillColor = UIColor.white.cgColor;
        maskLayer?.frame = subClassBackView.bounds;
        subClassBackView.layer.mask = maskLayer;
        
        
        
        subClassScrollView = UIScrollView.init(frame: CGRect.init(x: 0, y: subClassBackViewHeight - subClassScrollViewHeight, width: SCREEN_WIDTH, height: subClassScrollViewHeight));
        subClassBackView.addSubview(subClassScrollView);
        subClassScrollView.delegate = self;
        subClassScrollView.isPagingEnabled = true;
        subClassScrollView.showsHorizontalScrollIndicator = false;


        //分类菜单pageControl
        subClassPageControl = UIPageControl.init(frame: CGRect.init(x: 0, y: bannerScrollViewHeight + subClassBackViewHeight  - subClassBackViewQuadCurveHeight/*减去曲线高度，因为要覆盖住上面轮播图这个高度*/, width: SCREEN_WIDTH, height: subClassPageControlHeight));
        self.addSubview(subClassPageControl);
        subClassPageControl.isEnabled = false;
        subClassPageControl.numberOfPages = 3;
        subClassPageControl.pageIndicatorTintColor = UIColor.darkGray;
        subClassPageControl.currentPageIndicatorTintColor = UIColor.styleRed();
        
        /*附近商家标签*/
        nearByView  = Bundle.main.loadNibNamed("IndexSectionHeaderView", owner: nil, options: nil)?.first as?UIView;
        nearByView.frame = CGRect.init(x: 0, y: bannerScrollViewHeight + subClassBackViewHeight + subClassPageControlHeight - subClassBackViewQuadCurveHeight/*减去曲线高度，因为要覆盖住上面轮播图这个高度*/, width: SCREEN_WIDTH, height: nearByViewHeight);
        self.addSubview(nearByView);
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == subClassScrollView {
            subClassPageControl.currentPage = NSInteger(subClassScrollView.contentOffset.x/SCREEN_WIDTH);
        }
    }
    @objc func classItemDidSelected(sender:UIButton?)  {
        //取出一页的数据
        let classesInPage : NSMutableArray? = _subClassDatas?.object(at: (sender?.superview?.superview?.tag)!) as? NSMutableArray;
        //取出一页当中的一条数据
        let classObj :PPIndexClassObj! = classesInPage?.object(at: (sender?.superview?.tag)!) as! PPIndexClassObj;
        if classSelectedHandler != nil{
            classSelectedHandler!(classObj);
        }

    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
