//
//  CPPLogic.m
//  SilverMan
//
//  Created by Willy on 01.02.13.
//  Copyright (c) 2013 Willy. All rights reserved.
//

#include "CPPLogic.h"
#include <GLKit/GLKit.h>

#include <OpenGLES/ES2/gl.h>
#include <OpenGLES/ES2/glext.h>
#import <QuartzCore/QuartzCore.h>
#include <vector>

using namespace std;
using namespace PacMan;

CPPLogic::CPPLogic(PCFSize size, id<PCGameContollerProtocol> _delgate) {
    delegate = _delgate;
    createProgram(size);
}

void CPPLogic::createProgram(PCFSize screenSize)
{
    _programLoader = new PacMan::PCProgramWrapper(screenSize);
    createGameElements();
}

void CPPLogic::createGameElements(){
    
    background = new PacMan::PCBackgroundSprite(_programLoader);
    board = new PacMan::PCBoard();
    board->initializeLevel("level1");
    blocks = new PacMan::PCWallsSprite(_programLoader, board);
    pacman = new PacMan::PCPacMan(_programLoader, board);
    coins = new PacMan::PCCoinsList(_programLoader, board);
    enemies = board->createEnemies(_programLoader);
}

CPPLogic::~CPPLogic()
{
    delete _programLoader;
    delete background;
    delete blocks;
    delete board;
    delete pacman;
    delete coins;
    
    for(std::vector<PCEnemy *>::const_iterator it = enemies.begin(); it != enemies.end(); ++it) {
        PCEnemy *en = *it;
        delete en;
    }
}

#pragma mark -

void CPPLogic::draw()
{
    glBlendFunc(GL_ONE, GL_ONE_MINUS_SRC_ALPHA);
    glEnable(GL_BLEND);
    glClearColor(0, 104.0/255.0, 55.0/255.0, 1.0);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    glUseProgram(_programLoader->program());
    glViewport(0, 0, _programLoader->size().width, _programLoader->size().height);
    
    BaseSprite::setProjectionMatrix(_programLoader);
   
    background->draw();
    blocks->draw();
    coins->draw();
    pacman->draw();
    for(std::vector<PCEnemy *>::const_iterator it = enemies.begin(); it != enemies.end(); ++it) {
        PCEnemy *en = *it;
        en->draw();
    }
}

void CPPLogic::update()
{
    coins->update(board);
    
    if (coins->executeDinner(pacman->location())) [[PCMediaPlayer sharedInstance] coinDing];
    if (coins->empty())
    {
        [delegate level:@"level1" didFinishWithResult:YES];
        return;
    }
    
    for(std::vector<PCEnemy *>::const_iterator it = enemies.begin(); it != enemies.end(); ++it) {
        PCEnemy *en = *it;
        if ( en->executeEat(pacman->boundingBox()) )
        {
            [delegate level:@"level1" didFinishWithResult:NO];
            return;
        }
        en->update(board, pacman);
    }
    
    pacman->update(board);
}

#pragma mark Start/Stop methods

void CPPLogic::left()
{
    pacman->wantLeft();
}

void CPPLogic::right()
{
    pacman->wantRight();
}

void CPPLogic::down()
{
    pacman->wantDown();
}

void CPPLogic::up()
{
    pacman->wantUp();
}

void CPPLogic::stop()
{
    pacman->stop();
}

