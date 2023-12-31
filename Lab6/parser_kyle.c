#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// Define structures
struct Node {
    char NodeName[50];
    struct GateRecord* gates[50];
    int isFanout;
    int isDffFanout;
    int Level;
    struct Node* next;
};

struct GateRecord {
    char GateName[50];
    char GateType[50];
    int Level;
    int output;
    int Number;
    struct Node* fanout;
    struct Node** fanin[50];
    struct GateRecord* next;
};

struct GateList {
    struct GateRecord* head;
};

// Function prototypes
struct GateRecord* find_gate(struct GateList* gate_list, char* name);
void add_gate(struct GateList* gate_list, struct GateRecord* gate);
void read_circuit(char* filename, struct GateList* gate_list, struct Node* nodes);
void assign_levels(struct GateList* gate_list, struct Node* nodes);
void print_wires(struct Node* nodes);
void print_circuit(struct GateList* gate_list);
void print_level_summary(struct GateList* gate_list);

int main() {
    struct GateList gate_list = { NULL };
    struct Node nodes[1000] = { 0 };

    read_circuit("S35.txt", &gate_list, nodes);  // Replace with the correct path to your file
    assign_levels(&gate_list, nodes);

    print_circuit(&gate_list);
    print_wires(nodes);
    print_level_summary(&gate_list);

    return 0;
}

// Function implementations

// Function implementations
struct GateRecord* find_gate(struct GateList* gate_list, char* name) {
    struct GateRecord* current = gate_list->head;
    while (current != NULL) {
        if (strcmp(current->GateName, name) == 0) {
            return current;
        }
        current = current->next;
    }
    return NULL;
}

void add_gate(struct GateList* gate_list, struct GateRecord* gate) {
    if (gate_list->head == NULL) {
        gate_list->head = gate;
    } else {
        struct GateRecord* current = gate_list->head;
        while (current->next != NULL) {
            current = current->next;
        }
        current->next = gate;
    }
}

void read_circuit(char* filename, struct GateList* gate_list, struct Node* nodes) {
    FILE *file = fopen(filename, "r");
    if (!file) {
        perror("Error opening file");
        exit(EXIT_FAILURE);
    }

    char line[256];
    while (fgets(line, sizeof(line), file)) {
        char gate_type[50], gate_name[50], net_names[256];
        int result = sscanf(line, "%s %s (%[^)])", gate_type, gate_name, net_names);
        if (result != 3) {
            continue;  // Skip lines without the expected format
        }

        struct GateRecord* gate = find_gate(gate_list, gate_name);
        if (!gate) {
            gate = (struct GateRecord*)malloc(sizeof(struct GateRecord));
            strcpy(gate->GateName, gate_name);
            strcpy(gate->GateType, gate_type);
            gate->Level = -1;
            gate->output = 0;
            gate->Number = 0;
            gate->fanout = NULL;
            gate->next = NULL;
            add_gate(gate_list, gate);
        }

        char* net_name = strtok(net_names, ",");
        int i = 0;
        while (net_name != NULL) {
            struct Node* node = NULL;
            for (int j = 0; j < 1000; ++j) {
                if (strcmp(nodes[j].NodeName, net_name) == 0) {
                    node = &nodes[j];
                    break;
                }
            }

            if (!node) {
                for (int j = 0; j < 1000; ++j) {
                    if (nodes[j].NodeName[0] == '\0') {
                        strcpy(nodes[j].NodeName, net_name);
                        node = &nodes[j];
                        break;
                    }
                }
            }

            if (i == 0) {
                gate->fanout = node;
                node->isFanout = 1;
                if ((strncmp(gate_type, "dff1", 3) == 0)||(strncmp(gate_type, "dff", 3) == 0)) {
                    node->isDffFanout = 1;
                }
            } else {
                gate->fanin[i - 1] = node;
            }

            node->gates[node->isDffFanout ? 0 : node->isFanout ? 1 : 0] = gate;
            ++i;
            net_name = strtok(NULL, ",");
        }
    }

    fclose(file);
}

void assign_levels(struct GateList* gate_list, struct Node* nodes) {
    // Set DFF gates and nodes to level 0
    struct GateRecord* current = gate_list->head;
    while (current != NULL) {
        if ((strncmp(current->GateType, "dff1", 3) == 0)||(strncmp(current->GateType, "dff", 3) == 0)) {
            current->Level = 0;
            if (current->fanout != NULL) {
                current->fanout->Level = 0;
                current->fanout->isDffFanout = 1;
            }
        }
        current = current->next;
    }

    // Assign levels to other gates
    int all_gates_assigned = 0;
    while (!all_gates_assigned) {
        all_gates_assigned = 1;
        current = gate_list->head;
        while (current != NULL) {
            if (current->Level < 0) {
                int all_assigned = 1;
                for (int i = 0; i < 50 && current->fanin[i] != NULL; ++i) {
                    if (current->fanin[i]->Level < 0) {
                        all_assigned = 0;
                        break;
                    }
                }

                if (all_assigned) {
                    int highest_fanin_level = -1;
                    for (int i = 0; i < 50 && current->fanin[i] != NULL; ++i) {
                        if (current->fanin[i]->Level > highest_fanin_level) {
                            highest_fanin_level = current->fanin[i]->Level;
                        }
                    }

                    current->Level = highest_fanin_level + 1;
                    if (current->fanout && !current->fanout->isDffFanout) {
                        current->fanout->Level = current->Level;
                    }

                    all_gates_assigned = 0;
                }
            }
            current = current->next;
        }
    }
}

// ... [Insert existing function implementations for find_gate, add_gate, read_circuit, etc.] ...

void print_level_summary(struct GateList* gate_list) {
    int level_count[1000] = {0};  // Adjust size as needed
    int total_gates = 0;
    struct GateRecord* current = gate_list->head;

    while (current != NULL) {
        total_gates++;
        if (current->Level >= 0) {
            level_count[current->Level]++;
        }
        current = current->next;
    }
    printf("---------------------------------------------------\n");
    printf("Total number of gates: %d\n", total_gates);
    for (int i = 0; i < 1000; i++) {
        if (level_count[i] > 0) {
            printf("Level %d: %d gates\n", i, level_count[i]);
        }
    }
}

void print_wires(struct Node* nodes) {
    printf("List of all wires (nodes), their levels, and connected gates:\n");
    for (int i = 0; i < 1000 && nodes[i].NodeName[0] != '\0'; ++i) {
        printf("Wire: %s, Level: %d", nodes[i].NodeName, nodes[i].Level);
        for (int j = 0; j < 50 && nodes[i].gates[j] != NULL; ++j) {
            //printf("%s, ", nodes[i].gates[j]->GateName);
        }
        printf("\n");
    }
}

void print_circuit(struct GateList* gate_list) {
    struct GateRecord* current = gate_list->head;
    while (current != NULL) {
        printf("Gate: %s, Type: %s, Level: %d, Fanout: %s, Fanin: ", current->GateName, current->GateType, current->Level, current->fanout ? current->fanout->NodeName : "None");
        for (int i = 0; i < 50 && current->fanin[i] != NULL; ++i) {
            printf("%s, ", current->fanin[i]->NodeName);
        }
        printf("\n");
        current = current->next;
    }
}
