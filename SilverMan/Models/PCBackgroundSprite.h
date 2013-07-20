//
//  PCBackgroundSprite.h
//  SilverMan
//
//  Created by Willy on 24.03.13.
//  Copyright (c) 2013 Willy. All rights reserved.
//

#ifndef __SilverMan__PCBackgroundSprite__
#define __SilverMan__PCBackgroundSprite__

#include <iostream>
#import "BaseSprite.h"


namespace PacMan
{
    class PCBackgroundSprite : public BaseSprite
    {
        

    public:
        PCBackgroundSprite(PCProgramWrapper *wrapper);
        void draw();
    };
}

#endif /* defined(__SilverMan__PCBackgroundSprite__) */
