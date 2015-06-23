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

    //��ȫ��֤
    if(object==0||objectLength==0||result==0||password==0)
        return 0;

    //��ʼ���ܻ����

    for(i=0;i<objectLength;i++)
    {
        //��ȡҪ���ܵ��ֽ�
        b=object[i];

        //��ȡָ��λ�õ���
        pos=(i+startIndex)%256;//��ȡ���ڵ���
        bitPos=pos%8;//�ֽ����λ;

        bit=(password[(int)(pos/8)]&(unsigned char)pow((double)2,bitPos))>>bitPos;

        //����
        if(bit==1)
            b=~b;

        //������
        result[i]=b;
    }

    //���
    return result;
}


