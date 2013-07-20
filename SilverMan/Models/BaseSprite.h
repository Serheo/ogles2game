//
//  BaseSprite.h
//  SilverMan
//
//  Created by Willy on 24.03.13.
//  Copyright (c) 2013 Willy. All rights reserved.
//

#ifndef __SilverMan__BaseSprite__
#define __SilverMan__BaseSprite__

#include <iostream>
#import "PCProgramWrapper.h"
#import "PCVertex.h"

namespace PacMan
{    
    class BaseSprite
    {
        protected:
        
            PCProgramWrapper *program;
            PCPairElement pair;
        
            GLuint _vertexBuffer;
            GLuint _indexBuffer;
            GLuint texture;
        
            GLuint setupTexture(const char *fileName);
            void setupVBOs();
            virtual void setModelViewMatrix(PCProgramWrapper *program);
        public:
            BaseSprite(PCProgramWrapper * wrapper);
            virtual void draw()=0;
            static void setProjectionMatrix(PCProgramWrapper *program);
    };
}

#endif /* defined(__SilverMan__BaseSprite__) */

