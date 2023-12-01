#include <stdio.h>
#include <stdbool.h>


struct Gate_record{ 
    char* GateName;
    int GateType;
    int Level;
    bool output;
    int Number;
    struct List fanout;
    struct List fanin;
    struct Gate_record next;
}; 

struct List{
    struct Gate_record g;
    struct List next;
};

int main() {
    int a=1;
    int b=8;
    int c= a+b;
    printf("c= %d\n", c);
    return 0;
}

