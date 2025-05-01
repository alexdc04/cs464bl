void kmain(void) {
    char* vid_mem = (char*) 0xb8000;
    
    vid_mem[0] = 'H';
    vid_mem[1] = 'i';

    while (1) {} // halt
}
