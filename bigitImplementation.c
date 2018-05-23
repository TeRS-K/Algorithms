#include "C7.h"
#include <stdlib.h>
#include <stdio.h>

struct Node *reverse(struct Node *lst);
struct Node *convert_num(int n);
struct Node *consNZero(int n, struct Node *lst);
void print_num_h(struct Node *nlst);

struct Node *cons_bigit(int bgt, struct Node *nxt){
    struct Node *s = malloc(sizeof(struct Node));
    s->bigit = bgt;
    s->next = nxt;
    return s;
}

void free_num(struct Node *blst){
    if (blst) {
        free_num(blst->next);
        free(blst);
    }
}

struct Node *copy_num(struct Node *nlst){
    struct Node *s = malloc(sizeof(struct Node));
    s->bigit = nlst->bigit;
    s->next = nlst->next;
    return s;
}

void print_num(struct Node *nlst) {
    if (!nlst) printf("0");
    else print_num_h(nlst);

}
void print_num_h(struct Node *nlst){
    if (nlst){        
        int n = nlst->bigit;
        if (!nlst->next) {
            printf("%d", n); 
        }            
        print_num_h(nlst->next);
        if (nlst->next) {
            if(0 <= n && n <= 9) 
                printf("000%d", n);
            else if (10 <= n && n <= 99)
                printf("00%d", n);
            else if (100 <= n && n <= 999)
                printf("0%d", n);
            else printf("%d", n);
        }
    }
}


struct Node *add(struct Node *n1lst, struct Node *n2lst) {
    
    struct Node *newlst = NULL;
    int length = 0;
    int adv = 0;

    while (1) {
        if (!n1lst && !n2lst) return reverse(newlst);
        
        if (n1lst && n2lst) {
            int a = n1lst->bigit;
            int b = n2lst->bigit;
            if (length > adv) {
                if (a + b + 1 < 10000) {
                    struct Node *temp = newlst; //看一下
                    newlst = cons_bigit(a + b + 1, newlst->next);
                    free(temp); //看一下
                }
                else {
                    struct Node *temp = newlst; //看一下
                    newlst = cons_bigit(1, cons_bigit(a + b - 9999, newlst->next));
                    length++;
                    free(temp); //看一下
                }
            }    

            else if (a + b < 10000){
                newlst = cons_bigit(a + b, newlst);
                length++;
            } 
            else {
                newlst = cons_bigit(1, cons_bigit(a + b - 10000, newlst));
                length += 2;
            }
            n1lst = n1lst->next;
            n2lst = n2lst->next;
        }

        else if (n1lst) {
            int a = n1lst->bigit;
            if (length > adv) { 
                if (a == 9999) {
                    struct Node *temp = newlst; //看一下
                    newlst = cons_bigit(1, (cons_bigit (0, newlst->next)));
                    length++;
                    free(temp); //看一下
                }                   
                else {
                    struct Node *temp = newlst; //看一下
                    newlst = (cons_bigit (a + 1, newlst->next));
                    free(temp); //看一下
                }
            }
            else newlst = cons_bigit(a, newlst);
            n1lst = n1lst->next;
        }

        else if (n2lst) {
            int b = n2lst->bigit;
            if (length > adv) { 
                if (b == 9999){
                    struct Node *temp = newlst; //看一下
                    newlst = cons_bigit(1, (cons_bigit (0, newlst->next)));
                    length++;
                    free(temp); //看一下
                }                    
                else {
                    struct Node *temp = newlst; //看一下
                    newlst = (cons_bigit (b + 1, newlst->next));
                    free(temp); //看一下
                }
            }
            else newlst = cons_bigit(b, newlst);
            n2lst = n2lst->next;
        }
        
        adv++;    
    }

}



struct Node *mult(struct Node *n1lst, struct Node *n2lst) {
    
    struct Node *newlst = NULL;
    if (!n1lst || !n2lst) return newlst;
    int counter = 0;

    for (struct Node *cur1 = n1lst; cur1; cur1 = cur1->next){

        int a  = cur1->bigit;
        struct Node *newlst2 = NULL;
        int length = 0;
        int adv = 0;
        
        for (struct Node *cur2 = n2lst; cur2; cur2 = cur2->next){
            
            int b = cur2->bigit;

            if (length > adv) {
                int n = a * b + newlst2->bigit;
                if (n < 10000) {
                    struct Node *temp = newlst2; //看一下
                    newlst2 = cons_bigit(n, newlst2->next);
                    free(temp); //看一下
                }
                else {
                    struct Node *temp = newlst2; //看一下
                    newlst2 = cons_bigit(n / 10000, cons_bigit(n % 10000, newlst2->next));
                    length++;
                    free(temp); //看一下
                }
            }  
            else if (a * b < 10000){
                newlst2 = cons_bigit(a * b, newlst2);
                length++;
            } 
            else {
                newlst2 = cons_bigit(a * b / 10000, cons_bigit((a * b) % 10000, newlst2));
                length += 2;
            }
            adv++;
        }
        struct Node *temp = newlst; //看一下
        newlst2 = consNZero(counter, reverse(newlst2)); //看一下
        newlst = add(newlst, newlst2);
        free_num(newlst2); //看一下
        free_num(temp); //看一下
        counter++;

    }
    return newlst;
}







struct Node *consNZero(int n, struct Node *lst) {
    while (n > 0) {
        lst = cons_bigit (0, lst);
        n--;
    }
    return lst;
}





struct Node *reverse(struct Node *lst) {
    struct Node *rlst = 0;
    for (struct Node *cur = lst; cur; ){
        struct Node *temp = cur->next;  // store cur->next because it will get mutated
        cur->next = rlst;   // the next node should point to the previous node
        rlst = cur;     // set it to be the previous node
        cur = temp;     // move to the next node
    }
    return rlst;
}



struct Node *convert_num(int n){
    struct Node *res = NULL;
    while (n > 0) {
        res = cons_bigit(n % 10000, res);
        n /= 10000;
    }
    return reverse(res);
}



