//
//  Base64.h
//  AdventureIsland
//
//  Created by JasonWu on 6/21/15.
//
//

#ifndef __AdventureIsland__Base64__
#define __AdventureIsland__Base64__

#include <stdio.h>
#include <string>

class Base64
{
public:
    static std::string DEFAULT_ALPHABET;
    
protected:
    std::string _alphabet;
    
    char *_result;
    int _resultSize;
    
    int _base64Decode(const unsigned char *input, unsigned int input_len, unsigned char *output, unsigned int *output_len );
    
    void _base64Encode( const unsigned char *input, unsigned int input_len, char *output );

    
public:
    
    Base64();
    ~Base64();
    
    int decode(const unsigned char *in, unsigned int inLength);
    int encode(const unsigned char *in, unsigned int inLength);
    
    std::string getResultString();
    unsigned char* getResultData();
    
    int getResultSize();

    std::string getAlphabet();
    void setAlphabet(std::string value);
    
};


inline std::string Base64::getResultString()
{
    return _result;
}
inline unsigned char* Base64::getResultData()
{
    return (unsigned char*)_result;
}

inline int Base64::getResultSize()
{
    return _resultSize;
}

inline std::string Base64::getAlphabet()
{
    return _alphabet;
}
inline void Base64::setAlphabet(std::string value)
{
    _alphabet=value;
}


#endif /* defined(__AdventureIsland__Base64__) */
