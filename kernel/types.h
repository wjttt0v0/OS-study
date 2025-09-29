#ifndef __TYPES_H__
#define __TYPES_H__

typedef unsigned char  uchar;
typedef unsigned char  uint8;
typedef unsigned short ushort;
typedef unsigned short uint16;
typedef unsigned int   uint;
typedef unsigned int   uint32;
typedef unsigned long  uint64;

// ANSI Color Codes
enum ansi_color {
    BLACK   = 30,
    RED     = 31,
    GREEN   = 32,
    YELLOW  = 33,
    BLUE    = 34,
    MAGENTA = 35,
    CYAN    = 36,
    WHITE   = 37
};

#endif // __TYPES_H__