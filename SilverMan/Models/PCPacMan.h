//
//  PCPacMan.h
//  SilverMan
//
//  Created by Willy on 30.03.13.
//  Copyright (c) 2013 Willy. All rights reserved.
//

#ifndef __SilverMan__PCPacMan__
#define __SilverMan__PCPacMan__

#include <iostream>
#import "BaseMoveableSprite.h"
#import "PCBoard.h"

namespace PacMan
{
    class PCPacMan : public BaseMoveableSprite
    {
        int slideSwitch;
        GLfloat* slide();
        GLuint nextTexure, currentTexture;

    public:
        PCPacMan(PCProgramWrapper *wrapper, PCBoard *board);
        void draw();
        void update(PCBoard *board);
    };
}


#endif /* defined(__SilverMan__PCPacMan__) */
