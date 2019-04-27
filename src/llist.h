/* llist.h
 * Generic Linked List
 * https://gist.github.com/meylingtaing/11018042
 */

struct node {
    void *data;
    struct node *next;
};

typedef struct node * llist;

/* llist_create: Create a linked list */
llist *llist_create(void *data);

/* llist_free: Free a linked list */
void llist_free(llist *list);

/* llist_push: Add to head of list */
void llist_push(llist *list, void *data);

/* llist_print: print linked list */
void llist_print(llist *list);
