#include "Password32.h"
#include <math.h>

Password32::Password32(void)
{
}


Password32::~Password32(void)
{
}

char * Password32::exe(char* object,unsigned int objectLength,char* result, char* password,unsigned int startIndex)
{
    unsigned int i;
    char b;
    int bit;
    unsigned int pos;
    int bitPos;

    //安全验证
    if(object==0||objectLength==0||result==0||password==0)
        return 0;

    //开始加密或解密

    for(i=0;i<objectLength;i++)
    {
        //获取要加密的字节
        b=object[i];

        //获取指定位置的字
        pos=(i+startIndex)%256;//提取所在的字
        bitPos=pos%8;//字节里的位;

        bit=(password[(int)(pos/8)]&(unsigned char)pow((double)2,bitPos))>>bitPos;

        //加密
        if(bit==1)
            b=~b;

        //保存结果
        result[i]=b;
    }

    //完成
    return result;
}


