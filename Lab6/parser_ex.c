#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>

#define MAX_GATE_NAME 10
#define MAX_LINE_LENGTH 4095
#define MAX_LEVEL 1000 

typedef enum {
    GATE_UNKNOWN = -1, GATE_DFF = 1, GATE_NOT = 2, GATE_AND = 3, GATE_NOR = 4, GATE_OR = 5, GATE_NAND = 6
} GateType;

typedef struct List {
    char name[MAX_GATE_NAME];
    struct List* next;
} List;

typedef struct Gate_record {
    char GateName[MAX_GATE_NAME];
    GateType GateType;
    int Level;
    bool output;
    int Number;
    List* fanin;
    List* fanout;
    struct Gate_record* next;
} Gate_record;

Gate_record* createGate(char* name, GateType type) {
    Gate_record* newGate = (Gate_record*)malloc(sizeof(Gate_record));
    strncpy(newGate->GateName, name, MAX_GATE_NAME);
    newGate->GateName[MAX_GATE_NAME - 1] = '\0';
    newGate->GateType = type;
    newGate->Level = -1;
    newGate->output = false;
    newGate->Number = -1;
    newGate->fanin = NULL;
    newGate->fanout = NULL;
    newGate->next = NULL;
    return newGate;
}

void addToList(List** list, char* name) {
    List* newList = (List*)malloc(sizeof(List));
    strncpy(newList->name, name, MAX_GATE_NAME);
    newList->name[MAX_GATE_NAME - 1] = '\0';
    newList->next = *list;
    *list = newList;
}

Gate_record* findOrCreateGate(Gate_record** head, char* name, GateType type) {
    Gate_record* current = *head;
    while (current) {
        if (strcmp(current->GateName, name) == 0) {
            return current;
        }
        current = current->next;
    }
    Gate_record* newGate = createGate(name, type);
    newGate->next = *head;
    *head = newGate;
    return newGate;
}

GateType gateTypeFromString(char* type) {
    if (strcmp(type, "dff1") == 0) return GATE_DFF;
    else if (strcmp(type, "not") == 0) return GATE_NOT;
    else if (strcmp(type, "and") == 0) return GATE_AND;
    else if (strcmp(type, "nor") == 0) return GATE_NOR;
    else if (strcmp(type, "or") == 0) return GATE_OR;
    else if (strcmp(type, "nand") == 0) return GATE_NAND;
    else if (strcmp(type, "dff") == 0) return GATE_DFF;
    return GATE_UNKNOWN;
}

void addUniqueNode(List** list, char* name) {
    List* current = *list;
    while (current) {
        if (strcmp(current->name, name) == 0) {
            return;
        }
        current = current->next;
    }
    addToList(list, name);
}

bool insert_fanout(Gate_record* gate, List** listNext) {
    for (List* f = gate->fanout; f != NULL; f = f->next) {
        addToList(listNext, f->name);
    }
    return true;
}

bool gate_marked(Gate_record* gate) {
    return gate->Level != -1;
}

bool assign_level(Gate_record* list_of_inputs, Gate_record* list_of_DFF) {
    Gate_record* ListNext = NULL;
    int Counter = 0;
    int Max_count = 100;

    for (Gate_record* l = list_of_inputs; l != NULL; l = l->next) {
        l->Level = 0;
        insert_fanout(l, &ListNext);
    }

    for (Gate_record* l = list_of_DFF; l != NULL; l = l->next) {
        l->Level = 0;
        insert_fanout(l, &ListNext);
    }

    while (ListNext != NULL && Counter < Max_count) {
        Gate_record* List = ListNext;
        ListNext = NULL;

        while (List != NULL) {
            if (gate_marked(List)) {
                List->Level = MAX_LEVEL;
                insert_fanout(List, &ListNext);
                List = List->next;
            } else {
                Gate_record* temp = List->next;
                List->next = ListNext;
                ListNext = List;
                List = temp;
            }
        }
        Counter++;
    }

    if (Counter >= Max_count) {
        printf("Asynchronous Feedback");
        return false;
    }
    return true;
}

int main() {
    FILE* file = fopen("S27.txt", "r");
    if (file == NULL) {
        perror("Failed to open the file");
        return EXIT_FAILURE;
    }

    char line[MAX_LINE_LENGTH];
    Gate_record* head = NULL;
    List* dffNodes = NULL;
    List* inputNodes = NULL;

    while (fgets(line, sizeof(line), file)) {
        if (line[0] == '\n' || line[0] == '/') continue;

        if (strncmp(line, "input", 5) == 0) {
            char* token = strtok(line, " ,();\t\n");
            while ((token = strtok(NULL, " ,();\t\n"))) {
                addUniqueNode(&inputNodes, token);
            }
            continue;
        }

        char* token = strtok(line, " ,();\t\n");
        if (token == NULL) continue;

        GateType type = gateTypeFromString(token);
        if (type == GATE_UNKNOWN) continue;

        char* gateName = strtok(NULL, " ,();\t\n");
        if (!gateName || gateName[0] != 'X' || gateName[1] != 'G') continue;

        Gate_record* gate = findOrCreateGate(&head, gateName, type);
        char* firstConnection = strtok(NULL, " ,();\t\n");

        if (firstConnection && type == GATE_DFF) {
            addUniqueNode(&dffNodes, firstConnection);
        }
        if (firstConnection) {
            addToList(&(gate->fanout), firstConnection);
        }


        char* connectionName;
        while ((connectionName = strtok(NULL, " ,();\t\n"))) {
            addToList(&(gate->fanin), connectionName);
        }
    }
    fclose(file);

    printf("Nodes that outputs of DFF gates:\n");
    for (List* current = dffNodes; current != NULL; current = current->next) {
        printf("%s\n", current->name);
    }

    printf("Input nodes of the circuit:\n");
    for (List* current = inputNodes; current != NULL; current = current->next) {
        printf("%s\n", current->name);
    }

    for (Gate_record* current = head; current; current = current->next) {
        printf("Gate %s of type %d\n", current->GateName, current->GateType);
        for (List* f = current->fanin; f; f = f->next) {
            printf("  - Fanin: %s\n", f->name);
        }
        for (List* f = current->fanout; f; f = f->next) {
            printf("  - Fanout: %s\n", f->name);
        }
    }

    if (!assign_level(inputNodes, dffNodes)) {
        fprintf(stderr, "Error in level assignment.\n");
        return EXIT_FAILURE;
    }

    while (head) {
        Gate_record* gate = head;
        head = head->next;
        while (gate->fanin) {
            List* list = gate->fanin;
            gate->fanin = list->next;
            free(list);
        }
        while (gate->fanout) {
            List* list = gate->fanout;
            gate->fanout = list->next;
            free(list);
        }
        free(gate);
    }
    while (dffNodes) {
        List* node = dffNodes;
        dffNodes = node->next;
        free(node);
    }
    while (inputNodes) {
        List* node = inputNodes;
        inputNodes = node->next;
        free(node);
    }

    return EXIT_SUCCESS;
}
