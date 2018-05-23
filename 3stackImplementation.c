#include "array.h"
//#include "array.o"
#include <stdio.h>

int main(){
    char op;
    int s;
    int i;
    int stack[3] = {0, 0, 0};
    int x = 0;

    while(scanf("%c", &op) == 1){

        if (op == 'u'){
            scanf("%d %d", &s, &i);
            if(s == 0){
                int b = stack[0]+stack[1];
                for (int a = stack[0]; a < b; b--){
                    put(b, get(b-1));
                }
                put(stack[0], i);
                stack[0]++;
            }
            else if(s == 1){
                put(stack[0]+stack[1], i);
                stack[1]++;
            }
            else {
                put(20-stack[2], i);
                stack[2]++;
            }
        }

        else if (op == 'o'){
            scanf("%d", &s);
            if (s == 0){
                printf("%d\n", get(stack[0]-1));
                int b = stack[0]+stack[1];
                for (int a = stack[0]; a < b; a++){
                    put(a-1, get(a));
                }
                stack[0]--;
            }
            else if(s == 1){
                printf("%d\n", get(stack[0]+stack[1]-1));
                stack[1]--;
            }
            else {
                printf("%d\n", get(21-stack[2]));
                stack[2]--;
            }
        }
        
    }
}