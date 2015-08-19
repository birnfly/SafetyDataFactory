#ifndef __AdventureIsland__Password32__
#define __AdventureIsland__Password32__

class Password32
{
public:
    Password32(void);
    ~Password32(void);
    static char* exe(char* object,unsigned int objectLength,char* result, char* password,unsigned int startIndex=0,int density=1);
};

#endif /* defined(__AdventureIsland__Base64__) */
