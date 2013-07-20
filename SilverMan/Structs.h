//
//  Structs.h
//  SilverMan
//
//  Created by Willy on 03.01.13.
//  Copyright (c) 2013 Willy. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    MIEmpty = 0,
    MIWall = 1,
    MIEnemy = 2,
    MIPlayer = 3
} MapInterpretation;

typedef struct
{
    GLfloat	width;
    GLfloat height;
} PCFSize;

typedef struct
{
    float x;
    float y;
    GLfloat	width;
    GLfloat height;
} PCFRect;


typedef struct
{
    int xDirection;
    int yDirection;
} PCLocation;

typedef enum  {
    PCDirectionNope = 0,
    PCDirectionLeft = 11,
    PCDirectionDown,
    PCDirectionRight,
    PCDirectionUp
} PCPossibleDirection;

static inline bool Vector2isEqual(PCLocation v1, PCLocation v2)
{
    return (v1.xDirection == v2.xDirection && v1.yDirection == v2.yDirection);
}


static inline PCLocation Vector2Sum(PCLocation location, PCLocation velocity)
{
    return (PCLocation){location.xDirection + velocity.xDirection, location.yDirection + velocity.yDirection};
}

static inline PCLocation Vector2Mul(PCLocation location, PCLocation velocity)
{
    return (PCLocation){location.xDirection * velocity.xDirection, location.yDirection * velocity.yDirection};
}

static inline PCLocation Vector2MulScalar(PCLocation location, int val)
{
    return (PCLocation){location.xDirection * val, location.yDirection * val};
}

static inline bool PCFRectcontainsPoint(PCFRect rect, PCLocation point)
{
   if (point.xDirection > rect.x && point.yDirection > rect.y &&
       point.xDirection < (rect.x + rect.width) &&point.yDirection < (rect.y + rect.height)) return true;
    return false;
}


static inline bool PCF4RectContainsPoint(PCLocation lt, PCLocation lb, PCLocation rt, PCLocation rb, PCLocation point)
{
    if (lt.xDirection < point.xDirection && lt.yDirection > point.yDirection  &&
        lb.xDirection < point.xDirection && lb.yDirection < point.yDirection  &&
        rt.xDirection > point.xDirection && rt.yDirection > point.yDirection  &&
        rb.xDirection > point.xDirection && rb.yDirection < point.yDirection )
    {
        return true;
    }
    
    
    return false;
}

