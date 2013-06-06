//
//  Calculator.m
//  Particle Box
//
//  Created by Jonah Hooper on 2013/03/26.
//  Copyright (c) 2013 Jonah Hooper. All rights reserved.
//

#import "Calculator.h"

#define FADE_RATE 10
#define ipart_(X) ((int)(X))
#define round_(X) ((int)(((double)(X))+0.5))
#define fpart_(X) (((double)(X))-(double)ipart_(X))
#define rfpart_(X) (1.0-fpart_(X))
#define swap_(a, b) do{ __typeof__(a) tmp;  tmp = a; a = b; b = tmp; }while(0)
@implementation Calculator


@synthesize currentNodeType;
@synthesize data;
@synthesize particles;
@synthesize node;

-(id) initWithData:(unsigned char *)pdata andDimesions:(Vec2)xy {
    self = [super init];
    if (self) {
        dims = xy;
        bytesPerRow = (xy.x * BITSPERCOMPONENT * BYTESPERPIXEL + 7) / 8;
        data = pdata;
        particles = [[NSMutableArray alloc] init];
        frameNumber = 0;
        reset = false;
        tail = false;
        whirls = false;
        currentNodeType = 0;
        [self spawnParticles];
    }
    return self;
}

-(void) calculate:(CADisplayLink *)link {
    //NSLog(@"Calculating");
    [self clearRaster];
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

-(void) clearRaster {
    int maxBytes = (bytesPerRow * (dims.y - 1)) + (dims.x - 1) * BYTESPERPIXEL;
    if (tail) {
        for (int i = 0; i < maxBytes; i+=4) {
            //if (data[i] > 3) data[i]-=3;
            for (int j = i; j < i + 3; j++){
                if (data[j] > FADE_RATE)
                    data[j]-=FADE_RATE;
            }
            if (data[maxBytes + 2] > FADE_RATE)
                    data[maxBytes + 2] -= FADE_RATE;
        }
    } else {
        for (int i = 0; i < maxBytes; i+=4) {
            data[i] = 0;
            data[i + 1] = 0;
            data [i + 2] = 0;
            data[i + 3] = 0;
        }
    }
    //NSLog(@"Max Bytes %d",maxBytes);
}

#pragma mark - render
-(void) renderParticle:(Particle*)particle{
    //[self renderPixelatX:particle.position.x atY:particle.position.y withColor:particle.color];
    [self draw_line_antialiasAt:[particle position] :[particle previousPosition] withColor:[particle color]];
}

-(void) renderPixelatX:(int)x atY:(int)y withColor:(Color)col {
    if (x >= 0 && x < dims.x - 6){
        if (y >= 0 && y < dims.y - 6){
            int byteIndex = 4 * x + bytesPerRow * y;
            
            //[self averageBlendAtIndex:byteIndex withColor:col];
            [self maxBlendAtIndex:byteIndex withColor:col];
        }
    }
}

-(void) averageBlendAtIndex:(int) index withColor:(Color) color {
    data[index] = averageBlend(data[index], color.r);
    data[index + 1] = averageBlend(data[index + 1], color.g);
    data[index + 2] = averageBlend(data[index + 2], color.b);
}

-(void) maxBlendAtIndex:(int) index withColor:(Color) color {
    data[index] = MAX(data[index], color.r);
    data[index + 1] = MAX(data[index + 1], color.g);
    data[index + 2] = MAX(data[index + 2], color.b);
}

Byte averageBlend (Byte a, Byte b) {
    return MAX((a + b)/2, 255);
}

void swap(int *a,int *b){
    int *temp = b;
    b = a;
    a = temp;
}

-(void) spawnParticles {
    for (int p = 0; p < 2000; p++){
        
        Vec2 pos = {
            .x = [Calculator randFloatBetween:0.f and:dims.x],
            .y = [Calculator randFloatBetween:0.f and:dims.y]
        };
        float w = [Calculator randFloatBetween:200 and:255];
        Color col = {
          w,w,w
        };
        Particle *part = [[Particle alloc] initWith:pos andColor:col];
        [particles addObject:part];
    }
    NSLog(@"Dimsx and y: %f, %f",dims.x / 2,dims.y / 2);
    //[self spawnRose];
    //[self spawnGraviton];
    //[self spawnWhirl];
    //[self spawnRibbon];
    //[self spawnBackShot];
    //[self spawnNode];
    //[self createSuction:5];
    //[self spawnSpiral];
    [self spawnSwirl];
    //[self spawnRepulsion];
}

-(void) spawnBackShot {
    node = [[BackShot alloc] initWithStrength:10.f Suction:3.f Position:VEC2(dims.x / 2, dims.y / 2) dimesions:dims];
}

-(void) spawnRose {
    node = [[Rose alloc] initWithStrength:2.f Suction:2.f Position:VEC2 (dims.x / 2, dims.y / 2) dimesions:dims];
}

-(void) spawnGraviton {
    node = [[Graviton alloc] initWithStrength:15.f Suction:3.f Position:(Vec2){dims.x / 6, dims.y / 6} dimesions:dims];
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

-(void) plotPointWithColor:(Color) col brightness:(float)br atX:(int)x atY:(int)y{
    col.r = MIN(255, (Byte)(float)col.r * br * 1.1f);
    col.g = MIN(255, (Byte)(float)col.g * br * 1.1f);
    col.b = MIN(255, (Byte)(float)col.b * br * 1.1f);
    [self renderPixelatX:x atY:y withColor:col];
}

-(void) draw_line_antialiasAt:(Vec2) a :(Vec2)b withColor:(Color)col {
    double dx = (double)a.x - (double)b.x;
    double dy = (double)a.y - (double)b.y;
    if ( fabs(dx) > fabs(dy) ) {
        if ( b.x < a.x ) {
            swap_(a.x, b.x);
            swap_(a.y, b.y);
        }
        double gradient = dy / dx;
        double xend = round_(a.x);
        double yend = a.y + gradient*(xend - a.x);
        double xgap = rfpart_(a.x + 0.5);
        int xpxl1 = xend;
        int ypxl1 = ipart_(yend);
        //plot_(xpxl1, ypxl1, rfpart_(yend)*xgap);
        [self plotPointWithColor:col brightness:rfpart_(yend)*xgap atX:xpxl1 atY:ypxl1];
        //plot_(xpxl1, ypxl1+1, fpart_(yend)*xgap);
        [self plotPointWithColor:col brightness:fpart_(yend)*xgap atX:xpxl1 atY:ypxl1 + 1];
        double intery = yend + gradient;
        
        xend = round_(b.x);
        yend = b.y + gradient*(xend - a.x);
        xgap = fpart_(b.x + 0.5);
        int xpxl2 = xend;
        int ypxl2 = ipart_(yend);
        //plot_(xpxl2, ypxl2, rfpart_(yend) * xgap);
        [self plotPointWithColor:col brightness:rfpart_(yend) * xgap atX:xpxl2 atY:ypxl2];
        //plot_(xpxl2, ypxl2 + 1, fpart_(yend) * xgap);
        [self plotPointWithColor:col brightness:fpart_(yend) * xgap atX:xpxl2 atY:ypxl2 + 1];
        int x;
        for(x=xpxl1+1; x <= (xpxl2-1); x++) {
            //plot_(x, ipart_(intery), rfpart_(intery));
            [self plotPointWithColor:col brightness:rfpart_(intery) atX:x atY:ipart_(intery)];
            //plot_(x, ipart_(intery) + 1, fpart_(intery));
            [self plotPointWithColor:col brightness:fpart_(intery) atX:x atY:ipart_(intery) + 1];
            intery += gradient;
        }
    } else {
        if ( b.y < a.y ) {
            swap_(a.x, b.x);
            swap_(a.y, b.y);
        }
        double gradient = dx / dy;
        double yend = round_(a.y);
        double xend = a.x + gradient*(yend - b.y);
        double ygap = rfpart_(a.y + 0.5);
        int ypxl1 = yend;
        int xpxl1 = ipart_(xend);
        //plot_(xpxl1, ypxl1, rfpart_(xend)*ygap);
        [self plotPointWithColor:col brightness:rfpart_(xend)*ygap atX:xpxl1 atY:ypxl1];
        //plot_(xpxl1, ypxl1+1, fpart_(xend)*ygap);
        [self plotPointWithColor:col brightness:fpart_(xend)*ygap atX:xpxl1 atY:ypxl1 + 1];
        double interx = xend + gradient;
        
        yend = round_(b.y);
        xend = b.x + gradient*(yend - b.y);
        ygap = fpart_(b.y+0.5);
        int ypxl2 = yend;
        int xpxl2 = ipart_(xend);
        //plot_(xpxl2, ypxl2, rfpart_(xend) * ygap);
        [self plotPointWithColor:col brightness:rfpart_(xend) * ygap atX:xpxl2 atY:ypxl2];
        //plot_(xpxl2, ypxl2 + 1, fpart_(xend) * ygap);
        [self plotPointWithColor:col brightness:fpart_(xend) * ygap atX:xpxl2 atY:ypxl2 + 1];
        int y;
        for(y=ypxl1+1; y <= (ypxl2-1); y++) {
            //plot_(ipart_(interx), y, rfpart_(interx));
            [self plotPointWithColor:col brightness:rfpart_(interx) atX:ipart_(interx) atY:y];
            //plot_(ipart_(interx) + 1, y, fpart_(interx));
            [self plotPointWithColor:col brightness:fpart_(interx) atX:ipart_(interx) + 1 atY:y];
            interx += gradient;
        }
    }
}
#undef swap_
#undef plot_
#undef ipart_
#undef fpart_
#undef round_
#undef rfpart_
@end
