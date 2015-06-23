//
//  Base64.cpp
//  AdventureIsland
//
//  Created by JasonWu on 6/21/15.
//
//

#include "Base64.h"

std::string Base64::DEFAULT_ALPHABET="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

Base64::Base64():_alphabet(Base64::DEFAULT_ALPHABET),_result(0)
{
    
}
Base64::~Base64()
{
    if (_result!=0) {
        free(_result);
        _result=0;
    }
}

int Base64::_base64Decode(const unsigned char *input, unsigned int input_len, unsigned char *output, unsigned int *output_len )
{
    const unsigned char* alphabet=(unsigned char*)_alphabet.c_str();
    static char inalphabet[256], decoder[256];
    int i, bits, c = 0, char_count, errors = 0;
    unsigned int input_idx = 0;
    unsigned int output_idx = 0;
    
    for (i = (_alphabet.size()) - 1; i >= 0 ; i--) {
        inalphabet[alphabet[i]] = 1;
        decoder[alphabet[i]] = i;
    }
    
    char_count = 0;
    bits = 0;
    for( input_idx=0; input_idx < input_len ; input_idx++ ) {
        c = input[ input_idx ];
        if (c == '=')
            break;
        if (c > 255 || ! inalphabet[c])
            continue;
        bits += decoder[c];
        char_count++;
        if (char_count == 4) {
            output[ output_idx++ ] = (bits >> 16);
            output[ output_idx++ ] = ((bits >> 8) & 0xff);
            output[ output_idx++ ] = ( bits & 0xff);
            bits = 0;
            char_count = 0;
        } else {
            bits <<= 6;
        }
    }
    
    if( c == '=' ) {
        switch (char_count) {
            case 1:
                errors++;
                break;
            case 2:
                output[ output_idx++ ] = ( bits >> 10 );
                break;
            case 3:
                output[ output_idx++ ] = ( bits >> 16 );
                output[ output_idx++ ] = (( bits >> 8 ) & 0xff);
                break;
        }
    } else if ( input_idx < input_len ) {
        if (char_count) {
            errors++;
        }
    }
    
    *output_len = output_idx;
    return errors;

}



void Base64::_base64Encode( const unsigned char *input, unsigned int input_len, char *output )
{
    const unsigned char* alphabet=(unsigned char*)_alphabet.c_str();
    
    unsigned int char_count;
    unsigned int bits;
    unsigned int input_idx = 0;
    unsigned int output_idx = 0;
    
    char_count = 0;
    bits = 0;
    for( input_idx=0; input_idx < input_len ; input_idx++ ) {
        bits |= input[ input_idx ];
        
        char_count++;
        if (char_count == 3) {
            output[ output_idx++ ] = alphabet[(bits >> 18) & 0x3f];
            output[ output_idx++ ] = alphabet[(bits >> 12) & 0x3f];
            output[ output_idx++ ] = alphabet[(bits >> 6) & 0x3f];
            output[ output_idx++ ] = alphabet[bits & 0x3f];
            bits = 0;
            char_count = 0;
        } else {
            bits <<= 8;
        }
    }
    
    if (char_count) {
        if (char_count == 1) {
            bits <<= 8;
        }
        
        output[ output_idx++ ] = alphabet[(bits >> 18) & 0x3f];
        output[ output_idx++ ] = alphabet[(bits >> 12) & 0x3f];
        if (char_count > 1) {
            output[ output_idx++ ] = alphabet[(bits >> 6) & 0x3f];
        } else {
            output[ output_idx++ ] = '=';
        }
        output[ output_idx++ ] = '=';
    }
    
    output[ output_idx++ ] = 0;

}

int Base64::decode(const unsigned char *in, unsigned int inLength)
{
    
    if (_result!=0) {
        free(_result);
        _result=0;
    }
    
    unsigned int outLength = 0;
    
    //should be enough to store 6-bit buffers in 8-bit buffers
    _result = (char*)malloc(inLength * 3.0f / 4.0f + 1);

    _resultSize=inLength * 3.0f / 4.0f + 1;

    unsigned char* data=(unsigned char*)_result;
    if( data ) {
        int ret = _base64Decode(in, inLength, data, &outLength);
        
        if (ret > 0 )
        {
            free(data);
            data = 0;
            outLength = 0;
        }
    }
    _resultSize=outLength;
    return outLength;

}
int Base64::encode(const unsigned char *in, unsigned int inLength)
{
    if (_result!=0) {
        free(_result);
        _result=0;
    }
    
    unsigned int outLength = inLength * 4 / 3 + (inLength % 3 > 0 ? 4 : 0);
    
    _resultSize=outLength;

    //should be enough to store 8-bit buffers in 6-bit buffers
    _result = (char*)malloc(outLength+1);
    
    if( _result ) {
        _base64Encode(in, inLength, _result);
    }
    return outLength;

}

