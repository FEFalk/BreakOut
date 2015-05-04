//
//  ViewController.m
//  spriteTest
//
//  Created by Filiph Eriksson-Falk on 01/05/15.
//  Copyright (c) 2015 Filiph Eriksson-Falk. All rights reserved.
//

#import "ViewController.h"
#import <SpriteKit/SpriteKit.h>
#import "GameScene.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewWillAppear:(BOOL)animated
{
    GameScene *scene1 = [[GameScene alloc] initWithSize:CGSizeMake(768,1024)];
    SKView *spriteView = (SKView *) self.view;
    [spriteView presentScene: scene1];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    SKView *spriteView = (SKView *) self.view;
    spriteView.showsDrawCount = YES;
    spriteView.showsNodeCount = YES;
    spriteView.showsFPS = YES;
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
