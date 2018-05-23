#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "C10.h"

struct hash make_table(int s){
	struct hash h;
	h.size = s;
	h.table = malloc(sizeof(struct anode *) * s);
	for (int i = 0; i < s; i++) {
		h.table[i] = NULL;
	}
	return h;
}


char *search(struct hash T, int k) {
	int i = hash(k, T.size);
	struct anode *cur =T.table[i];
	while (cur) {
		if (cur->key == k)
			return cur->value;
		else cur = cur->next;
	}
	return NULL;
}

int hash (int k, int s) {
	int i;
	if (k >=0) {
		i = k % s;
	}
	else {
		i = k * (-1) % s;
	}
	return i;
}

void add(struct hash T, int k, char *v) {
	int i = hash(k, T.size);

	if (!T.table[i]) {
		struct anode *cur = malloc(sizeof(struct anode));
		cur->key = k;
		cur->value = malloc(sizeof(char) * (strlen(v) + 1));
		strcpy(cur->value, v);
		cur->next = NULL;
		T.table[i] = cur;
	}
	else {

		struct anode *cur = T.table[i];
		struct anode *prev;
		while (cur && (cur->key != k)) {
			prev = cur;
			cur = cur->next;
		}
		if (!cur) {
			struct anode *new = malloc(sizeof(struct anode));
			new->key = k;
			new->value = malloc(sizeof(char) * (strlen(v) + 1));
			strcpy(new->value, v);
			new->next = NULL;
			prev->next=new;
		}
		else {
			free(cur->value);
			cur->value = malloc(sizeof(char) * (strlen(v) + 1));
			strcpy(cur->value, v);
		}
	}
}



void free_table(struct hash T) {
	int len = T.size;
	for (int i = 0; i < len; i++) {
		for (struct anode *cur = T.table[i]; cur; ) {
			struct anode *temp = cur;
			cur = cur->next;
			free(temp->value);
			free(temp);
		}
	}
	free(T.table);
}

void delete(struct hash T, int k) {
	if (search (T, k) != NULL) {
		int i = hash(k, T.size);
		int keyy = (T.table[i])->key;
		if (keyy == k) {
			struct anode *temp = T.table[i];
			T.table[i] = (T.table[i])->next;
			free(temp->value);
			free(temp);
		}
		else {
			struct anode *cur;
			struct anode *prev;
			for (cur = T.table[i]; cur->key != k; ) {
				prev = cur;
				cur = cur->next;
			}
			prev->next = cur->next;
			free(cur->value);
			free(cur);
		}

	}
}



