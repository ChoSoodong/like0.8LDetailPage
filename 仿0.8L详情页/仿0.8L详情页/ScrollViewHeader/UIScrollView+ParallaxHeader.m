//
//  UIScrollView+ParallaxHeader.m
//  AZWheel_ParallaxHeader
//
//  Created by 阿曌 on 17/8/6.
//  Copyright © 2017年 阿曌. All rights reserved.
//
#import <objc/runtime.h>
#import "UIScrollView+ParallaxHeader.h"

@implementation UIScrollView(ParallaxHeader)

//动态增加setter&getter
- (ParallaxHeader*)parallaxHeader {
    ParallaxHeader* parallaxHeader = objc_getAssociatedObject(self, @selector(parallaxHeader));
    if (!parallaxHeader) {
        parallaxHeader = [ParallaxHeader new];
        [self setParallaxHeader:parallaxHeader];
    } else {
        [parallaxHeader reset];
    }
    parallaxHeader.scrollView = self;
    return parallaxHeader;
}
- (void)setParallaxHeader:(ParallaxHeader *)parallaxHeader {
    objc_setAssociatedObject(self, @selector(parallaxHeader), parallaxHeader, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
@end
