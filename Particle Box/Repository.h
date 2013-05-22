//
//  Repository.h
//  Particle Box
//
//  Created by Jonah Hooper on 2013/03/27.
//  Copyright (c) 2013 Jonah Hooper. All rights reserved.
//

#ifndef Particle_Box_Repository_h
#define Particle_Box_Repository_h
#define BYTESPERPIXEL 4
#define BITSPERCOMPONENT 8
typedef struct {
    Byte r;
    Byte g;
    Byte b;
}Color;
typedef struct {
    float x;
    float y;
}Vec2;
#define RADIAN 0.01745329251

#endif
