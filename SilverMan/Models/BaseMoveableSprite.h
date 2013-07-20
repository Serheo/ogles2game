//
//  BaseMoveableSprite.h
//  SilverMan
//
//  Created by Willy on 30.03.13.
//  Copyright (c) 2013 Willy. All rights reserved.
//

#ifndef __SilverMan__BaseMoveableSprite__
#define __SilverMan__BaseMoveableSprite__

#include <iostream>
#import "BaseSprite.h"
#import "PCProgramWrapper.h"
#import "PCVertex.h"



namespace PacMan
{
    class PCBoard;
    class BaseMoveableSprite : public BaseSprite
    {
        protected:
            Vector3D rotationVector;
            PCLocation velocity;
            PCLocation position;
            float rotationDegree;
            int desirableDirection;
        
            virtual int playerSpeed();
        
            virtual void setModelViewMatrix(PCProgramWrapper *program);
            void setupDynamicVBOs();
        
            PCLocation reverseDesirableVector();
            PCLocation desirableVector();
        
            PCLocation reverseDirection();
            PCLocation reverseDirection(PCLocation loc);
            PCLocation direction();
            PCLocation desirableVelocityVector();
        
            void goDesirable();
            void performDesirableAction(PCBoard *board);
            PCLocation* nextDesirableCoordinate();
            PCLocation* nextFaceCoordinate();
            PCLocation nextCenterFaceCoodinate();
            PCLocation* nextCoordinate(PCLocation vector, PCLocation reverseVector, PCLocation velocityVector);
        public:
            BaseMoveableSprite(PCProgramWrapper * wrapper);
            virtual void draw()=0;
        
            void left();
            void right();
            void up();
            void down();
        
            void wantLeft();
            void wantRight();
            void wantUp();
            void wantDown();
            
            void stop();
            PCLocation location();
            PCFRect boundingBox();
            virtual void update(PCBoard *board);
        
    };
}

#endif /* defined(__SilverMan__BaseMoveableSprite__) */
