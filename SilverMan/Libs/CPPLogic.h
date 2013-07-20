//
//  CPPLogic.h
//  SilverMan
//
//  Created by Willy on 01.02.13.
//  Copyright (c) 2013 Willy. All rights reserved.
//


#ifndef __SilverMan__CPPLogic__
#define __SilverMan__CPPLogic__

#import <iostream>
#import <GLKit/GLKit.h>
#import "PCProgramWrapper.h"
#import "PCBackgroundSprite.h"
#import "PCBoard.h"
#import "PCWallsSprite.h"
#import "PCPacMan.h"
#import "PCCoinsList.h"
#import "PCEnemy.h"
#import "PCGameContollerProtocol.h"

namespace PacMan
{
    class CPPLogic
    {
        PCBackgroundSprite *background;
        PCWallsSprite *blocks;
        PCBoard *board;
        PCPacMan  *pacman;
        PCProgramWrapper *_programLoader;
        PCCoinsList *coins;
        std::vector<PCEnemy *> enemies;

        void createGameElements();
        void createProgram(PCFSize screenSize);
        
        id<PCGameContollerProtocol> delegate;
      public:


        CPPLogic(PCFSize size, id<PCGameContollerProtocol> _delgate);
        ~CPPLogic();
        
        void draw();
        void update();
        
        void left();
        void right();
        void down();
        void up();
        void stop();
        

        
};
}
#endif /* defined(__SilverMan__CPPLogic__) */
