//
//  PCVectorArray.h
//  SilverMan
//
//  Created by Willy on 26.03.13.
//  Copyright (c) 2013 Willy. All rights reserved.
//

#ifndef __SilverMan__PCVerticleArray__
#define __SilverMan__PCVerticleArray__


#include <vector>
#include <malloc/malloc.h>

typedef struct PCVertex{
    float Position[2];
    float TexCoord[2];

    PCVertex(float position[2], float texCoord[2])
    {
        setOperation(position, texCoord);
    }
    
    PCVertex(float list[2][2])
    {
        setOperation(list[0], list[1]);
    }
    
    PCVertex(float p0, float p1, float t0, float t1)
    {
        setOperation((float []){p0, p1}, (float[]){t0, t1});
    }
    
    void setOperation(float position[2], float texCoord[2])
	{
        Position[0] = position[0];
        Position[1] = position[1];
        TexCoord[0] = texCoord[0];
        TexCoord[1] = texCoord[1];
	}
    
} PCVertex;


class PCVerticleArray
{
public:
    void AddItem(float position[2], float texCoord[2]) {
        verts.push_back(PCVertex(position, texCoord));
    }
    void AddItem(float p0, float p1, float t0, float t1) {
        verts.push_back(PCVertex(p0, p1, t0, t1));
    }
    
    void AddItems(PCVertex i1, PCVertex i2, PCVertex i3, PCVertex i4) {
        verts.push_back(i1); verts.push_back(i2);
        verts.push_back(i3); verts.push_back(i4);
    }
    
    void AddItem(PCVertex item) {
        verts.push_back(item);
    }
    
    void RemoveAt(int i) {
        verts.erase(verts.begin() + i);
    }
    
    PCVertex GetItem(int i) {
        return verts[i];
    }
    
    PCVertex* array() {
        return &verts[0];
    }
    
    size_t size() {
        return verts.size() * sizeof(verts[0]);
    }
    
    int count() {
        return verts.size();
    }
private:
    std::vector<PCVertex> verts;
};

class PCIndexArray
{
public:
    
    void AddItem(GLushort bite) {
        indexes.push_back(bite);
    }
    void AddItems(GLushort i1, GLushort i2, GLushort i3, GLushort i4) {
        indexes.push_back(i1); indexes.push_back(i2);
        indexes.push_back(i3); indexes.push_back(i4);
    }
    
    void AddItems(GLushort i1, GLushort i2, GLushort i3, GLushort i4, GLushort i5, GLushort i6) {
        indexes.push_back(i1); indexes.push_back(i2);
        indexes.push_back(i3); indexes.push_back(i4);
        indexes.push_back(i5); indexes.push_back(i6);
    }
    GLushort GetItem(int i) {
        return indexes[i];
    }
        
    GLushort* array() {
        return &indexes[0];
    }
    
    size_t size() {
        return indexes.size() * sizeof(indexes[0]);
    }
    
    int count() {
        return indexes.size();
    }
private:
    std::vector<GLushort> indexes;
};

class PCPairElement
{
    public:
        PCIndexArray indexes;
        PCVerticleArray vertices;
};


#endif /* defined(__SilverMan__PCVectorArray__) */
