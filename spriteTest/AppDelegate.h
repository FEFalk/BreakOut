//
//  AppDelegate.h
//  spriteTest
//
//  Created by Filiph Eriksson-Falk on 01/05/15.
//  Copyright (c) 2015 Filiph Eriksson-Falk. All rights reserved.
//

#import <UIKit/UIKit.h>
@import CoreMotion;
@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    CMMotionManager *motionManager;
}
@property (readonly) CMMotionManager *motionManager;
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UIViewController *viewController;

@end

