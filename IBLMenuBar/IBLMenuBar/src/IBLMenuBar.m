//
//  IBLMenuBar.m
//  IBL
//
//  Created by simpossible on 16/1/11.
//  Copyright © 2016年 simpossible. All rights reserved.
//

#import "IBLMenuBar.h"

#define  lineHeight  3

@interface IBLMenuBar ()<UIScrollViewDelegate>
@property(nonatomic, assign)float   height;
@property(nonatomic, assign)float   widht;
@property(nonatomic, assign)float   widthPerMenu;


@property(nonatomic, strong)NSArray * items;
@property(nonatomic, strong)NSMutableArray * views; //menubar 的按钮

@property(nonatomic, strong)NSMutableArray * viewControllers; //menuBar 所对应的controller

@property(nonatomic, assign)NSInteger     selectedIndex;

@property(nonatomic, strong)UIView * line;

@property(nonatomic, strong)UIScrollView * contentView;

@property(nonatomic, assign)CGSize   contentSize;

@property(nonatomic, assign)BOOL   buttonScroll;//是否是button控制的滚动
@end

@implementation IBLMenuBar

- (instancetype)initWithItems:(NSArray *)items andControllers:(NSArray *)controllers andHeight:(float)height{
    if (self = [super init]) {
        
        self.items = [NSMutableArray arrayWithArray:items];
        
        self.views = [NSMutableArray array];
        self.viewControllers = [NSMutableArray arrayWithArray:controllers];
        
        self.height = height;
        self.widht = [[UIScreen mainScreen] bounds].size.width;
        [self setBounds:CGRectMake(0, 0, _widht, height)];
        _selectedIndex = 0;
        _buttonScroll = NO;
        self.contentView = nil;
    }
    
    [self setBackgroundColor:[UIColor whiteColor]];
    [self initialViews];
    [self initialLine];
    return self;
}


- (void)initialLine{
    self.line = [[UIView alloc]initWithFrame:CGRectMake(0, _height-lineHeight, _widthPerMenu, lineHeight)];
    [self.line setBackgroundColor:[UIColor colorWithRed:59.0/255 green:173.0/255 blue:1 alpha:1]];
    
    [[self.views objectAtIndex:0]setSelected:YES];
    [self addSubview:self.line];
}



- (void)initialViews{
    //menubar button
    [self initialMenuButton];
    
    //content view
    //    [self initialContentView];
}
- (void)initialMenuButton{
    if (!self.items) {
        return;
    }
    
    float width = [[UIScreen mainScreen] bounds].size.width;
    _widthPerMenu = width / self.items.count;
    
    for (NSString *item in self.items) {
        
        NSInteger index = [self.items indexOfObject:item];
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(index*_widthPerMenu, 0, _widthPerMenu, _height-lineHeight)];
        
        [self addSubview: button];
        [self.views addObject:button];
        [button setBackgroundColor:[UIColor whiteColor]];
        
        if ([item isKindOfClass:[NSString class]]) {
            [button setTitle:item forState:UIControlStateNormal];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor colorWithRed:59.0/255 green:173.0/255 blue:1 alpha:1] forState:UIControlStateSelected];
        }else{
            NSLog(@"视频会议:menuBar 出现无效值");
            [button setTitle:@"" forState:UIControlStateNormal];
        }
        
        [button setTag:index];
        [button addTarget:self action:@selector(buttonDidSelected:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)initialContentView{
    self.contentView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, _height, _contentSize.width, _contentSize.height)];
    [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height + _contentSize.height)];
    [self.contentView setPagingEnabled:YES];
    self.contentView.delegate = self;
    [self.contentView setContentSize:CGSizeMake(self.viewControllers.count*_widht, _contentSize.height)];
    [self addSubview:self.contentView];
    
    for (UIViewController *vc in self.viewControllers) {
        NSInteger index = [self.viewControllers indexOfObject:vc];
        [vc.view setFrame:CGRectMake(index*_widht, 0, _widht, _contentSize.height)];
        [self.contentView addSubview:vc.view];
    }
    
}

- (void)buttonDidSelected:(UIButton*)sender{
    _buttonScroll = YES;
    for (UIButton *button in self.views) {
        [button setSelected:NO];
    }
    [sender setSelected:YES];
    [self moveLineToIndex:sender.tag];
    if ([self.delegate respondsToSelector:@selector(menuSelectedAtIndex:)]) {
        [self.delegate menuSelectedAtIndex:sender.tag];
    }
    _buttonScroll = NO;
}

- (void)moveLineToIndex:(NSInteger)index{
    if (index == _selectedIndex) {
        return;
    }
    
    _selectedIndex = index;
    float centerX = [(UIView*)[self.views objectAtIndex:index] center].x;
    CGPoint newCenter = CGPointMake(centerX, self.line.center.y);
    typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.27471 animations:^{
        [weakSelf.line setCenter:newCenter];
    }];
    
    
    [self.contentView setContentOffset:CGPointMake(index*_widht, 0) animated:YES];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, _height-1)];
    [[UIColor grayColor]setStroke];
    [path addLineToPoint:CGPointMake(self.frame.size.width, _height-1)];
    [path setLineWidth:0.2];
    [path stroke];
}

#pragma mark 外部接口 -

- (void)setLocation:(CGPoint)location{
    [self setFrame:CGRectMake(location.x, location.y, self.frame.size.width, self.frame.size.height)];
}

- (void)setContentSize:(CGSize)size{
    _contentSize = size;
    [self initialContentView];
}

- (void)addMenuWithController:(UIViewController *)controller andMenuName:(NSString *)name{
    
}

#pragma mark 代理 -
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (_buttonScroll) {
        return;
    }else{
        NSInteger viewNumber = self.views.count;
        float xOff = scrollView.contentOffset.x;
        float percent = xOff/(_widht*viewNumber);
        [self.line setCenter:CGPointMake(_widht*percent + _widthPerMenu/2, self.line.center.y)];
    }
    
}

-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (!_buttonScroll) {
        int page = scrollView.contentOffset.x/_widht;
        for (UIButton *button in self.views) {
            [button setSelected:NO];
            if (button.tag == page) {
                button.selected = YES;
            }
        }
        
        //    [self moveLineToIndex:page];
        if (page == _selectedIndex) {
            return;
        }
        
        _selectedIndex = page;
        float centerX = [(UIView*)[self.views objectAtIndex:page] center].x;
        CGPoint newCenter = CGPointMake(centerX, self.line.center.y);
        typeof(self) weakSelf = self;
        [UIView animateWithDuration:0.27471 animations:^{
            [weakSelf.line setCenter:newCenter];
        }];
    }
    
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
}
@end
