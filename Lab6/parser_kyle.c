#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>

#define MAX_GATE_NAME 10
#define MAX_LINE_LENGTH 4095

typedef enum {
    GATE_UNKNOWN = -1,
    GATE_DFF = 1,
    GATE_NOT = 2,
    GATE_AND = 3,
    GATE_NOR = 4,
    GATE_OR = 5,
    GATE_NAND= 6
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
    if (newGate == NULL) {
        perror("Failed to allocate memory for a new gate");
        exit(EXIT_FAILURE);
    }
    strncpy(newGate->GateName, name, MAX_GATE_NAME);
    newGate->GateName[MAX_GATE_NAME - 1] = '\0'; // Ensure null termination
    newGate->GateType = type;
    newGate->Level = -1; // Level will be set later
    newGate->output = false; // Will be set later if this gate is a circuit output
    newGate->Number = -1; // Number will be set later
    newGate->fanin = NULL;
    newGate->fanout = NULL;
    newGate->next = NULL;
    return newGate;
}

void addToList(List** list, char* name) {
    List* newList = (List*)malloc(sizeof(List));
    if (newList == NULL) {
        perror("Failed to allocate memory for a new list item");
        exit(EXIT_FAILURE);
    }
    strncpy(newList->name, name, MAX_GATE_NAME);
    newList->name[MAX_GATE_NAME - 1] = '\0'; // Ensure null termination
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
    // Gate not found, create it
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
bool assignLevel(Gate_record* inputs, Gate_record* dffs, int maxCount) {
    Gate_record* listNext = NULL;

    // Initialize levels for input gates
    for (Gate_record* l = inputs; l != NULL; l = l->next) {
        l->Level = 0;
        // Assuming insert_fanout inserts fanout gates to l->fanout
        // You may need to adapt this based on your actual implementation
        insertFanout(l, &listNext);
    }

    // Initialize levels for DFF gates
    for (Gate_record* l = dffs; l != NULL; l = l->next) {
        l->Level = 0;
        // Assuming insert_fanout inserts fanout gates to l->fanout
        // You may need to adapt this based on your actual implementation
        insertFanout(l, &listNext);
    }

    int counter = 0;

    while (listNext != NULL && counter < maxCount) {
        Gate_record* list = listNext;
        listNext = NULL;

        while (list != NULL) {
            if (gateMarked(list)) {
                list->Level = counter;
                // Assuming insert_fanout inserts fanout gates to list->fanout
                // You may need to adapt this based on your actual implementation
                insertFanout(list, &listNext);
                list = list->next;
            } else {
                Gate_record* temp = list->next;
                list->next = listNext;
                listNext = list;
                list = temp;
            }
        }
        counter++;
    }

    if (counter >= maxCount) {
        printf("Asynchronous Feedback\n");
        return false;
    }

    return true;
}


int main() {
    FILE* file = fopen("S35.txt", "r");
    if (file == NULL) {
        perror("Failed to open the file");
        return EXIT_FAILURE;
    }
    
    char line[MAX_LINE_LENGTH];
    Gate_record* head = NULL;

    while (fgets(line, sizeof(line), file)) {
        if (line[0] == '\n' || line[0] == '/') continue; // Skip empty lines and comments
        
        char* token = strtok(line, " ,();\t\n");
        if (token == NULL) continue;
        
        GateType type = gateTypeFromString(token);
        if (type == GATE_UNKNOWN) continue;

        char* gateName = strtok(NULL, " ,();\t\n");
        if (!gateName || gateName[0] != 'X' || gateName[1] != 'G') continue; // Skip if not an XG gate

        Gate_record* gate = findOrCreateGate(&head, gateName, type);
        char* firstConnection = strtok(NULL, " ,();\t\n"); // First connection is always fanout

        if (firstConnection) {
            addToList(&(gate->fanout), firstConnection);
        }

        char* connectionName;
        while ((connectionName = strtok(NULL, " ,();\t\n"))) {
            addToList(&(gate->fanin), connectionName);
        }
    }
    
    fclose(file);

    // Output the parsed gates and their connections
    for (Gate_record* current = head; current; current = current->next) {
        printf("Gate %s of type %d\n", current->GateName, current->GateType);
        for (List* f = current->fanin; f; f = f->next) {
            printf("  - Fanin: %s\n", f->name);
        }
        for (List* f = current->fanout; f; f = f->next) {
            printf("  - Fanout: %s\n", f->name);
        }
    }

    if (!assignLevel(head, NULL, 100)) {
        // Handle asynchronous feedback error
        return EXIT_FAILURE;
    }

    // Output the parsed gates and their connections with levels
    for (Gate_record* current = head; current; current = current->next) {
        printf("Gate %s of type %d at level %d\n", current->GateName, current->GateType, current->Level);
        for (List* f = current->fanin; f; f = f->next) {
            printf("  - Fanin: %s\n", f->name);
        }
        for (List* f = current->fanout; f; f = f->next) {
            printf("  - Fanout: %s\n", f->name);
        }
    }
    // Free allocated memory
    while (head) {
        Gate_record* gate = head;
        head = head->next;
        List* list;
        while ((list = gate->fanin)) {
            gate->fanin = list->next;
            free(list);
        }
        while ((list = gate->fanout)) {
            gate->fanout = list->next;
            free(list);
        }
        free(gate);
    }

    return EXIT_SUCCESS;
}
