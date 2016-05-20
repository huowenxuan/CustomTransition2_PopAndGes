//
//  SecondViewController.m
//  转场动画
//
//  Created by 霍文轩 on 15/10/30.
//  Copyright © 2015年 霍文轩. All rights reserved.
//

#import "PopTransition.h"
#import "PushTransition.h"
#import "SecondViewController.h"

@interface SecondViewController () <UINavigationControllerDelegate>
@property (nonatomic, retain) UIPercentDrivenInteractiveTransition * percentDrivenTransition;

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor cyanColor];
    
    // 加入左侧边界手势
    UIScreenEdgePanGestureRecognizer * edgePan = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(edgePanGesture:)];
    edgePan.edges = UIRectEdgeLeft;
    [self.view addGestureRecognizer:edgePan];
    
    self.avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 66+5, self.view.frame.size.width - 10, 300)];
    [self.view addSubview:_avatarImageView];

}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.navigationController.delegate = self;
}
// 在手势监听方法中，创建UIPercentDrivenInteractiveTransition属性，并实现手势百分比更新
- (void)edgePanGesture:(UIScreenEdgePanGestureRecognizer *)edgePan{
    // 进度值，这是左侧边界的算法，如果要改为右侧边界，改为self.view.bounds.size.width / [edgePan translationInView:self.view].x;
    CGFloat progress = [edgePan translationInView:self.view].x / self.view.bounds.size.width;
    if (edgePan.state == UIGestureRecognizerStateBegan) {
        self.percentDrivenTransition = [[UIPercentDrivenInteractiveTransition alloc] init];
        [self.navigationController popViewControllerAnimated:YES];
        
    }else if(edgePan.state == UIGestureRecognizerStateChanged){
        [self.percentDrivenTransition updateInteractiveTransition:progress];
    }else if(edgePan.state == UIGestureRecognizerStateCancelled || edgePan.state == UIGestureRecognizerStateEnded){
        if(progress > 0.5){
            [self.percentDrivenTransition finishInteractiveTransition];
        }else{
            [self.percentDrivenTransition cancelInteractiveTransition];
        }
        self.percentDrivenTransition = nil;
    }
}

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC{
    if (operation == UINavigationControllerOperationPop){
        return [[PopTransition alloc] init]; // 返回pop动画的类
    }else{
        return nil;
    }
}
- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController{
    if([animationController isKindOfClass:[PopTransition class]]){
        return self.percentDrivenTransition;
    }else{
        return nil;
    }
}
@end
