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
    char state; // Add state field
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
    char state; // Add state field
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
void simulate_circuit(struct GateList* gate_list, struct Node* nodes);



int main() {
    struct GateList gate_list = { NULL };
    struct Node nodes[1000] = { 0 };

    read_circuit("S27.txt", &gate_list, nodes);  // Replace with the correct path to your file
    assign_levels(&gate_list, nodes);

    print_circuit(&gate_list);
    print_wires(nodes);
    print_level_summary(&gate_list);

    // Run simulation
    simulate_circuit(&gate_list, nodes);

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

// Helper function to interpret the state
int state_to_bool(char state) {
    return state == '1' ? 1 : state == '0' ? 0 : -1; // -1 for 'X' (undefined)
}
char evaluate(struct GateRecord* gate) {
    //printf("Evaluating Gate: %s, Type: %s\n", gate->GateName, gate->GateType);

    char result = 'X'; // Default to 'X'
    if (strcmp(gate->GateType, "and") == 0) {
        // AND gate logic
        // Assuming two-input logic gates for simplicity
        if (gate->fanin[0]->state == '0' || gate->fanin[1]->state == '0') {
            result = '0';
        } else if (gate->fanin[0]->state == '1' && gate->fanin[1]->state == '1') {
            result = '1';
        } else {
            result = 'X';
        }
    } else if (strcmp(gate->GateType, "or") == 0) {
        // OR gate logic
        if (gate->fanin[0]->state == '1' || gate->fanin[1]->state == '1') {
            result = '1';
        } else if (gate->fanin[0]->state == '0' && gate->fanin[1]->state == '0') {
            result = '0';
        } else {
            result = 'X';
        }
    } else if (strcmp(gate->GateType, "xor") == 0) {
        // XOR gate logic
        if (gate->fanin[0]->state == 'X' || gate->fanin[1]->state == 'X') {
            result = 'X';
        } else if (gate->fanin[0]->state != gate->fanin[1]->state) {
            result = '1';
        } else {
            result = '0';
        }
    } else if (strcmp(gate->GateType, "nand") == 0) {
        // NAND gate logic
        if (gate->fanin[0]->state == '0' || gate->fanin[1]->state == '0') {
            result = '1';
        } else if (gate->fanin[0]->state == '1' && gate->fanin[1]->state == '1') {
            result = '0';
        } else {
            result = 'X';
        }
    } else if (strcmp(gate->GateType, "nor") == 0) {
        // NOR gate logic
        if (gate->fanin[0]->state == '1' || gate->fanin[1]->state == '1') {
            result = '0';
        } else if (gate->fanin[0]->state == '0' && gate->fanin[1]->state == '0') {
            result = '1';
        } else {
            result = 'X';
        }
    } else if (strcmp(gate->GateType, "not") == 0) {
        // NOT gate logic
        if (gate->fanin[0]->state == '1') {
            result = '0';
        } else if (gate->fanin[0]->state == '0') {
            result = '1';
        } else {
            result = 'X';
        }
    } else if (strcmp(gate->GateType, "dff") == 0 || strcmp(gate->GateType, "dff1") == 0) {
    // DFF gate logic
    // For simplicity, assume the output is updated to the input state in each cycle
    if (gate->fanin[0] != NULL) {
        result = gate->fanin[0]->state; // Output same as input state
    } else {
        printf("Error: DFF gate %s has no input\n", gate->GateName);
        result = 'X'; // Undefined if no input
    }
}

  if (strcmp(gate->GateType, "dff") == 0 || strcmp(gate->GateType, "dff1") == 0) {
        // Check if the state is not set and assign 'X' if so
        if (gate->state != '0' && gate->state != '1') {
            gate->state = 'X';
        }
        printf("Result for DFF Gate %s: State = %c\n", gate->GateName, gate->state);
    }
    return result;
}

void simulate_circuit(struct GateList* gate_list, struct Node* nodes) {
    char input;
    int continueSimulation = 1;

    while (continueSimulation) {
        // Prompt for input values
        printf("---------------------------------------------------\n");
        printf("\n");
        printf("Enter values for inputs (0, 1, X).\n");
        for (int i = 0; i < 1000 && nodes[i].NodeName[0] != '\0'; ++i) {
            if (!nodes[i].isFanout) {
                printf("Enter value for input %s (0, 1, X): ", nodes[i].NodeName);
                scanf(" %c", &input);
                if (input == '0' || input == '1' || input == 'X') {
                    nodes[i].state = input;
                } else {
                    printf("Invalid input. Please enter 0, 1, or X.\n");
                    i--; // Ask for the same input again
                }
            }
        }

        // Evaluate all gates and update fanout node states
        struct GateRecord* current = gate_list->head;
        while (current != NULL) {
            current->state = evaluate(current);
            if (current->fanout != NULL) {
                current->fanout->state = current->state;
                //printf("Gate %s evaluated to %c, updating node %s to %c\n", current->GateName, current->state, current->fanout->NodeName, current->fanout->state);
            }
            current = current->next;
        }

        // Print node states
        printf("Node States:\n");
        for (int i = 0; i < 1000 && nodes[i].NodeName[0] != '\0'; ++i) {
            char stateToPrint = nodes[i].state;
            if (stateToPrint == '\0') { // If no state, print 'X'
                stateToPrint = 'X';
            }
            printf("Node %s: State = %c\n", nodes[i].NodeName, stateToPrint);
        }

        // Check if the user wants to continue the simulation
        printf("Continue simulation? (1 for yes, 0 for no): ");
        scanf("%d", &continueSimulation);
        if (continueSimulation != 1) {
            continueSimulation = 0;
        }
    }
}
