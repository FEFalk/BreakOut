//
//  SpaceshipScene.h
//  spriteTest
//
//  Created by Filiph Eriksson-Falk on 01/05/15.
//  Copyright (c) 2015 Filiph Eriksson-Falk. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
@import CoreMotion;

@interface GameScene : SKScene<SKPhysicsContactDelegate>
{
    CMMotionManager *_manager;
    NSTimer *timer;
}
@end
