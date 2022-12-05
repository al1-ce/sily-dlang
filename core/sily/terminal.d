/// Utils to work with POSIX terminal
module sily.terminal;
import core.sys.posix.sys.ioctl: winsize, ioctl, TIOCGWINSZ;

static this() {
    version(windows) {
        import core.stdc.stdlib: exit;
        exit(2);
    }

    // To prevent from killing terminal by calling reset before set
    tcgetattr(stdin.fileno, &originalTermios);
}

/// Returns bash terminal width
int terminalWidth() {
    winsize w;
    ioctl(0, TIOCGWINSZ, &w);
    return w.ws_col;
}

/// Returns bash terminal height
int terminalHeight() {
    winsize w;
    ioctl(0, TIOCGWINSZ, &w);
    return w.ws_row;
}

import core.stdc.stdio: setvbuf, _IONBF, _IOLBF;
import core.stdc.stdlib: atexit;
import core.stdc.string: memcpy;
import core.sys.posix.termios: termios, tcgetattr, tcsetattr, TCSADRAIN; // TCSANOW
import core.sys.posix.unistd: read;
import core.sys.posix.sys.select: select, fd_set, FD_ZERO, FD_SET;
import core.sys.posix.sys.time: timeval;

import std.stdio: stdin, stdout;

private extern(C) void cfmakeraw(termios *termios_p);

private termios originalTermios;

private bool __isTermiosRaw = false;

/// Is terminal in raw mode (have `setTerminalModeRaw` been called yet?)
bool isTerminalRaw() nothrow {
    return __isTermiosRaw;
}

/// Resets termios back to default and buffers stdout
extern(C) alias resetTerminalMode = function() {
    tcsetattr(0, TCSADRAIN, &originalTermios);
    setvbuf(stdout.getFP, null, _IOLBF, 1024);
    __isTermiosRaw = false;
};

/** 
Creates new termios and unbuffers stdout. Required for `kbhit` and `getch`
DO NOT USE IF YOU DON'T KNOW WHAT YOU'RE DOING
In raw mode CRLF (`\r\n`) newline will be used required instead of normal LF (`\n`)
*/
void setTerminalModeRaw() {
    import core.sys.posix.termios;
    termios newTermios;

    tcgetattr(stdin.fileno, &originalTermios);
    memcpy(&newTermios, &originalTermios, termios.sizeof);

    cfmakeraw(&newTermios);

    newTermios.c_lflag &= ~(ICANON | ECHO | ISIG | IEXTEN);
    // newTermios.c_lflag &= ~(ICANON | ECHO);
    newTermios.c_iflag &= ~(ICRNL | INLCR | OPOST);
    newTermios.c_cc[VMIN] = 1;
    newTermios.c_cc[VTIME] = 0;

    setvbuf(stdout.getFP, null, _IONBF, 0);

    tcsetattr(stdin.fileno, TCSADRAIN, &newTermios);

    atexit(resetTerminalMode);
    __isTermiosRaw = true;
}

/// Returns 1 if any key was pressed
int kbhit() {
    timeval tv = { 0, 0 };
    fd_set fds;
    FD_ZERO(&fds);
    FD_SET(stdin.fileno, &fds);
    return select(1, &fds, null, null, &tv);
}

/// Returns last pressed key
int getch() {
    int r;
    uint c;

    if ((r = cast(int) read(stdin.fileno, &c, ubyte.sizeof)) < 0) {
        return r;
    } else {
        return c;
    }
}