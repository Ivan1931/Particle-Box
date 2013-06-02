//
//  Engine.m
//  Particle Box
//
//  Created by Jonah Hooper on 2013/03/25.
//  Copyright (c) 2013 Jonah Hooper. All rights reserved.
//


#import "Engine.h"

typedef unsigned char byte;

#define Clamp255(a) (a>255 ? 255 : a)


@implementation Engine

@synthesize view;
@synthesize calc;
@synthesize renderLink;
@synthesize calculateLink;
int startX = 0;
int startY = 0;

-(id) initWithSize:(CGRect)size andColor:(UIColor*)color {
    self = [super init];
    if (self)
    {
        view = [[RenderView alloc] initWithFrame:size];
        //
        width = size.size.width;
        height = size.size.height;
        colorSpace = CGColorSpaceCreateDeviceRGB();
        //
        image = [self makeCalc:view.bounds];
        calculateLink = [CADisplayLink displayLinkWithTarget:calc selector:@selector(calculate:)];
        renderLink  =[CADisplayLink displayLinkWithTarget:self selector:@selector(render:)];
        [calculateLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
        [renderLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
        
       
    }
    return self;
}

-(void) clearRaster:(CADisplayLink*) link  {
    //NSLog(@"Clear Raster");
    
    size_t bytesPerRow      = (width * BITSPERCOMPONENT * BYTESPERPIXEL + 7) / 8;
    for (int y = startY ; y < height/2 + startY; y++)
    {
        for (int x = startX; x < width /2 + startX; x++)
        {
            int byteIndex = (bytesPerRow * y) + x * BYTESPERPIXEL;
            data[byteIndex] = 255;
            data[byteIndex + 1] = 255;
            data[byteIndex + 2] = 255;
            
        }
    }
    if (startX >= width / 2) {
        startX = 0;
    } else startX++;
    if (startY >= height / 2) {
        startY = 0;
    } else startY++;
}

-(void) updateImage{
    size_t bytesPerRow      = (width * BITSPERCOMPONENT * BYTESPERPIXEL + 7) / 8;
    CGContextRef context = CGBitmapContextCreate(data, width, height,
                                                 BITSPERCOMPONENT,
                                                 bytesPerRow, colorSpace,
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    
    
    //CGColorSpaceRelease(colorSpace);
    CGImageRef imageRef = CGBitmapContextCreateImage(context);
    image = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    CGContextRelease(context);
    //free(data);
    
    
}

-(void) render:(CADisplayLink*) link  {
    //NSLog(@"Render");
    @try {
        [self updateImage];
    }
    @catch (NSException *exception) {
        NSLog(@"Exception");
    }
    [view drawImage:image];
    
}

- (UIImage*)makeCalc: (CGRect)rect
{
    size_t bitsPerComponent = 8;
    size_t bytesPerPixel    = 4;
    size_t bytesPerRow      = (width * bitsPerComponent * bytesPerPixel + 7) / 8;
    size_t dataSize         = bytesPerRow * height;
    
    data = malloc(dataSize);
    memset(data, 0, dataSize);
    
    CGContextRef context = CGBitmapContextCreate(data, width, height,
                                                 bitsPerComponent,
                                                 bytesPerRow, colorSpace,
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    
    calc = [[Calculator alloc] initWithData:data andDimesions:(Vec2){rect.size.width, rect.size.height}];
    CGColorSpaceRelease(colorSpace);
    CGImageRef imageRef = CGBitmapContextCreateImage(context);
    UIImage *result = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    CGContextRelease(context);
    //free(data);
    return result;
}

-(void) moveForces:(CGPoint)xy {
    [calc moveGravity:xy];
}
@end
