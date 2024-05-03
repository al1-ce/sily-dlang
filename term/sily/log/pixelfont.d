/**
Not really optimised pixel font module. 
Contains 2 fonts. Probably going to be 
transformed to read "bitmaps" and moved in
it's own module
---
5x6 
█▀▀▀▀   ▀    ▀█   ▄   ▄  
▀▀▀▀█   █     █   ▀▄ ▄▀  
▄▄▄▄█   █     █     █    
3x4 
██▀  █  █   █▄█  
▄▄█  █  █▄▄  █   
---
*/
module sily.log.pixelfont;

import std.algorithm.searching: canFind;
import std.stdio: writeln;
import std.array: join, split;
import std.uni: toUpper;

import sily.term: terminalWidth;
import sily.string: splitStringWidth;

/** 
Prints/Returns string in big unicode letters with size 4x6
Params:
  s = String to print/get
Example:
---
print5x6("Fox");
// prints:
█▀▀▀▀  ▄▄▄  ▄   ▄ 
█▀▀▀▀ █   █  ▀▄▀  
█     ▀▄▄▄▀ ▄▀ ▀▄ 
---
Allowed Characters:
---
ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz `~!@#$%^&*()-_+=[]{}\|,.<>?/;:'"
---
 */
void print5x6(string s) { 
    dstring[] lines = getPixelSetWidth!(5, 3)(s, terminalWidth, pixelFont5x6); 
    foreach (line; lines) writeln(line);
}
/// Ditto
dstring get5x6(string s) { 
    return getPixelSetWidth!(5, 3)(s, terminalWidth, pixelFont5x6).join('\n'); 
}
/// Ditto
void print3x4(string s) { 
    dstring[] lines = getPixelSetWidth!(3, 2)(s.toUpper, terminalWidth, pixelFont3x4); 
    foreach (line; lines) writeln(line);
}
/// Ditto
dstring get3x4(string s) { 
    return getPixelSetWidth!(3, 2)(s.toUpper, terminalWidth, pixelFont3x4).join('\n'); 
}

private dstring[] getPixelSetWidth(int charw, int charh)(string s, int w, ref const(dstring[char]) table) {
    string[] lines = splitStringWidth(s, w / (charw + 1));
    dstring[] outlines;
    foreach (line; lines) {
        dstring l = getPixelSet!(charw, charh)(line, table);
        if (l.length > 0) outlines ~= l;
    }
    return outlines;
}

private dstring getPixelSet(int charw, int charh)(string s, ref const(dstring[char]) table) {
    if (s.length == 0) return "";
    dstring[] lines = new dstring[](charh + 1);
    for (int i = 0; i < charh + 1; ++i) {
        lines[i] = "";
    }

    foreach (c; s) {
        if (table.keys.canFind(c)) {
            for (int i = 0; i < charh + 1; ++i) {
                int charf = i * (charw + 1);
                int chart = charf + charw + 1;
                lines[i] ~= table[c][charf..chart];
            }
        } else {
            for (int i = 0; i < charh + 1; ++i) {
                int charf = i * (charw + 1);
                int chart = charf + charw + 1;
                lines[i] ~= table['\0'][charf..chart];
            }
        }
    }
    
    return lines.join('\n');
}

private const dstring[char] pixelFont5x6;
private const dstring[char] pixelFont3x4;

shared static this() { 
    pixelFont5x6 = [
    '\0':"      " ~ 
         "      " ~ 
         "      " ~ 
         "      ",
    ' ': "      " ~ 
         "      " ~ 
         "      " ~ 
         "      ",
    'A': "      " ~ 
         "▄▀▀▀█ " ~ 
         "█▄▄▄█ " ~ 
         "█   █ ",
    'a': "      " ~ 
         " ▄▄▄▄ " ~ 
         "█   █ " ~ 
         "▀▄▄▄█ ",
    'B': "      " ~ 
         "█▀▀▀▄ " ~ 
         "█▀▀▀▄ " ~ 
         "█▄▄▄█ ",
    'b': "      " ~ 
         "█     " ~ 
         "█▀▀▀▄ " ~ 
         "█▄▄▄▀ ",
    'C': "      " ~ 
         "▄▀▀▀▄ " ~ 
         "█     " ~ 
         "▀▄▄▄▀ ",
    'c': "      " ~ 
         " ▄▄▄  " ~ 
         "█   ▀ " ~ 
         "▀▄▄▄▀ ",
    'D': "      " ~ 
         "█▀▀▀▄ " ~ 
         "█   █ " ~ 
         "█▄▄▄▀ ",
    'd': "      " ~ 
         "    █ " ~ 
         "▄▀▀▀█ " ~ 
         "▀▄▄▄█ ",
    'E': "      " ~ 
         "█▀▀▀▀ " ~ 
         "█▀▀▀▀ " ~ 
         "█▄▄▄▄ ",
    'e': "      " ~ 
         " ▄▄▄  " ~ 
         "█▄▄▄█ " ~ 
         "▀▄▄▄  ",
    'F': "      " ~ 
         "█▀▀▀▀ " ~ 
         "█▀▀▀▀ " ~ 
         "█     ",
    'f': "      " ~ 
         " ▄▄▄▄ " ~ 
         "█▄▄▄  " ~ 
         "█     ",
    'G': "      " ~ 
         "▄▀▀▀▄ " ~ 
         "█  ▄▄ " ~ 
         "▀▄▄▄█ ",
    'g': "      " ~ 
         " ▄▄▄  " ~ 
         "▀▄▄▄█ " ~ 
         " ▄▄▄▀ ",
    'H': "      " ~ 
         "█   █ " ~ 
         "█▀▀▀█ " ~ 
         "█   █ ",
    'h': "      " ~ 
         "█     " ~ 
         "█▀▀▀▄ " ~ 
         "█   █ ",
    'I': "      " ~ 
         "▀▀█▀▀ " ~ 
         "  █   " ~ 
         "▄▄█▄▄ ",
    'i': "      " ~ 
         "  ▀   " ~ 
         "  █   " ~ 
         "  █   ",
    'J': "      " ~ 
         "▀▀█▀▀ " ~ 
         "  █   " ~ 
         "▄▄▀   ",
    'j': "      " ~ 
         "  ▀   " ~ 
         "  █   " ~ 
         " ▄▀   ",
    'K': "      " ~ 
         "█ ▄▀▀ " ~ 
         "██    " ~ 
         "█ ▀▄▄ ",
    'k': "      " ~ 
         "█  ▄  " ~ 
         "█▄▀   " ~ 
         "█ ▀▄▄ ",
    'L': "      " ~ 
         "█     " ~ 
         "█     " ~ 
         "█▄▄▄▄ ",
    'l': "      " ~ 
         " ▀█   " ~ 
         "  █   " ~ 
         "  █   ",
    'M': "      " ~ 
         "█▄ ▄█ " ~ 
         "█ █ █ " ~ 
         "█   █ ",
    'm': "      " ~ 
         "▄▄ ▄  " ~ 
         "█ █ █ " ~ 
         "█   █ ",
    'N': "      " ~ 
         "█▄  █ " ~ 
         "█ █ █ " ~ 
         "█  ▀█ ",
    'n': "      " ~ 
         "▄▄▄▄  " ~ 
         "█   █ " ~ 
         "█   █ ",
    'O': "      " ~ 
         "▄▀▀▀▄ " ~ 
         "█   █ " ~ 
         "▀▄▄▄▀ ",
    'o': "      " ~ 
         " ▄▄▄  " ~ 
         "█   █ " ~ 
         "▀▄▄▄▀ ",
    'P': "      " ~ 
         "█▀▀▀▄ " ~ 
         "█▄▄▄▀ " ~ 
         "█     ",
    'p': "      " ~ 
         "▄▄▄▄  " ~ 
         "█▄▄▄▀ " ~ 
         "█     ",
    'Q': "      " ~ 
         "▄▀▀▀▄ " ~ 
         "█   █ " ~ 
         "▀▄▄██ ",
    'q': "      " ~ 
         " ▄▄▄▄ " ~ 
         "▀▄▄▄█ " ~ 
         "    █ ",
    'R': "      " ~ 
         "█▀▀▀▄ " ~ 
         "█▄▄▄▀ " ~ 
         "█   █ ",
    'r': "      " ~ 
         "▄▄▄▄  " ~ 
         "█▄▄▄▀ " ~ 
         "█   █ ",
    'S': "      " ~ 
         "█▀▀▀▀ " ~ 
         "▀▀▀▀█ " ~ 
         "▄▄▄▄█ ",
    's': "      " ~ 
         " ▄▄▄▄ " ~ 
         "▀▄▄▄  " ~ 
         "▄▄▄▄▀ ",
    'T': "      " ~ 
         "▀▀█▀▀ " ~ 
         "  █   " ~ 
         "  █   ",
    't': "      " ~ 
         "  █   " ~ 
         "▀▀█▀▀ " ~ 
         "  █   ",
    'U': "      " ~ 
         "█   █ " ~ 
         "█   █ " ~ 
         "▀▄▄▄█ ",
    'u': "      " ~ 
         "▄   ▄ " ~ 
         "█   █ " ~ 
         "▀▄▄▄█ ",
    'V': "      " ~ 
         "█   █ " ~ 
         "█   █ " ~ 
         " ▀▄▀  ",
    'v': "      " ~ 
         "▄   ▄ " ~ 
         "█   █ " ~ 
         " ▀▄▀  ",
    'W': "      " ~ 
         "█   █ " ~ 
         "█ ▄ █ " ~ 
         "▀▄▀▄▀ ",
    'w': "      " ~ 
         "▄   ▄ " ~
         "█ ▄ █ " ~ 
         "▀▄▀▄▀ ", 
    'X': "      " ~ 
         "▀▄ ▄▀ " ~ 
         " ▄▀▄  " ~ 
         "█   █ ",
    'x': "      " ~ 
         "▄   ▄ " ~ 
         " ▀▄▀  " ~ 
         "▄▀ ▀▄ ",
    'Y': "      " ~ 
         "█   █ " ~ 
         " ▀▄▀  " ~ 
         "  █   ",
    'y': "      " ~ 
         "▄   ▄ " ~ 
         "▀▄ ▄▀ " ~ 
         "  █   ",
    'Z': "      " ~ 
         "▀▀▀▀█ " ~ 
         " ▄▀▀  " ~ 
         "█▄▄▄▄ ",
    'z': "      " ~ 
         "▄▄▄▄▄ " ~ 
         "  ▄▀  " ~ 
         "▄█▄▄▄ ",
    '0': "      " ~ 
         "▄▀▀█▄ " ~ 
         "█ █ █ " ~ 
         "▀█▄▄▀ ",
    '1': "      " ~ 
         " ▄█   " ~ 
         "  █   " ~ 
         "  █   ",
    '2': "      " ~ 
         "▄▀▀▀▄ " ~ 
         " ▄▄▀  " ~ 
         "█▄▄▄▄ ",
    '3': "      " ~ 
         "▄▀▀▀▄ " ~ 
         "   ▀▄ " ~ 
         "▀▄▄▄▀ ",
    '4': "      " ~ 
         "█   █ " ~ 
         "▀▀▀▀█ " ~ 
         "    █ ",
    '5': "      " ~ 
         "█▀▀▀▀ " ~ 
         "▀▀▀▀▄ " ~ 
         "▄▄▄▄▀ ",
    '6': "      " ~ 
         "▄▀▀▀  " ~ 
         "█▀▀▀▄ " ~ 
         "▀▄▄▄▀ ",
    '7': "      " ~ 
         "▀▀▀▀█ " ~ 
         "  ▄▀  " ~ 
         "  █   ",
    '8': "      " ~ 
         "▄▀▀▀▄ " ~ 
         "▄▀▀▀▄ " ~ 
         "▀▄▄▄▀ ",
    '9': "      " ~ 
         "▄▀▀▀▄ " ~ 
         "▀▄▄▄█ " ~ 
         " ▄▄▄▀ ",
    '&': "      " ~ 
         "▄▀▀▄  " ~ 
         "▀▄▀▄  " ~ 
         "▀▄▄█▄ ",
    '*': "      " ~ 
         " ▄ ▄  " ~ 
         " ▄▀▄  " ~ 
         "      ",
    '+': "      " ~ 
         "  ▄   " ~ 
         " ▀█▀  " ~ 
         "      ",
    '-': "      " ~ 
         "      " ~ 
         " ▀▀▀  " ~ 
         "      ",
    '~': "      " ~ 
         "  ▄ ▄ " ~ 
         " ▀ ▀  " ~ 
         "      ",
    '_': "      " ~ 
         "      " ~ 
         "      " ~ 
         " ▄▄▄  ",
    '=': "      " ~ 
         " ▀▀▀  " ~ 
         " ▀▀▀  " ~ 
         "      ",
    '.': "      " ~ 
         "      " ~  
         "      " ~  
         "  ▄   ",
    '!': "      " ~ 
         "  █   " ~ 
         "  █   " ~
         "  ▄   ", 
    '"': "      " ~ 
         "  █ █ " ~ 
         "      " ~  
         "      ",
    '\'':"      " ~ 
         "   █  " ~ 
         "      " ~  
         "      ",
    '`': "      " ~ 
         "  ▀▄  " ~ 
         "      " ~  
         "      ",
    '#': "      " ~ 
         "▄█▄█▄ " ~ 
         " █ █  " ~ 
         "▀█▀█▀ ",
    '$': "      " ~ 
         "▄▀█▀▀ " ~ 
         "▀▀█▀█ " ~ 
         "▄▄█▄▀ ",
    '%': "      " ~ 
         "▄  ▄▀ " ~ 
         "  █   " ~ 
         "▄▀  ▀ ",
    '^': "      " ~ 
         " ▄▀▄  " ~ 
         "      " ~  
         "      ",
    ',': "      " ~ 
         "      " ~  
         "      " ~  
         "  ▄▀  ",
    ':': "      " ~ 
         "   ▄  " ~ 
         "      " ~  
         "  ▄▀  ",
    ';': "      " ~ 
         "  ▄   " ~ 
         "      " ~  
         "  ▀   ",
    '?': "      " ~ 
         "▄▀▀▀▄ " ~ 
         "  ▄▄▀ " ~
         "  ▄   ", 
    '@': "      " ~ 
         " ▄▄▄  " ~ 
         "██▀ █ " ~ 
         "▀▄██▄ ",
    '/': "      " ~ 
         "   ▄▀ " ~ 
         "  █   " ~ 
         "▄▀    ",
    '<': "      " ~ 
         " ▄▄▀▀ " ~ 
         "▀▄▄   " ~ 
         "   ▀▀ ",
    '>': "      " ~ 
         "▀▀▄▄  " ~ 
         "  ▄▄▀ " ~ 
         "▀▀    ",
    '|': "      " ~ 
         "  █   " ~ 
         "  █   " ~
         "  █   ", 
    '\\':"      " ~ 
         "▀▄    " ~ 
         "  █   " ~ 
         "   ▀▄ ",
    '(': "      " ~ 
         " ▄▀▀  " ~ 
         " █    " ~ 
         " ▀▄▄  ",
    ')': "      " ~ 
         " ▀▀▄  " ~ 
         "   █  " ~ 
         " ▄▄▀  ",
    '[': "      " ~ 
         " █▀▀  " ~ 
         " █    " ~ 
         " █▄▄  ",
    ']': "      " ~ 
         " ▀▀█  " ~ 
         "   █  " ~ 
         " ▄▄█  ",
    '{': "      " ~ 
         " ▄▀▀  " ~ 
         "▀█    " ~ 
         " ▀▄▄  ",
    '}': "      " ~ 
         " ▀▀▄  " ~ 
         "   █▀ " ~ 
         " ▄▄▀  ",
    ];
    /* -------------------------------------------------------------------------- */
    pixelFont3x4 = [
    '\0':"    " ~ 
         "    " ~ 
         "    ",
    ' ': "    " ~ 
         "    " ~ 
         "    " ~ 
         "    ",
    'A': "    " ~ 
         "▄▀█ " ~ 
         "█▀█ ",
    'B': "    " ~ 
         "█▄▄ " ~ 
         "█▄█ ",
    'C': "    " ~ 
         "█▀▀ " ~ 
         "█▄▄ ",
    'D': "    " ~ 
         "█▀▄ " ~ 
         "█▄▀ ",
    'E': "    " ~ 
         "█▀▀ " ~ 
         "██▄ ",
    'F': "    " ~ 
         "█▀▀ " ~ 
         "█▀  ",
    'G': "    " ~ 
         "█▀▀ " ~ 
         "█▄█ ",
    'H': "    " ~ 
         "█ █ " ~ 
         "█▀█ ",
    'I': "    " ~ 
         " █  " ~ 
         " █  ",
    'J': "    " ~ 
         "  █ " ~ 
         "█▄█ ",
    'K': "    " ~ 
         "█▄▀ " ~ 
         "█ █ ",
    'L': "    " ~ 
         "█   " ~ 
         "█▄▄ ",
    'M': "    " ~ 
         "█▄█ " ~ 
         "█ █ ",
    'N': "    " ~ 
         "█▀█ " ~ 
         "█ █ ",
    'O': "    " ~ 
         "█▀█ " ~ 
         "█▄█ ",
    'P': "    " ~ 
         "█▀█ " ~ 
         "█▀▀ ",
    'Q': "    " ~ 
         "█▀█ " ~ 
         "▀▀█ ",
    'R': "    " ~ 
         "█▀█ " ~ 
         "█▀▄ ",
    'S': "    " ~ 
         "██▀ " ~ 
         "▄▄█ ",
    'T': "    " ~ 
         "▀█▀ " ~ 
         " █  ",
    'U': "    " ~ 
         "█ █ " ~ 
         "█▄█ ",
    'V': "    " ~ 
         "█ █ " ~ 
         "▀▄▀ ",
    'W': "    " ~ 
         "█ █ " ~ 
         "▀██ ",
    'X': "    " ~ 
         "▀▄▀ " ~ 
         "█ █ ",
    'Y': "    " ~ 
         "█▄█ " ~ 
         " █  ",
    'Z': "    " ~ 
         "▀██ " ~ 
         "█▄▄ ",
    '0': "    " ~ 
         "█▀█ " ~ 
         "█▄█ ",
    '1': "    " ~ 
         "▄█  " ~ 
         " █  ",
    '2': "    " ~ 
         "▀██ " ~ 
         "█▄▄ ",
    '3': "    " ~ 
         "▀▀█ " ~ 
         "▄██ ",
    '4': "    " ~ 
         "█ █ " ~ 
         "▀▀█ ",
    '5': "    " ~ 
         "██▀ " ~ 
         "▄▄█ ",
    '6': "    " ~ 
         "█▄▄ " ~ 
         "█▄█ ",
    '7': "    " ~ 
         "▀▀█ " ~ 
         "  █ ",
    '8': "    " ~ 
         "█▀█ " ~ 
         "███ ",
    '9': "    " ~ 
         "█▀█ " ~ 
         "▀▀█ ",
    '&': "    " ~ 
         "▄▀█ " ~ 
         "██▄ ",
    '*': "    " ~ 
         "▀▄▀ " ~ 
         "▀ ▀ ",
    '+': "    " ~ 
         "▄█▄ " ~ 
         " ▀  ",
    '-': "    " ~ 
         "▄▄▄ " ~ 
         "    ",
    '~': "    " ~ 
         "    " ~ 
         "▄▀▀ ",
    '_': "    " ~ 
         "    " ~ 
         "▄▄▄ ",
    '=': "    " ~ 
         "▄▄▄ " ~ 
         "▄▄▄ ",
    '.': "    " ~ 
         "    " ~  
         " ▄  ",
    '!': "    " ~ 
         " █  " ~
         " ▄  ", 
    '"': "    " ~ 
         "▀ ▀ " ~  
         "    ",
    '\'':"    " ~ 
         " ▀  " ~  
         "    ",
    '`': "    " ~ 
         " ▀▄ " ~  
         "    ",
    '#': "    " ~ 
         "█▄█ " ~ 
         "█▀█ ",
    '$': "    " ~ 
         "██▀ " ~ 
         "▄██ ",
    '%': "    " ~ 
         "▀▄▀ " ~ 
         "█ ▄ ",
    '^': "    " ~ 
         " ▄  " ~  
         "▀ ▀ ",
    ',': "    " ~ 
         "    " ~  
         " ▄▀ ",
    ':': "    " ~ 
         " ▀  " ~  
         " ▄  ",
    ';': "    " ~ 
         " ▀  " ~  
         " ▄▀ ",
    '?': "    " ~ 
         "▀█  " ~
         " ▄  ", 
    '@': "    " ~ 
         "▄▀█ " ~ 
         "█▄█ ",
    '/': "    " ~ 
         " ▄▀ " ~ 
         "█   ",
    '<': "    " ~ 
         " ▄▄ " ~ 
         "▀▄▄ ",
    '>': "    " ~ 
         "▄▄  " ~ 
         "▄▄▀ ",
    '|': "    " ~ 
         " █  " ~
         " █  ", 
    '\\':"    " ~ 
         "▀▄  " ~ 
         "  █ ",
    '(': "    " ~ 
         "▄▀  " ~ 
         "▀▄  ",
    ')': "    " ~ 
         " ▀▄ " ~ 
         " ▄▀ ",
    '[': "    " ~ 
         "█▀  " ~ 
         "█▄  ",
    ']': "    " ~ 
         " ▀█ " ~ 
         " ▄█ ",
    '{': "    " ~ 
         "▄▀  " ~ 
         "█▄  ",
    '}': "    " ~ 
         " ▀▄ " ~ 
         " ▄█ ",
    ];
    cast(void) pixelFont5x6.rehash;
    cast(void) pixelFont3x4.rehash;
}

// TODO 3x4?

// ▄▀█ █▄▄ █▀▀ █▀▄ █▀▀ █▀▀ █▀▀ █ █ █   █ █▄▀ █   █▀▄▀█ █▄ █ █▀█ █▀█ █▀█ █▀█ █▀ ▀█▀ █ █ █ █ █ █ █ ▀▄▀ █▄█ ▀█
// █▀█ █▄█ █▄▄ █▄▀ ██▄ █▀  █▄█ █▀█ █ █▄█ █ █ █▄▄ █ ▀ █ █ ▀█ █▄█ █▀▀ ▀▀█ █▀▄ ▄█  █  █▄█ ▀▄▀ ▀▄▀▄▀ █ █  █  █▄

//  ▄█ ▀█ ▀█ █ █ █▀ █▄▄ ▀▀█ █▀█ █▀█ █▀█
//   █ █▄ ██ ▀▀█ ▄█ █▄█   █ ███ ▀▀█ █▄█ 

//  ▄▄ ▄█▄ ▀▀ ▀█ ▀ ▄▀ █ █ █▀ ▀█ ▀▄ 
//      ▀  ▀▀  ▄ ▄▀ ▄ █ ▄ █▄ ▄█   ▀▄

