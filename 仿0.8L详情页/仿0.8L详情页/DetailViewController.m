//
//  DetailViewController.m
//  仿0.8L详情页
//
//  Created by xialan on 2019/1/24.
//  Copyright © 2019 ZHAO. All rights reserved.
//

#import "DetailViewController.h"
#import "UIScrollView+ParallaxHeader.h"

#define KWidth self.view.bounds.size.width
#define KHeight self.view.bounds.size.height


#define KBottomView_H 60

@interface DetailViewController ()<UITableViewDelegate,
                                    UITableViewDataSource,
                                    ParallaxHeaderDelegate>

/** 导航栏 */
@property (nonatomic, strong) UIView *naviView;

/** tableView */
@property (nonatomic, strong) UITableView *tableView;

/** 轮播 */
@property (nonatomic, strong) UIScrollView *cycleScrollView;
/** 分页指示器 */
@property (nonatomic, strong) UIPageControl *pageControl;

/** datasource */
@property (nonatomic, strong) NSArray *imagesArray;

/** 留言 */
@property (nonatomic, strong) UIView *bottomView;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _imagesArray = @[
                     @"000.jpeg",
                     @"001.jpeg",
                     @"002.jpeg",
                     @"003.jpeg"
                     
                     ];
   
    //导航栏透明
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    
    [self.view addSubview:self.tableView];
    [self showAZZ:self.tableView];
    [self.view addSubview:self.bottomView];
    
    [self configNavigationBar];
    
}
#pragma mark - 导航栏
-(void)configNavigationBar{
    
    _pageControl = [[UIPageControl alloc] init];
    _pageControl.userInteractionEnabled = NO;
    _pageControl.currentPage = 0;
    _pageControl.numberOfPages = self.imagesArray.count;
    
    self.navigationItem.titleView = _pageControl;
}

- (void)showAZZ:(UITableView *)tableView {
    
    tableView.parallaxHeader.view = self.cycleScrollView;
    tableView.parallaxHeader.maxHeight = KHeight;
    tableView.parallaxHeader.minimumHeight = 64;
    tableView.parallaxHeader.delegate = self;
}

#pragma mark - ParallaxHeaderDelegate
-(void)parallaxHeaderDidScroll:(ParallaxHeader *)parallaxHeader progress:(CGFloat)progress {
    //    CGFloat h = parallaxHeader.view.frame.size.height;
    //    CGFloat w = parallaxHeader.view.frame.size.width;
    //    CGFloat currentH = parallaxHeader.frame.size.height;
    //    parallaxHeader.view.frame = CGRectMake(0, 20, w/h*(currentH-20), (currentH - 20));
    //    parallaxHeader.view.center = CGPointMake(parallaxHeader.center.x, (currentH + 20)/2);
    
}

#pragma mark - cell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
    
}
#pragma mark - cell数量
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    //导航栏默认会给tableView加64的inset
    UIEdgeInsets inset = tableView.contentInset;
    inset.top = KHeight;
    tableView.contentInset = inset;
    
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 50;
}

#pragma mark - 每个cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellid" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellid"];
    }
    //cell颜色
    cell.backgroundColor = [UIColor whiteColor];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.textLabel.text = @(indexPath.row).description;
    return cell;
    
}

#pragma mark - section头部间距
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.0001;
    
}
#pragma mark - section头部视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 1)];
    view.backgroundColor = [UIColor whiteColor];
    return view;
    
}
#pragma mark - section底部间距
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.0001;
}
#pragma mark - section底部视图
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, KWidth, 1)];
    view.backgroundColor = [UIColor whiteColor];
    return view;
}


#pragma mark - 监听滚动
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat offsetY = scrollView.contentOffset.y;
    
    
    if (scrollView == self.tableView) {
        
        if(offsetY < -KHeight) {
            
            //图片下拉放大
            UIImageView *imgV = self.cycleScrollView.subviews[self.pageControl.currentPage];
            [self scaleView:imgV offset:offsetY page:self.pageControl.currentPage];
            
        }
        
    }
    
    
}

#pragma mark - 监听scrollView滚动结束
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    if (scrollView == self.cycleScrollView) {
        
        CGFloat contentOffsetX = scrollView.contentOffset.x;
        
        CGFloat page =  (CGFloat)(int)(contentOffsetX / KWidth);
        self.pageControl.currentPage = page;
    }
    
}

#pragma mark - 下拉放大方法
-(void)scaleView:(UIView *)scaleView offset:(CGFloat)offset page:(NSInteger)page{
    
    CGFloat height = KHeight;
    CGRect rect = scaleView.frame;
    rect.size.height = height - (offset+KHeight)*2;
    rect.size.width = KWidth* (height - (offset+KHeight)*2)/height;
    rect.origin.x = -(rect.size.width - KWidth) / 2 +page*KWidth;
    rect.origin.y = offset+KHeight;
    
    CGRect cycleFrame = self.cycleScrollView.frame;
    cycleFrame.origin.y = 0;
    cycleFrame.size.height = height - (offset+KHeight)*2;
    self.cycleScrollView.frame = cycleFrame;
    
    scaleView.frame = rect;
    
}


#pragma mark - 懒加载
-(UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        //cell 留言
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellid"];
        
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, KBottomView_H, 0);
    }
    return _tableView;
}

/**
 轮播图片
 */
-(UIScrollView *)cycleScrollView{
    if (_cycleScrollView == nil) {
        
        _cycleScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, KWidth,KHeight)];
        
        _cycleScrollView.delegate = self;
        _cycleScrollView.pagingEnabled = YES;
        _cycleScrollView.showsVerticalScrollIndicator = NO;
        _cycleScrollView.showsHorizontalScrollIndicator = NO;
        _cycleScrollView.bounces = NO;
        
       
        
        for (NSInteger i = 0; i < _imagesArray.count; i++) {
            
            UIImageView *imgView = [[UIImageView alloc] init];
            imgView.image = [UIImage imageNamed:_imagesArray[i]];
            
            imgView.frame = CGRectMake(i*KWidth, 0, KWidth, KHeight);
            imgView.userInteractionEnabled = YES;
            [_cycleScrollView addSubview:imgView];
            
        }
        
        [_cycleScrollView setContentSize:CGSizeMake(_imagesArray.count*KWidth, 0)];
        
    }
    return _cycleScrollView;
}

-(UIView *)bottomView{
    if (_bottomView == nil) {
        
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, KHeight-KBottomView_H, KWidth, KBottomView_H)];
        _bottomView.backgroundColor = [UIColor orangeColor];
        _bottomView.alpha = 0.5;
    }
    return _bottomView;
}


@end
