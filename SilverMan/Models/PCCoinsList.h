//
//  PCCoinsList.h
//  SilverMan
//
//  Created by Willy on 02.04.13.
//  Copyright (c) 2013 Willy. All rights reserved.
//

#ifndef __SilverMan__PCCoinsList__
#define __SilverMan__PCCoinsList__

#include <iostream>
#include "BaseMoveableSprite.h"
#import "PCBoard.h"
#import "PCProgramWrapper.h"

namespace PacMan
{
    class PCCoinsList : public BaseMoveableSprite
    {
        PCPairElement vertsPosition;
        void setModelViewMatrix(PCProgramWrapper *program, float x, float y);
    public:
        PCCoinsList(PCProgramWrapper *wrapper, PCBoard *board);
        void draw();
        bool executeDinner(PCLocation player);
        void update(PCBoard *board);
        bool empty();
    };
}

#endif /* defined(__SilverMan__PCCoinsList__) */
