#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct GateRecord {
    char GateName[50];
    char GateType[50];
    int Level;
    int output;
    int Number;
    struct GateRecord* fanout;
    struct Node** fanin;
    struct GateRecord* next;
    char state;
} GateRecord;

typedef struct Node {
    char NodeName[50];
    struct GateRecord** gates;
    int isFanout;
    int isDffFanout;
    int Level;
    char state;
} Node;

typedef struct GateList {
    struct GateRecord* head;
} GateList;

GateList* create_gate_list() {
    GateList* gate_list = (GateList*)malloc(sizeof(GateList));
    gate_list->head = NULL;
    return gate_list;
}

void add_gate(GateList* gate_list, GateRecord* gate) {
    if (gate_list->head == NULL) {
        gate_list->head = gate;
    }
    else {
        GateRecord* current = gate_list->head;
        while (current->next != NULL) {
            current = current->next;
        }
        current->next = gate;
    }
}

GateRecord* find_gate(GateList* gate_list, char* name) {
    GateRecord* current = gate_list->head;
    while (current != NULL) {
        if (strcmp(current->GateName, name) == 0) {
            return current;
        }
        current = current->next;
    }
    return NULL;
}

typedef struct Circuit {
    GateList* gate_list;
    Node** nodes;
} Circuit;

Circuit* read_circuit(char* filename) {
    Circuit* circuit = (Circuit*)malloc(sizeof(Circuit));
    circuit->gate_list = create_gate_list();
    circuit->nodes = (Node**)malloc(sizeof(Node*) * 1000);
    for (int i = 0; i < 1000; i++) {
        circuit->nodes[i] = NULL;
    }
    FILE* file = fopen(filename, "r");
    if (file == NULL) {
        printf("Failed to open file\n");
        return circuit;
    }
    char line[1000];
    while (fgets(line, sizeof(line), file)) {
        char* parts[3];
        int part_count = 0;
        char* token = strtok(line, " ");
        while (token != NULL) {
            parts[part_count] = token;
            part_count++;
            token = strtok(NULL, " ");
        }
        if (part_count < 3 || strchr(parts[2], '(') == NULL) {
            continue;
        }
        char* gate_type = parts[0];
        char* gate_name = parts[1];
        char* net_names[100];
        int net_count = 0;
        char* net_token = strtok(parts[2], "();,");
        while (net_token != NULL) {
            net_names[net_count] = net_token;
            net_count++;
            net_token = strtok(NULL, "();,");
        }
        GateRecord* gate = find_gate(circuit->gate_list, gate_name);
        if (gate == NULL) {
            gate = (GateRecord*)malloc(sizeof(GateRecord));
            strcpy(gate->GateName, gate_name);
            strcpy(gate->GateType, gate_type);
            gate->Level = -1;
            gate->output = 0;
            gate->Number = 0;
            gate->fanout = NULL;
            gate->fanin = (Node**)malloc(sizeof(Node*) * net_count);
            gate->next = NULL;
            gate->state = 'X';
            add_gate(circuit->gate_list, gate);
        }
        for (int i = 0; i < net_count; i++) {
            Node* node = circuit->nodes[atoi(net_names[i])];
            if (node == NULL) {
                node = (Node*)malloc(sizeof(Node));
                strcpy(node->NodeName, net_names[i]);
                node->gates = (GateRecord**)malloc(sizeof(GateRecord*) * 100);
                node->isFanout = 0;
                node->isDffFanout = 0;
                node->Level = -1;
                node->state = 'X';
                circuit->nodes[atoi(net_names[i])] = node;
            }
            if (i == 0) {
                gate->fanout = node;
                node->isFanout = 1;
                if (strncmp(gate_type, "DFF", 3) == 0) {
                    node->isDffFanout = 1;
                }
            }
            else {
                gate->fanin[i - 1] = node;
            }
            node->gates[node->isFanout] = gate;
        }
    }
    fclose(file);
    return circuit;
}

char** determine_inputs(Circuit* circuit) {
    char** inputs = (char**)malloc(sizeof(char*) * 100);
    int input_count = 0;
    for (int i = 0; i < 1000; i++) {
        Node* node = circuit->nodes[i];
        if (node != NULL && !node->isFanout) {
            inputs[input_count] = (char*)malloc(sizeof(char) * 50);
            strcpy(inputs[input_count], node->NodeName);
            input_count++;
        }
    }
    return inputs;
}

char** determine_dff_outputs(Circuit* circuit) {
    char** dff_outputs = (char**)malloc(sizeof(char*) * 100);
    int dff_output_count = 0;
    for (int i = 0; i < 1000; i++) {
        Node* node = circuit->nodes[i];
        if (node != NULL && node->isDffFanout) {
            dff_outputs[dff_output_count] = (char*)malloc(sizeof(char) * 50);
            strcpy(dff_outputs[dff_output_count], node->NodeName);
            dff_output_count++;
        }
    }
    return dff_outputs;
}

void assign_levels(Circuit* circuit, char** initial_nodes, char** dff_output_nodes) {
    for (int i = 0; i < 100; i++) {
        Node* node = circuit->nodes[i];
        if (node != NULL) {
            node->Level = -1;
        }
    }
    for (int i = 0; i < 100; i++) {
        char* node_name = initial_nodes[i];
        Node* node = circuit->nodes[atoi(node_name)];
        if (node != NULL) {
            node->Level = 0;
        }
    }
    for (int i = 0; i < 100; i++) {
        char* node_name = dff_output_nodes[i];
        Node* node = circuit->nodes[atoi(node_name)];
        if (node != NULL) {
            node->Level = 0;
            node->isDffFanout = 1;
        }
    }
    GateRecord* current = circuit->gate_list->head;
    while (current != NULL) {
        if (strncmp(current->GateType, "DFF", 3) == 0) {
            current->Level = 0;
        }
        current = current->next;
    }
    int all_gates_assigned = 0;
    while (!all_gates_assigned) {
        all_gates_assigned = 1;
        GateRecord* current = circuit->gate_list->head;
        while (current != NULL) {
            if (current->Level < 0) {
                int all_fanin_assigned = 1;
                for (int i = 0; i < current->fanout->isFanout; i++) {
                    Node* fanin = current->fanin[i];
                    if (fanin->Level < 0) {
                        all_fanin_assigned = 0;
                        break;
                    }
                }
                if (all_fanin_assigned) {
                    int highest_fanin_level = -1;
                    for (int i = 0; i < current->fanout->isFanout; i++) {
                        Node* fanin = current->fanin[i];
                        if (fanin->Level > highest_fanin_level) {
                            highest_fanin_level = fanin->Level;
                        }
                    }
                    current->Level = highest_fanin_level + 1;
                    if (current->fanout != NULL && !current->fanout->isDffFanout) {
                        current->fanout->Level = current->Level;
                    }
                    all_gates_assigned = 0;
                }
            }
            current = current->next;
        }
    }
}

void print_wires(Circuit* circuit) {
    printf("List of all wires (nodes), their levels, and connected gates:\n");
    for (int i = 0; i < 1000; i++) {
        Node* node = circuit->nodes[i];
        if (node != NULL) {
            printf("Wire: %s, Level: %d, Connected Gates: ", node->NodeName, node->Level);
            for (int j = 0; j < node->isFanout; j++) {
                printf("%s", node->gates[j]->GateName);
                if (j < node->isFanout - 1) {
                    printf(", ");
                }
            }
            printf("\n");
        }
    }
}

void print_circuit(Circuit* circuit) {
    printf("Circuit Structure:\n");
    GateRecord* current = circuit->gate_list->head;
    while (current != NULL) {
        printf("Gate: %s, Type: %s, Level: %d, Fanout: %s, Fanin: ", current->GateName, current->GateType, current->Level, current->fanout != NULL ? current->fanout->NodeName : "None");
        for (int i = 0; i < current->fanout->isFanout; i++) {
            printf("%s", current->fanout->gates[i]->GateName);
            if (i < current->fanout->isFanout - 1) {
                printf(", ");
            }
        }
        printf("\n");
        current = current->next;
    }
}

void print_level_summary(Circuit* circuit) {
    int level_count[100];
    for (int i = 0; i < 100; i++) {
        level_count[i] = 0;
    }
    int total_gates = 0;
    GateRecord* current = circuit->gate_list->head;
    while (current != NULL) {
        total_gates++;
        int level = current->Level;
        level_count[level]++;
        current = current->next;
    }
    printf("-------------------------------------\n\n");
    printf("Total number of gates: %d\n", total_gates);
    for (int i = 0; i < 100; i++) {
        if (level_count[i] > 0) {
            printf("Level %d: %d gates\n", i, level_count[i]);
        }
    }
}

char* evaluate_gate(char* gate_type, char* input1, char* input2) {
    if (strcmp(gate_type, "NOT") == 0) {
        if (strcmp(input1, "0") == 0) {
            return "1";
        }
        else if (strcmp(input1, "1") == 0) {
            return "0";
        }
        else {
            return "X";
        }
    }
    else if (strcmp(gate_type, "AND") == 0) {
        if (strcmp(input1, "0") == 0 && strcmp(input2, "0") == 0) {
            return "0";
        }
        else if (strcmp(input1, "0") == 0 && strcmp(input2, "1") == 0) {
            return "0";
        }
        else if (strcmp(input1, "1") == 0 && strcmp(input2, "0") == 0) {
            return "0";
        }
        else if (strcmp(input1, "1") == 0 && strcmp(input2, "1") == 0) {
            return "1";
        }
        else if (strcmp(input1, "0") == 0 && strcmp(input2, "X") == 0) {
            return "0";
        }
        else if (strcmp(input1, "X") == 0 && strcmp(input2, "0") == 0) {
            return "0";
        }
        else if (strcmp(input1, "1") == 0 && strcmp(input2, "X") == 0) {
            return "X";
        }
        else if (strcmp(input1, "X") == 0 && strcmp(input2, "1") == 0) {
            return "X";
        }
        else {
            return "X";
        }
    }
    else if (strcmp(gate_type, "OR") == 0) {
        if (strcmp(input1, "0") == 0 && strcmp(input2, "0") == 0) {
            return "0";
        }
        else if (strcmp(input1, "0") == 0 && strcmp(input2, "1") == 0) {
            return "1";
        }
        else if (strcmp(input1, "1") == 0 && strcmp(input2, "0") == 0) {
            return "1";
        }
        else if (strcmp(input1, "1") == 0 && strcmp(input2, "1") == 0) {
            return "1";
        }
        else if (strcmp(input1, "0") == 0 && strcmp(input2, "X") == 0) {
            return "X";
        }
        else if (strcmp(input1, "X") == 0 && strcmp(input2, "0") == 0) {
            return "X";
        }
        else if (strcmp(input1, "1") == 0 && strcmp(input2, "X") == 0) {
            return "1";
        }
        else if (strcmp(input1, "X") == 0 && strcmp(input2, "1") == 0) {
            return "X";
        }
        else {
            return "X";
        }
    }
    else if (strcmp(gate_type, "XOR") == 0) {
        if (strcmp(input1, "0") == 0 && strcmp(input2, "0") == 0) {
            return "0";
        }
        else if (strcmp(input1, "0") == 0 && strcmp(input2, "1") == 0) {
            return "1";
        }
        else if (strcmp(input1, "1") == 0 && strcmp(input2, "0") == 0) {
            return "1";
        }
        else if (strcmp(input1, "1") == 0 && strcmp(input2, "1") == 0) {
            return "0";
        }
        else if (strcmp(input1, "0") == 0 && strcmp(input2, "X") == 0) {
            return "X";
        }
        else if (strcmp(input1, "X") == 0 && strcmp(input2, "0") == 0) {
            return "X";
        }
        else if (strcmp(input1, "1") == 0 && strcmp(input2, "X") == 0) {
            return "X";
        }
        else if (strcmp(input1, "X") == 0 && strcmp(input2, "1") == 0) {
            return "X";
        }
        else {
            return "X";
        }
    }
    else if (strcmp(gate_type, "NOR") == 0) {
        if (strcmp(input1, "0") == 0 && strcmp(input2, "0") == 0) {
            return "1";
        }
        else if (strcmp(input1, "0") == 0 && strcmp(input2, "1") == 0) {
            return "0";
        }
        else if (strcmp(input1, "1") == 0 && strcmp(input2, "0") == 0) {
            return "0";
        }
        else if (strcmp(input1, "1") == 0 && strcmp(input2, "1") == 0) {
            return "0";
        }
        else if (strcmp(input1, "0") == 0 && strcmp(input2, "X") == 0) {
            return "X";
        }
        else if (strcmp(input1, "X") == 0 && strcmp(input2, "0") == 0) {
            return "X";
        }
        else if (strcmp(input1, "1") == 0 && strcmp(input2, "X") == 0) {
            return "0";
        }
        else if (strcmp(input1, "X") == 0 && strcmp(input2, "1") == 0) {
            return "0";
        }
        else {
            return "X";
        }
    }
    else if (strcmp(gate_type, "NAND") == 0) {
        if (strcmp(input1, "0") == 0 && strcmp(input2, "0") == 0) {
            return "1";
        }
        else if (strcmp(input1, "0") == 0 && strcmp(input2, "1") == 0) {
            return "1";
        }
        else if (strcmp(input1, "1") == 0 && strcmp(input2, "0") == 0) {
            return "1";
        }
        else if (strcmp(input1, "1") == 0 && strcmp(input2, "1") == 0) {
            return "0";
        }
        else if (strcmp(input1, "0") == 0 && strcmp(input2, "X") == 0) {
            return "X";
        }
        else if (strcmp(input1, "X") == 0 && strcmp(input2, "0") == 0) {
            return "X";
        }
        else if (strcmp(input1, "1") == 0 && strcmp(input2, "X") == 0) {
            return "1";
        }
        else if (strcmp(input1, "X") == 0 && strcmp(input2, "1") == 0) {
            return "1";
        }
        else {
            return "X";
        }
    }
    else {
        return NULL;
    }
}

void propagate_states(Circuit* circuit) {
    int changes = 1;
    while (changes) {
        changes = 0;
        GateRecord* current = circuit->gate_list->head;
        while (current != NULL) {
            if (strcmp(current->GateType, "NOT") == 0 || strcmp(current->GateType, "AND") == 0 || strcmp(current->GateType, "OR") == 0 || strcmp(current->GateType, "XOR") == 0 || strcmp(current->GateType, "NOR") == 0 || strcmp(current->GateType, "NAND") == 0) {
                char* new_state = evaluate_gate(current->GateType, current->fanin[0]->state, current->fanin[1] != NULL ? current->fanin[1]->state : NULL);
                if (new_state != NULL && strcmp(new_state, &current->state) != 0) {
                    current->state = *new_state;
                    changes = 1;
                }
            }
            current = current->next;
        }
    }
}

void update_dff_states(Circuit* circuit, char** dff_output_nodes) {
    GateRecord* current = circuit->gate_list->head;
    while (current != NULL) {
        if (strncmp(current->GateType, "DFF", 3) == 0) {
            Node* input_node = current->fanin[0];
            char* input_value = input_node != NULL ? &input_node->state : "Unknown";
            printf("Gate %s (%s): State = %c, input = %s\n", current->GateName, current->GateType, current->state, input_value);
            if (input_node != NULL) {
                current->state = input_node->state;
                for (int i = 0; i < 1000; i++) {
                    Node* node = circuit->nodes[i];
                    if (node != NULL && node->isFanout && node->isDffFanout) {
                        node->state = current->state;
                    }
                }
            }
        }
        current = current->next;
    }
}

void prompt_for_inputs(Circuit* circuit, char** input_nodes) {
    for (int i = 0; i < 100; i++) {
        char* node_name = input_nodes[i];
        Node* node = circuit->nodes[atoi(node_name)];
        if (node != NULL) {
            char value[10];
            printf("Enter value for input %s (0, 1, X): ", node_name);
            scanf("%s", value);
            while (strcmp(value, "0") != 0 && strcmp(value, "1") != 0 && strcmp(value, "X") != 0) {
                printf("Invalid input. Please enter 0, 1, or X.\n");
                printf("Enter value for input %s (0, 1, X): ", node_name);
                scanf("%s", value);
            }
            node->state = value[0];
        }
    }
}

void print_circuit_state(Circuit* circuit) {
    GateRecord* current = circuit->gate_list->head;
    while (current != NULL) {
        printf("Gate %s (%s): State = %c\n", current->GateName, current->GateType, current->state);
        current = current->next;
    }
}

void simulate_circuit(char* filename) {
    Circuit* circuit = read_circuit(filename);
    char** input_nodes = determine_inputs(circuit);
    char** dff_output_nodes = determine_dff_outputs(circuit);
    assign_levels(circuit, input_nodes, dff_output_nodes);
    print_circuit(circuit);
    printf("------------------------------------------------------------------------\n");
    print_level_summary(circuit);
    printf("------------------------------------------------------------------------\n");
    printf("STARTING SIMULATION\n");
    char run_simulation[10];
    printf("Do you want to run the simulation? (y/n): ");
    scanf("%s", run_simulation);
    if (strcmp(run_simulation, "y") != 0) {
        return;
    }
    circuit = read_circuit(filename);
    input_nodes = determine_inputs(circuit);
    dff_output_nodes = determine_dff_outputs(circuit);
    assign_levels(circuit, input_nodes, dff_output_nodes);
    int max_level = -1;
    for (int i = 0; i < 1000; i++) {
        Node* node = circuit->nodes[i];
        if (node != NULL && node->Level > max_level) {
            max_level = node->Level;
        }
    }
    while (1) {
        prompt_for_inputs(circuit, input_nodes);
        for (int i = 0; i < 100; i++) {
            char* node_name = dff_output_nodes[i];
            Node* node = circuit->nodes[atoi(node_name)];
            if (node != NULL) {
                node->state = node->gates[0]->state;
            }
        }
        for (int level = 0; level <= max_level; level++) {
            GateRecord* current = circuit->gate_list->head;
            while (current != NULL) {
                if (current->Level == level) {
                    if (strcmp(current->GateType, "NOT") == 0 || strcmp(current->GateType, "AND") == 0 || strcmp(current->GateType, "OR") == 0 || strcmp(current->GateType, "XOR") == 0 || strcmp(current->GateType, "NOR") == 0 || strcmp(current->GateType, "NAND") == 0) {
                        char* new_state = evaluate_gate(current->GateType, current->fanin[0]->state, current->fanin[1] != NULL ? current->fanin[1]->state : NULL);
                        if (new_state != NULL && strcmp(new_state, &current->state) != 0) {
                            current->state = *new_state;
                        }
                    }
                    if (current->fanout != NULL && !current->fanout->isDffFanout) {
                        current->fanout->state = current->state;
                    }
                }
                current = current->next;
            }
        }
        GateRecord* current = circuit->gate_list->head;
        while (current != NULL) {
            if (strncmp(current->GateType, "DFF", 3) == 0) {
                Node* input_node = current->fanin[0];
                char* input_value = input_node != NULL ? &input_node->state : "Unknown";
                printf("Gate %s (%s): State = %c, input = %s\n", current->GateName, current->GateType, current->state, input_value);
                if (input_node != NULL) {
                    current->state = input_node->state;
                }
            }
            current = current->next;
        }
        printf("Node values after this input cycle:\n");
        for (int i = 0; i < 1000; i++) {
            Node* node = circuit->nodes[i];
            if (node != NULL) {
                printf("Node %s: State = %c\n", node->NodeName, node->state);
            }
        }
        char continue_simulation[10];
        printf("Continue simulation? (y/n): ");
        scanf("%s", continue_simulation);
        if (strcmp(continue_simulation, "y") != 0) {
            return;
        }
    }
}

int main() {
    simulate_circuit("S27.txt");
    return 0;
}


