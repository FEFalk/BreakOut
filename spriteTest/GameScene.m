//
//  SpaceshipScene.m
//  spriteTest
//
//  Created by Filiph Eriksson-Falk on 01/05/15.
//  Copyright (c) 2015 Filiph Eriksson-Falk. All rights reserved.
//

#import "GameScene.h"
#import "GameOverScene.h"

static NSString* ballCategoryName = @"ball";
static NSString* paddleCategoryName = @"paddle";
static NSString* blockCategoryName = @"block";
static NSString* blockNodeCategoryName = @"blockNode";
static NSString* bottomCategoryName = @"bottom";

static const uint32_t ballCategory  = 0x1 << 0;  // 00000000000000000000000000000001
static const uint32_t bottomCategory = 0x1 << 1; // 00000000000000000000000000000010
static const uint32_t blockCategory = 0x1 << 2;  // 00000000000000000000000000000100
static const uint32_t paddleCategory = 0x1 << 3; // 00000000000000000000000000001000


@interface GameScene ()
-(void)speedCheck:(SKNode *)ball;
@property BOOL contentCreated;

@end



@implementation GameScene

- (void)didMoveToView:(SKView *)view
{
    if (!self.contentCreated)
    {
        [self createSceneContents];
        self.contentCreated = YES;
    }

}

- (void)createSceneContents
{
    [self startMyMotionDetect];
    
     self.physicsWorld.contactDelegate = self;
    // 1 Create a physics body that borders the screen
    SKPhysicsBody* borderBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
    // 2 Set physicsBody of scene to borderBody
    self.physicsBody = borderBody;
    // 3 Set the friction of that physicsBody to 0
    self.physicsBody.friction = 0.0f;
    
    SKSpriteNode* background = [SKSpriteNode spriteNodeWithImageNamed:@"bg.jpg"];
    background.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    [self addChild:background];
    
    self.physicsWorld.gravity = CGVectorMake(0.0f, 0.0f);
    


    SKSpriteNode *player = [self newPaddle];
    [self addChild:player];
    SKSpriteNode *ball = [self newBall];
    [self addChild:ball];
    [ball.physicsBody applyImpulse:CGVectorMake(1.0f, -22.0f)];

    // 1 Store some useful variables
    int numberOfBlocks = 10;
    int blockWidth = 100;
    float padding = 0.0f;
    int rowNumber = (int)(numberOfBlocks/5);
    // 2 Calculate the xOffset
    float xOffset = (self.frame.size.width - (blockWidth * numberOfBlocks/rowNumber + padding * (numberOfBlocks-1))) / 2;
    // 3 Create the blocks and add them to the scene
    for (int j = 1; j <= rowNumber; j++) {
        for (int i = 1; i <= numberOfBlocks/rowNumber; i++) {
            SKSpriteNode* block = [SKSpriteNode spriteNodeWithImageNamed:@"tileBlack_26"];
            block.size = CGSizeMake(100, 30);
            block.position = CGPointMake((i-0.5f)*block.frame.size.width + (i-1)*padding + xOffset, 900-j*30);
            block.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:block.size];
            block.physicsBody.allowsRotation = NO;
            block.physicsBody.dynamic=NO;
            block.physicsBody.friction = 0.0f;
            block.name = blockCategoryName;
            block.physicsBody.contactTestBitMask=ballCategory;
            block.physicsBody.categoryBitMask = blockCategory;
            
            [self addChild:block];
        }
    }
    
    SKNode *bottomRectCollider = [SKNode node];
    bottomRectCollider.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, 1)];
    
    bottomRectCollider.name=bottomCategoryName;
    bottomRectCollider.physicsBody.categoryBitMask=bottomCategory;
    bottomRectCollider.physicsBody.collisionBitMask=ballCategory;
    bottomRectCollider.physicsBody.contactTestBitMask=ballCategory;
    [self addChild:bottomRectCollider];
}

- (CMMotionManager *)motionManager
{
    CMMotionManager *motionManager = nil;
    
    id appDelegate = [UIApplication sharedApplication].delegate;
    
    if ([appDelegate respondsToSelector:@selector(motionManager)]) {
        motionManager = [appDelegate motionManager];
    }
    
    return motionManager;
}

- (void)startMyMotionDetect
{
    NSLog(@"Hello");
    float stepMoveFactor = 20;
    
    
    
    [self.motionManager
     startAccelerometerUpdatesToQueue:[[NSOperationQueue alloc] init]
     withHandler:^(CMAccelerometerData *data, NSError *error)
     {
         
         dispatch_async(dispatch_get_main_queue(),
                        ^{
                            SKNode *player = [self childNodeWithName:paddleCategoryName];
                            if ((player.position.x-player.frame.size.width/2 < 10 && data.acceleration.x > 0) ||
                                (player.position.x+player.frame.size.width/2 > self.frame.size.width-10 && data.acceleration.x < 0))
                            {
                                player.position = CGPointMake(player.position.x+data.acceleration.x*stepMoveFactor, player.position.y);
                            }
                            else if (player.position.x-player.frame.size.width/2 > 10 && player.position.x+player.frame.size.width/2 < self.frame.size.width-10)
                            {
                                player.position = CGPointMake(player.position.x+data.acceleration.x*stepMoveFactor, player.position.y);
                            }
                            
                        }
                        );
     }
     ];
    
}


-(void)update:(NSTimeInterval)currentTime
{
    SKNode* ball = [self childNodeWithName: ballCategoryName];
    static int maxSpeed = 1000;
    float speed = sqrt(ball.physicsBody.velocity.dx*ball.physicsBody.velocity.dx + ball.physicsBody.velocity.dy * ball.physicsBody.velocity.dy);
    if (speed > maxSpeed) {
        ball.physicsBody.linearDamping = 0.4f;
    } else {
        ball.physicsBody.linearDamping = 0.0f;
    }
    
    for (SKNode * node in self.children) {
        if (node.name==ballCategoryName) {
            if (node.physicsBody.velocity.dy<600.0f && node.physicsBody.velocity.dy>0.0f) {
                node.physicsBody.velocity=CGVectorMake(node.physicsBody.velocity.dx, 600.0f);
                NSLog(@"hejhej");
            }
            if (node.physicsBody.velocity.dy<0.0f && node.physicsBody.velocity.dy>-600.0f) {
                node.physicsBody.velocity=CGVectorMake(node.physicsBody.velocity.dx, -600.0f);
                NSLog(@"hejhej");
            }
        }
    }
}

-(BOOL)isGameWon
{
    int numberOfBricks = 0;
    for (SKNode * node in self.children) {
        if (node.name==blockCategoryName) {
            numberOfBricks++;
        }
    }
    return numberOfBricks <= 0;
}

-(void)speedCheck:(SKNode *)ball
{

    
}

-(void)didBeginContact:(SKPhysicsContact*)contact {
    // 1 Create local variables for two physics bodies
    SKPhysicsBody* firstBody;
    SKPhysicsBody* secondBody;
    // 2 Assign the two physics bodies so that the one with the lower category is always stored in firstBody
    if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask) {
        firstBody = contact.bodyB;
        secondBody = contact.bodyA;
    } else {
        firstBody = contact.bodyA;
        secondBody = contact.bodyB;
    }
    // 3 react to the contact between ball and bottom
    if (firstBody.node.name == ballCategoryName && secondBody.node.name == bottomCategoryName) {
        [self.motionManager stopAccelerometerUpdates];
        GameOverScene *gameOverScene = [[GameOverScene alloc] initWithSize:self.frame.size playerWon:NO];
        [self.view presentScene:gameOverScene];
    }
    if(firstBody.node.name == ballCategoryName && secondBody.node.name == blockCategoryName){
        [secondBody.node removeFromParent];
        if ([self isGameWon]) {
            [self.motionManager stopAccelerometerUpdates];
            GameOverScene *gameOverScene = [[GameOverScene alloc] initWithSize:self.frame.size playerWon:YES];
            [self.view presentScene:gameOverScene];
        }
    }
    
    if (firstBody.node.name == ballCategoryName) {
        [self speedCheck:firstBody.node];
    }
    
    if (firstBody.node.name == ballCategoryName && secondBody.node.name == paddleCategoryName) {
        [firstBody.node.physicsBody applyImpulse:CGVectorMake((firstBody.node.position.x-secondBody.node.position.x)/2, 0.0f)];
        NSLog(@"HejMackarena");
    }
}

-(SKSpriteNode *)newPaddle
{
    SKSpriteNode *player = [SKSpriteNode spriteNodeWithImageNamed:@"paddle_06.png"];
    player.size=CGSizeMake(150, 20);
    player.name = paddleCategoryName;
    
    player.physicsBody=[SKPhysicsBody bodyWithRectangleOfSize:player.size];
    player.physicsBody.categoryBitMask=paddleCategory;
    
    player.physicsBody.contactTestBitMask=ballCategory;
    
    player.physicsBody.restitution = 0.1f;
    player.physicsBody.friction = 0.4f;
    player.physicsBody.dynamic = NO;
    player.physicsBody.allowsRotation = NO;
    player.position=CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame)-450);
    
    return player;
}

- (SKSpriteNode *)newBall
{
    // 1
    SKSpriteNode* ball = [SKSpriteNode spriteNodeWithImageNamed: @"ballYellow_10.png"];
    ball.name = ballCategoryName;
    ball.size = CGSizeMake(30.0f, 30.0f);
    ball.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    ball.physicsBody.categoryBitMask=ballCategory;
    ball.physicsBody.contactTestBitMask = bottomCategory | blockCategory | paddleCategory;
    ball.physicsBody.collisionBitMask = bottomCategory;
    // 2
    ball.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:ball.frame.size.width/2];
    // 3
    ball.physicsBody.friction = 0.0f;
    // 4
    ball.physicsBody.restitution = 1.0f;
    // 5
    ball.physicsBody.linearDamping = 0.0f;
    // 6
    ball.physicsBody.allowsRotation = NO;
    
    return ball;
}


@end