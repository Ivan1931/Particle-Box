//
//  Calculator.m
//  Particle Box
//
//  Created by Jonah Hooper on 2013/03/26.
//  Copyright (c) 2013 Jonah Hooper. All rights reserved.
//

#import "Calculator.h"

#define swap_(a, b) do{ __typeof__(a) tmp;  tmp = a; a = b; b = tmp; }while(0)
@implementation Calculator


@synthesize currentNodeType;
@synthesize data;
@synthesize particles;
@synthesize node;

-(id) initWithData:(GLfloat *)pdata andDimesions:(Vec2)xy {
    self = [super init];
    if (self) {
        dims = xy;
        data = pdata;
        particles = [[NSMutableArray alloc] init];
        frameNumber = 0;
        reset = false;
        tail = false;
        whirls = false;
        currentNodeType = 0;
        screenCenter = VEC2(dims.x / 2.f, dims.y / 2.f);
        [self spawnParticles];
    }
    return self;
}

-(void) calculate:(CADisplayLink *)link {
    NSLog(@"Calculating");
    for (int p = 0; p < particles.count; p++) {
        Particle* local = [particles objectAtIndex:p];
        if (node != nil)
            [node influenceParticle:local];
        [local move];
        [self renderParticle:local];
        if (reset){
            if(local.position.x <= 0) { 
                local.position = (Vec2){dims.x, local.position.y};
                [local resetVelocity];
            }
            else if (local.position.x >= dims.x) {
                local.position = (Vec2) {0.f,local.position.y};
                [local resetVelocity];
            }
            if (local.position.y <= 0) {
                local.position = (Vec2) {local.position.x, dims.y};
                [local resetVelocity];
            } else if (local.position.y >= dims.y) {
                local.position = (Vec2){local.position.x, 0.f};
                [local resetVelocity];
            }
        }
        
    }
    [node update];
}

#pragma mark - render
-(void) renderParticle:(Particle*)particle{
    float normCurrX = (particle.position.x - screenCenter.x) / screenCenter.x;
    float normCurrY = -(particle.position.y - screenCenter.y) / screenCenter.y;
    float normPrevX = (particle.previousPosition.x - screenCenter.x) / screenCenter.x;
    float normPrevY = -(particle.previousPosition.y - screenCenter.y) / screenCenter.y;
    data[particle.getDataIndex] = normCurrX;
    data[particle.getDataIndex + 1] = normCurrY;
    data[particle.getDataIndex + 2] = normPrevX;
    data[particle.getDataIndex + 3] = normPrevY;
}


void swap(int *a,int *b){
    int *temp = b;
    b = a;
    a = temp;
}

-(void) spawnParticles {
    for (int p = 0; p < 3000; p++){
        
        Vec2 pos = {
            .x = [Calculator randFloatBetween:0.f and:dims.x],
            .y = [Calculator randFloatBetween:0.f and:dims.y]
        };
        float w = [Calculator randFloatBetween:200 and:255];
        Color col = {
          w,w,w
        };
        Particle *part = [[Particle alloc] initWith:pos Color:col atDataIndex:p * 4];
        [particles addObject:part];
    }
    NSLog(@"Dimsx and y: %f, %f",dims.x / 2,dims.y / 2);
    [self spawnRose];
    //[self spawnGraviton];
    //[self spawnWhirl];
    //[self spawnRibbon];
    //[self spawnBackShot];
    //[self spawnNode];
    //[self createSuction:5];
    //[self spawnSpiral];
    //[self spawnSwirl];
    //[self spawnRepulsion];
}

-(void) spawnBackShot {
    node = [[BackShot alloc] initWithStrength:10.f Suction:3.f Position:VEC2(dims.x / 2, dims.y / 2) dimesions:dims];
}

-(void) spawnRose {
    node = [[Rose alloc] initWithStrength:2.f Suction:2.f Position:VEC2 (dims.x / 2, dims.y / 2) dimesions:dims];
}

-(void) spawnGraviton {
    node = [[Graviton alloc] initWithStrength:10.f Suction:3.f Position:(Vec2){dims.x / 6, dims.y / 6} dimesions:dims];
}

-(void) spawnWhirl {
    node = [[Whirl alloc] initWithStrength:15.f Suction:3.f Position:(Vec2){dims.x / 6, dims.y / 6} Clockwise:TRUE screenDimesions:dims];
    
}

-(void) spawnRibbon {
    node = [[Ribbon alloc] initWithStrength:10.f Suction:0.f Position:VEC2(dims.x/4, dims.y / 4 ) dimesions:dims];
}

-(void) spawnNode {
    node = [[ForceNode alloc] initWithStrength:2.f Suction:1.f Position:VEC2(dims.x / 2, dims.y / 2) dimesions:dims];
}


-(void) spawnSpiral {
    node = [[Spirals alloc] initWithStrength:20.f Suction:2.f Position:VEC2(dims.x / 2, dims.y / 2) dimesions:dims];
}

-(void) spawnSwirl {
    node = [[Swirl alloc] initWithStrength:10.f Suction:2.f Position:VEC2(dims.x / 2, dims.y / 2) dimesions:dims];
}

-(void) spawnRepulsion {
    node = [[Repulsion alloc] initWithStrength:10.f Suction:3.f Position:VEC2(dims.x / 2, dims.y / 2) dimesions:dims];
}

-(void) spawnSuction {
    node = [[Suction alloc] initWithStrength:10.f Suction:3.f Position:VEC2(dims.x/ 2.f, dims.y / 2.f) dimesions:dims];
}

-(void) spawnExtraInternalNodes:(int)number {
    int screen_divisor = number + 1;
    for (int i = 0; i < number; i++) {
        [node addNode:VEC2((i + 2) * dims.x / screen_divisor , (i + 2) * dims.y / screen_divisor)];
    }
}

-(void) setForceNode:(int)nodeNumber {
    currentNodeType = nodeNumber;
    NodeList nodeList = [node getNodeList];
    switch (nodeNumber) {
        case BACK_SHOT:
            [self spawnBackShot];
            break;
        case RIBBON:
            [self spawnRibbon];
            break;
        case GRAVITON:
            [self spawnGraviton];
            break;
        case SPIRALS:
            [self spawnSpiral];
            break;
        case REPULSION:
            [self spawnRepulsion];
            break;
        case SWIRL:
            [self spawnSwirl];
            break;
        case SUCTION:
            [self spawnSuction];
            break;
        case WHIRL:
            [self spawnWhirl];
            break;
        case ROSE:
            [self spawnRose];
            break;
        default:
            [self spawnNode];
            break;
    }
    [node addNodeList:nodeList];

}

#pragma mark - move gravity

-(void) moveGravity:(CGPoint)xy {
    [node moveNode:(Vec2){xy.x, xy.y}];
}

+(float) randFloatBetween:(float)low and:(float)high {
    float diff = high - low;
    return (((float) rand() / RAND_MAX) * diff) + low;
}

@end
