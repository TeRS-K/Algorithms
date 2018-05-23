#include <stdio.h>
#include <stdlib.h>
#include "C12.h"


void add_bst(struct node **tloc, int k, int v){
	
	if (!(*tloc)) {
		struct node *t = malloc(sizeof(struct node));
		t->key = k;
		t->value = v;
		t->left = NULL;
		t->right = NULL;
		*tloc = t;
		return;
	}

	struct node *prev = malloc(sizeof(struct node));
	struct node *cur = *tloc;
	while (cur) {
		if (k < cur->key) {
			prev = cur;
			cur = cur->left;
		}
		else if (k > cur->key) {
			prev = cur;
			cur = cur->right;
		}
		else {
			cur->value = v;
			prev = cur;
			return;
		}
	}


	struct node *newnode = malloc(sizeof(struct node));
	newnode->key = k;
	newnode->value = v;
	newnode->left = NULL;
	newnode->right = NULL;
	if (k < prev->key) {
		prev->left = newnode;
	}
	else if (k > prev->key) {
		prev->right = newnode;
	}

	return;

}

void print_bst(struct node *t) {
	if (!t) {
		printf("\\");
	}
	else {
		printf("( %d ", t->key);
		print_bst(t->left);
		printf(" ");
		print_bst(t->right);
		printf(" )");
	}
}

void free_bst(struct node *t) {
	if (t) {
		free_bst(t->left);
		free_bst(t->right);
		free(t);
	}
}

struct node *search_bst(struct node *t, int k) {
	struct node *cur = t;
	while (cur) {
		if (k < cur->key) {
			cur = cur->left;
		}
		else if (k > cur->key) {
			cur = cur->right;
		}
		else {
			return cur;
		}
	}
	return NULL;
}