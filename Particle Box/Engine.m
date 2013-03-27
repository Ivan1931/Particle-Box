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
#define BYTESPERPIXEL 4
#define BITSPERCOMPONENT 8

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
        image = [self makeImage:view.bounds];
        calculateLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(clearRaster:)];
        renderLink  =[CADisplayLink displayLinkWithTarget:self selector:@selector(render:)];
        [calculateLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
        [renderLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
        
       
    }
    return self;
}
-(void) clearRaster:(CADisplayLink*) link  {
    NSLog(@"Clear Raster");
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
    NSLog(@"Render");
    [self updateImage];
    [view drawImage:image];
}
- (UIImage*)makeImage: (CGRect)rect
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
    
    
    CGColorSpaceRelease(colorSpace);
    CGImageRef imageRef = CGBitmapContextCreateImage(context);
    UIImage *result = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    CGContextRelease(context);
    free(data);    
    return result;
}
+ (Byte*) arrayOfBytesFromData:(NSData*) data
{
    NSUInteger len = [data length];
    Byte *byteData = (Byte*)malloc(len);
    memcpy(byteData, [data bytes], len);
    return byteData;
}

+ (UIImage*)blankImage:(CGSize)_size withColor:(UIColor*)_color {
    UIGraphicsBeginImageContext(_size);
	CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, _color.CGColor);
    CGContextFillRect(context, CGRectMake(0.0, 0.0, _size.width, _size.height));
    UIImage* outputImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return outputImage;
}
+ (UIImage*) fromImage:(UIImage*)source toColourR:(int)colR g:(int)colG b:(int)colB {
    
    CGContextRef ctx;
    CGImageRef imageRef = [source CGImage];
    NSUInteger width = CGImageGetWidth(imageRef);
    NSUInteger height = CGImageGetHeight(imageRef);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    byte *rawData = malloc(height * width * 4);
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * width;
    NSUInteger bitsPerComponent = 8;
    CGContextRef context = CGBitmapContextCreate(rawData, width, height,
                                                 bitsPerComponent, bytesPerRow, colorSpace,
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
    CGContextRelease(context);
    
    int byteIndex = 0;
    for (int ii = 0 ; ii < width * height ; ++ii)
    {
        int grey = (rawData[byteIndex] + rawData[byteIndex+1] + rawData[byteIndex+2]) / 3;
        
        rawData[byteIndex] = Clamp255(colR*grey/256);
        rawData[byteIndex+1] = Clamp255(colG*grey/256);
        rawData[byteIndex+2] = Clamp255(colB*grey/256);
        
        byteIndex += 4;
    }
    
    ctx = CGBitmapContextCreate(rawData,
                                CGImageGetWidth( imageRef ),
                                CGImageGetHeight( imageRef ),
                                8,
                                bytesPerRow,
                                colorSpace,
                                kCGImageAlphaPremultipliedLast );
    CGColorSpaceRelease(colorSpace);
    
    imageRef = CGBitmapContextCreateImage (ctx);
    UIImage* rawImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    
    CGContextRelease(ctx);
    free(rawData);
    
    return rawImage;
}
@end
