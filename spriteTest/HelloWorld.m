//
//  HelloWorld.m
//  spriteTest
//
//  Created by Filiph Eriksson-Falk on 01/05/15.
//  Copyright (c) 2015 Filiph Eriksson-Falk. All rights reserved.
//

#import "HelloWorld.h"
#import "GameScene.h"

@interface HelloWorld ()
@property BOOL contentCreated;

@end

@implementation HelloWorld

- (void)didMoveToView: (SKView *) view
{
    [self.view presentScene:[[GameScene alloc] initWithSize:self.size]];
}

- (void)createSceneContents
{
    self.backgroundColor = [SKColor blueColor];
    self.scaleMode = SKSceneScaleModeAspectFit;
    [self addChild: [self newHelloNode]];
}

- (SKLabelNode *)newHelloNode
{
    SKLabelNode *helloNode = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    helloNode.name = @"helloNode";
    helloNode.text = @"Hello, World!";
    helloNode.fontSize = 42;
    helloNode.position = CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame));
    return helloNode;
}

- (void)touchesBegan:(NSSet *) touches withEvent:(UIEvent *)event
{
    SKNode *helloNode = [self childNodeWithName:@"helloNode"];
    if (helloNode != nil)
    {
        helloNode.name = nil;
        SKAction *moveUp = [SKAction moveByX: 0 y: 100.0 duration: 0.5];
        SKAction *zoom = [SKAction scaleTo: 2.0 duration: 0.25];
        SKAction *pause = [SKAction waitForDuration: 0.5];
        SKAction *fadeAway = [SKAction fadeOutWithDuration: 0.25];
        SKAction *remove = [SKAction removeFromParent];
        SKAction *moveSequence = [SKAction sequence:@[moveUp, zoom, pause, fadeAway, remove]];
        
        [helloNode runAction: moveSequence completion:^{
            SKScene *spaceshipScene  = [[GameScene alloc] initWithSize:self.size];
            SKTransition *doors = [SKTransition doorsOpenVerticalWithDuration:0.5];
            [self.view presentScene:spaceshipScene transition:doors];
        }];
    }
}
@end

