//
//  PCEnemy.h
//  SilverMan
//
//  Created by Willy on 02.04.13.
//  Copyright (c) 2013 Willy. All rights reserved.
//

#ifndef __SilverMan__PCEnemy__
#define __SilverMan__PCEnemy__

#include <iostream>
#import "BaseMoveableSprite.h"
#import "PCBoard.h"
#import "PCPacMan.h"

namespace PacMan
{
    class PCEnemy : public BaseMoveableSprite
    {
        std::vector<int> directions(PCBoard *board, PCPacMan *target);
        bool isPacmanFind(PCLocation targetLocation, PCLocation lt, PCLocation lb, PCLocation vector, int direction);
    public:
        PCEnemy(PCProgramWrapper *wrapper, PCLocation location);
        void draw();
        void update(PCBoard *board, PCPacMan *target);
        bool executeEat(PCFRect pacmanRect);

    };
}

#endif /* defined(__SilverMan__PCEnemy__) */
