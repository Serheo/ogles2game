//
//  PCBoard.cpp
//  SilverMan
//
//  Created by Willy on 24.03.13.
//  Copyright (c) 2013 Willy. All rights reserved.
//

#include "PCBoard.h"
#include <vector>
#import "PCVertex.h"
#include "BaseMoveableSprite.h"
#import "PCEnemy.h"

using namespace std;
using namespace PacMan;


#define XMARGIN [[UIScreen mainScreen] applicationFrame].size.height - 225 * 2
#define YMARGIN 14 * [UIScreen mainScreen].scale
#define TEX_COORD_MAX 1
#define COIN_DRAW_PROPABILITY 0.45

void PCBoard::initializeLevel(const char *level) {
    // Obj-c
    NSString *fileString = [NSString stringWithUTF8String:level];
	NSString *filePath = [[NSBundle mainBundle] pathForResource:fileString ofType:@"map"];
	NSString *levelString = [NSString stringWithContentsOfFile:filePath usedEncoding:nil error:nil];
    levelString = [[levelString componentsSeparatedByCharactersInSet :[NSCharacterSet whitespaceAndNewlineCharacterSet]] componentsJoinedByString:@""];
    const char* levelChars = [levelString UTF8String];
    int stringLen = [levelString length];
    // Cpp

    int i,j;
    for(int index=0; index < stringLen; index++)
    {
        char word = levelChars[index];
        //NSLog(@"%c", word);
        
        i = index % BOARD_SIZE;
        j = index / BOARD_SIZE;
        int item = (int)(word - '0');
        map[BOARD_SIZE - j - 1][i] = item;
    }
}

#pragma mark Size Helper

int PCBoard::elementSize()
{
    return 18 * [UIScreen mainScreen].scale;
}

int PCBoard::pacmanSize()
{
    return 18 * [UIScreen mainScreen].scale;
}

#pragma mark -
#pragma mark Moving Helpers

PCLocation PCBoard::coordinateToPoint(PCLocation location)
{
    int xmar  = XMARGIN;
    int ymar = YMARGIN;
    PCLocation coord;
    coord.yDirection = (location.xDirection - xmar )/ elementSize();
    coord.xDirection = (location.yDirection - ymar )/ elementSize();
    return coord;
}

bool PCBoard::canMoveTo(PCLocation* next)
{
    PCLocation coord1 = next[0];
    PCLocation coord2 = next[1];
    
    PCLocation coord = coordinateToPoint(coord1);
    if (map[coord.xDirection][coord.yDirection] == MIWall) return false;
    
    coord = coordinateToPoint(coord2);
    if (map[coord.xDirection][coord.yDirection] == MIWall) return false;
    
    return true;
}

#pragma mark - 
#pragma mark Create Elements

PCPairElement PCBoard::createBlocks() {
    PCPairElement pair;
    int size = elementSize();
    for (int i=0; i< BOARD_SIZE; i++) {
        for (int j=0; j< BOARD_SIZE; j++) {
            int item = map[i][j];

            if (item == MIWall)
            {
               // static int a = 0;
               // if (a++ > 1) continue;
                float x = j * size + XMARGIN;
                float y = i * size + YMARGIN;
               // NSLog(@" %lf %lf ", x,y);
                PCVertex lb = PCVertex( (float [2]){x, y}, (float [2]){0, TEX_COORD_MAX} );
                PCVertex rb = PCVertex((float [2][2]){{x+size, y},               {TEX_COORD_MAX, TEX_COORD_MAX}});
                PCVertex lt = PCVertex((float [2][2]){{x, y+size},               {0, 0}});
                PCVertex rt = PCVertex((float [2][2]){{x+size, y+size}, {TEX_COORD_MAX, 0}});
                pair.vertices.AddItems(lb, lt, rb, rt);
                int tail = pair.vertices.count();
               
                pair.indexes.AddItems(tail-4, tail-3, tail-2, tail-3, tail-2 ,tail-1);
                
            }
        }
    }
    //NSLog(@"blocks count %d %d", pair.vertices.count(), pair.indexes.count());
    return pair;
}

PCPairElement PCBoard::createCoins() {
    PCPairElement pair;
    int size = pacmanSize()/2;
    for (int i=0; i< BOARD_SIZE; i++) {
        for (int j=0; j< BOARD_SIZE; j++) {
            int item = map[i][j];
            
            if (item == MIEmpty)
            {                
                float probability = (float) rand()/RAND_MAX;
                if (probability < COIN_DRAW_PROPABILITY)
                {
                    float x = j * elementSize() + XMARGIN;
                    float y = i * elementSize() + YMARGIN;

                    PCVertex vert = PCVertex( (float [2]){x+size, y+size}, (float [2]){0, TEX_COORD_MAX} );
                    pair.vertices.AddItem(vert);
                }

            }
        }
    }

    return pair;
}

PCLocation PCBoard::createHero() {
    PCLocation location;
    for (int i=0; i< BOARD_SIZE; i++) {
        for (int j=0; j< BOARD_SIZE; j++) {
            int item = map[i][j];
            
            if (item == MIPlayer)
            {
                location.xDirection = j * elementSize() + XMARGIN + PCBoard::pacmanSize()/2;
                location.yDirection = i * elementSize() + YMARGIN + PCBoard::pacmanSize()/2;
            }
        }
    }
    return location;
}

std::vector<PCEnemy *> PCBoard::createEnemies(PCProgramWrapper *wrapper) {
    std::vector<PCEnemy *> enemies;
    
    PCLocation location;
    for (int i=0; i< BOARD_SIZE; i++) {
        for (int j=0; j< BOARD_SIZE; j++) {
            int item = map[i][j];
            
            if (item == MIEnemy)
            {
                location.xDirection = j * elementSize() + XMARGIN + PCBoard::pacmanSize()/2;
                location.yDirection = i * elementSize() + YMARGIN + PCBoard::pacmanSize()/2;
                PCEnemy *enemy = new PacMan::PCEnemy(wrapper, location);
                enemies.push_back(enemy);

            }
        }
    }
    return enemies;
}


#pragma mark -