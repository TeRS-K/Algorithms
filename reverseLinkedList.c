#include "C6.h"

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