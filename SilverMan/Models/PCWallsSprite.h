//
//  PCWallsSprite.h
//  SilverMan
//
//  Created by Willy on 25.03.13.
//  Copyright (c) 2013 Willy. All rights reserved.
//

#ifndef __SilverMan__PCWallsSprite__
#define __SilverMan__PCWallsSprite__

#include <iostream>

#import "BaseSprite.h"
#import "PCBoard.h"

namespace PacMan
{
    class PCWallsSprite : public BaseSprite
    {
        public:
            PCWallsSprite(PCProgramWrapper *wrapper, PCBoard *board);
            void draw();
    };
}


#endif /* defined(__SilverMan__PCWallsSprite__) */
