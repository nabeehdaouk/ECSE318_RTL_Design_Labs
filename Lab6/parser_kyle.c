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
};

struct GateRecord {
    char GateName[50];
    char GateType[50];
    int Level;
    int output;
    int Number;
    struct Node* fanout;
    struct Node* fanin[50];
    struct GateRecord* next;
};

struct GateList {
    struct GateRecord* head;
};

// Function prototypes
struct GateRecord* find_gate(struct GateList* gate_list, char* name);
void add_gate(struct GateList* gate_list, struct GateRecord* gate);
void read_circuit(char* filename, struct GateList* gate_list, struct Node* nodes);
void determine_inputs(struct Node* nodes, char* result[], int* size);
void determine_dff_outputs(struct Node* nodes, char* result[], int* size);
void assign_levels(struct GateList* gate_list, struct Node* nodes, char** initial_nodes, int initial_nodes_size, char** dff_output_nodes, int dff_output_nodes_size);
void print_wires(struct Node* nodes);
void print_circuit(struct GateList* gate_list);

int main() {
    struct GateList gate_list;
    struct Node nodes[1000];

    // Example Usage
    read_circuit("S27.txt", &gate_list, nodes);

    int input_nodes_size, dff_output_nodes_size;
    char* input_nodes[100];
    char* dff_output_nodes[100];

    determine_inputs(nodes, input_nodes, &input_nodes_size);
    determine_dff_outputs(nodes, dff_output_nodes, &dff_output_nodes_size);

    char* all_initial_nodes[200];
    for (int i = 0; i < input_nodes_size; ++i) {
        all_initial_nodes[i] = input_nodes[i];
    }
    for (int i = 0; i < dff_output_nodes_size; ++i) {
        all_initial_nodes[input_nodes_size + i] = dff_output_nodes[i];
    }

    assign_levels(&gate_list, nodes, all_initial_nodes, input_nodes_size, dff_output_nodes, dff_output_nodes_size);

    print_circuit(&gate_list);
    print_wires(nodes);

    return 0;
}

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
                if (strncmp(gate_type, "DFF", 3) == 0) {
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

void determine_inputs(struct Node* nodes, char* result[], int* size) {
    *size = 0;
    for (int i = 0; i < 1000; ++i) {
        if (nodes[i].NodeName[0] != '\0' && !nodes[i].isFanout) {
            result[(*size)++] = nodes[i].NodeName;
        }
    }
}

void determine_dff_outputs(struct Node* nodes, char* result[], int* size) {
    *size = 0;
    for (int i = 0; i < 1000; ++i) {
        if (nodes[i].NodeName[0] != '\0' && nodes[i].isDffFanout) {
            result[(*size)++] = nodes[i].NodeName;
        }
    }
}

void assign_levels(struct GateList* gate_list, struct Node* nodes, char** initial_nodes, int initial_nodes_size, char** dff_output_nodes, int dff_output_nodes_size) {
    for (int i = 0; i < initial_nodes_size; ++i) {
        for (int j = 0; j < 1000; ++j) {
            if (strcmp(nodes[j].NodeName, initial_nodes[i]) == 0) {
                nodes[j].Level = 0;
                break;
            }
        }
    }

    for (int i = 0; i < dff_output_nodes_size; ++i) {
        for (int j = 0; j < 1000; ++j) {
            if (strcmp(nodes[j].NodeName, dff_output_nodes[i]) == 0) {
                nodes[j].Level = 0;
                nodes[j].isDffFanout = 1;
                break;
            }
        }
    }

    struct GateRecord* current = gate_list->head;
    while (current != NULL) {
        if (strncmp(current->GateType, "DFF", 3) == 0) {
            current->Level = 0;
        }
        current = current->next;
    }

    int all_gates_assigned = 0;
    while (!all_gates_assigned) {
        all_gates_assigned = 1;
        struct GateRecord* current = gate_list->head;
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

void print_wires(struct Node* nodes) {
    printf("List of all wires (nodes), their levels, and connected gates:\n");
    for (int i = 0; i < 1000 && nodes[i].NodeName[0] != '\0'; ++i) {
        printf("Wire: %s, Level: %d, Connected Gates: ", nodes[i].NodeName, nodes[i].Level);
        for (int j = 0; j < 50 && nodes[i].gates[j] != NULL; ++j) {
            printf("%s, ", nodes[i].gates[j]->GateName);
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
