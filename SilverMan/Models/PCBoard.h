//
//  PCBoard.h
//  SilverMan
//
//  Created by Willy on 24.03.13.
//  Copyright (c) 2013 Willy. All rights reserved.
//

#ifndef __SilverMan__PCBoard__
#define __SilverMan__PCBoard__

#include <iostream>
#import "PCVertex.h"
#import "PCProgramWrapper.h"

#define BOARD_SIZE 15

namespace PacMan
{
    class PCEnemy;
    class BaseMoveableSprite;
    class PCBoard
    {
        int map[BOARD_SIZE][BOARD_SIZE];
        PCLocation coordinateToPoint(PCLocation location);
        
        public:
            void initializeLevel(const char *level);
        
            PCPairElement createBlocks();
            PCLocation createHero();
            PCPairElement createCoins();
            std::vector<PCEnemy *> createEnemies(PCProgramWrapper *wrapper);
        
            static int pacmanSize();
            bool canMoveTo(PCLocation* next);
            static int elementSize();
    };
}

#endif /* defined(__SilverMan__PCBoard__) */
