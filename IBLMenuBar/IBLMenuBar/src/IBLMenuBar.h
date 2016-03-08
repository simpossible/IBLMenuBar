//
//  IBLMenuBar.h
//  IBL
//
//  Created by simpossible on 16/1/11.
//  Copyright © 2016年 simpossible. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol IBLMenuBarDelegate <NSObject>
- (void)menuSelectedAtIndex:(NSInteger)index;

@end

@interface IBLMenuBar : UIView

/**
 *选中事件的代理
 */
@property(nonatomic, weak)id<IBLMenuBarDelegate>   delegate;

/**
 *@param items 通过一个字符数组确定每一个按钮的现实文字与个数，
 *@param height 这个menubar的高度
 */
- (instancetype)initWithItems:(NSArray*)items andControllers:(NSArray *)controllers andHeight:(float)height;

/**
 *@param添加viewController
 */
- (void)addMenuWithController:(UIViewController*)controller andMenuName:(NSString*)name;


/**
 *@param size 设置显示区域的大小 menuBar下面所对应的区域
 */
- (void)setContentSize:(CGSize)size;

/**
 *@param location 设置menuBar的origin
 */
- (void)setLocation:(CGPoint)location;
@end
