//
//  ImageBrowserVC.h
//  WhaleShop
//
//  Created by 殷玉秋 on 2017/10/22.
//  Copyright © 2017年 HeiziTech. All rights reserved.
//


#import <UIKit/UIKit.h>
//屏幕宽高
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
@interface ImageBrowserVC : UIViewController
@property(nonatomic,strong)NSArray *links;
@property(nonatomic,assign)NSInteger currentIndex;

//links :只需要是图片的链接就行，不需要转化成url
- (id)initWithLinks :(NSArray *)links CurrentIndex:(NSInteger)index;
- (void)show;
@end
