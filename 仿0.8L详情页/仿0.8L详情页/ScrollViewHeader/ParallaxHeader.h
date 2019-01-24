//
//  ParallaxHeader.h
//  AZWheel_ParallaxHeader
//
//  Created by 阿曌 on 17/8/6.
//  Copyright © 2017年 阿曌. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ParallaxHeader;
@protocol ParallaxHeaderDelegate <NSObject>
- (void)parallaxHeaderDidScroll:(ParallaxHeader *)parallaxHeader progress:(CGFloat)progress;
@end

@interface ParallaxHeader : UIView
@property (nonatomic,weak) UIScrollView *scrollView; //宿主
@property (nonatomic,readonly)CGFloat progress;
//provide for out
@property (nonatomic,strong) UIView *view; //想要显示的view
@property (nonatomic) CGFloat minimumHeight; //最小高度，默认为64（导航栏高度）
@property (nonatomic) CGFloat maxHeight; //设定正常时的高度（不是跟随滑动变化的）
@property (nonatomic,weak)id<ParallaxHeaderDelegate> delegate;
@property (nonatomic,strong)UIImage *bgImage; //背景图片

- (void)reset;
@end
