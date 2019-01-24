//
//  ParallaxHeader.m
//  AZWheel_ParallaxHeader
//
//  Created by 阿曌 on 17/8/6.
//  Copyright © 2017年 阿曌. All rights reserved.
//

#import "ParallaxHeader.h"

@interface ParallaxHeader() {
    UIImageView* _bgImageView;
}

@end
@implementation ParallaxHeader

- (instancetype)init {
    if (self = [super init]) {
        _minimumHeight = 64;
        self.clipsToBounds = YES;
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}
- (void)reset {
    self.backgroundColor = [UIColor whiteColor];
    [_bgImageView removeFromSuperview];
    _bgImageView = nil;
}
#pragma mark - layout
- (void)layoutSubviews {
    
    CGFloat y = self.scrollView.contentInset.top + self.scrollView.contentOffset.y - _maxHeight;
    CGRect frame = (CGRect){
        .origin.x       = 0,
        .origin.y       = y,
        .size.width     = self.scrollView.frame.size.width,
        .size.height    = MAX(-y, _minimumHeight)
    };
    self.frame = frame;
    
    if (_bgImageView) {
        if (frame.size.height > self.maxHeight) {
            _bgImageView.frame = (CGRect){
                .origin.x       = 0,
                .origin.y       = 0,
                .size.width     = self.frame.size.width + (self.frame.size.height - self.maxHeight),
                .size.height    = self.frame.size.height
            };
        } else if (frame.size.height == self.maxHeight) {
            _bgImageView.frame = (CGRect){
                .origin.x       = 0,
                .origin.y       = 0,
                .size.width     = self.frame.size.width,
                .size.height    = self.frame.size.height
            };
        }
        
        _bgImageView.center = CGPointMake(frame.size.width/2, frame.size.height/2);
        
    }
    
    //set progress
    CGFloat distance = (_maxHeight - _minimumHeight)?:_maxHeight;
    self.progress = (frame.size.height - _minimumHeight) / distance;
}

- (void)adjustScrollViewTopInset:(CGFloat)top {
    UIEdgeInsets inset = self.scrollView.contentInset;
    
    //Adjust content offset (为了显示出来，inset和offset应该是相反数，比如inset.top = 30,offset.y = -30 才能显示出来上内边距)
    CGPoint offset = self.scrollView.contentOffset;
    offset.y += inset.top - top;
    self.scrollView.contentOffset = offset;
    
    //Adjust content inset
    inset.top = top;
    self.scrollView.contentInset = inset;
}

#pragma mark - kvo
static void * const kParallaxHeaderKVOContext = (void*)&kParallaxHeaderKVOContext;

- (void)willMoveToSuperview:(UIView *)newSuperview {
    if ([self.superview isKindOfClass:[UIScrollView class]]) {
        [self.superview removeObserver:self forKeyPath:@"contentOffset" context:kParallaxHeaderKVOContext];
    }
}
- (void)didMoveToSuperview { //被加载到新的父view中
    if ([self.superview isKindOfClass:[UIScrollView class]]) {
        [self.superview addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:kParallaxHeaderKVOContext];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if (context == kParallaxHeaderKVOContext &&
        [keyPath isEqualToString:@"contentOffset"]) {
        [self setNeedsLayout];
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}
#pragma mark -setter
- (void)setScrollView:(UIScrollView *)scrollView {
    if (_scrollView != scrollView) {
        _scrollView = scrollView;
        [_scrollView addSubview:self];
    }
}
- (void)setView:(UIView *)view {
    if (_view != view) {
        [_view removeFromSuperview];
        _view = view;
        [self addSubview:_view];
    }
}

- (void)setMaxHeight:(CGFloat)height {
    if (_maxHeight != height) {
        _maxHeight = height;
        [self adjustScrollViewTopInset:height];
    }
}

- (void)setProgress:(CGFloat)progress {
    if (_progress != progress) {
        _progress = progress;
        if ([self.delegate respondsToSelector:@selector(parallaxHeaderDidScroll:progress:)]) {
            [self.delegate parallaxHeaderDidScroll:self progress:progress];
        }
    }
}
- (void)setBgImage:(UIImage *)bgImage {
    if (_bgImage != bgImage) {
        _bgImage = bgImage;
        if (!_bgImageView) {
            _bgImageView = [[UIImageView alloc] initWithImage:bgImage];
            [self addSubview:_bgImageView];
            [self bringSubviewToFront:self.view];
        }
        _bgImageView.image = bgImage;
    }
}
@end
