//
//  CustomViewControllerTransition.m
//  转场动画
//
//  Created by 霍文轩 on 15/10/30.
//  Copyright © 2015年 霍文轩. All rights reserved.
//

#import "PopTransition.h"
#import "ViewController.h"
#import "SecondViewController.h"

@interface PopTransition()
@end

@implementation PopTransition

// 指定动画的持续时长
- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext{
    return 0.5;
    
}
// 转场动画的具体内容
- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext{
    // 获取动画的源控制器和目标控制器
    SecondViewController * fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    ViewController * toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView * container = transitionContext.containerView;
    
    // 创建一个imageView的截图，并把原本imageView隐藏，造成以为移动的就是imageView的假象
    UIView * snapshotView = [fromVC.avatarImageView snapshotViewAfterScreenUpdates:NO];
    snapshotView.frame = [container convertRect:fromVC.avatarImageView.frame fromView:fromVC.view];
    fromVC.avatarImageView.hidden = YES;
    
    // 设置目标控制器的位置，并把透明度设为0，在后面的动画中慢慢显示出来变为1
    toVC.view.frame = [transitionContext finalFrameForViewController:toVC];
    toVC.sourceImageView.hidden = YES;
    
    // 都添加到container中。注意顺序
//    [container addSubview:toVC.view];
    [container insertSubview:toVC.view belowSubview:fromVC.view];
    [container addSubview:snapshotView];
    
    // 执行动画
    [UIView animateKeyframesWithDuration:[self transitionDuration:transitionContext] delay:0 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
        snapshotView.frame = toVC.sourceImageView.frame;
        fromVC.view.alpha = 0;
    } completion:^(BOOL finished) {
        toVC.sourceImageView.hidden = NO;
        [snapshotView removeFromSuperview];
        fromVC.avatarImageView.hidden = NO;
        
        //一定要记得动画完成后执行此方法，让系统管理 navigation
        [transitionContext completeTransition: ![transitionContext transitionWasCancelled]]; // 如果参数写成yes，当用户取消pop时，会继续执行动画，也就是让detailVC消失，设置成这个参数，会避免这样的错误
    }];
}
@end
