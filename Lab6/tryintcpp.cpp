#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAX_NAME_LEN 50
#define MAX_NODES 1000
#define MAX_GATES 1000

typedef struct Node Node;
typedef struct Gate Gate;

struct Node {
    char name[MAX_NAME_LEN];
    Gate* gate;
};

struct Gate {
    char name[MAX_NAME_LEN];
    Node* fanin[MAX_NODES];
    Node* fanout[MAX_NODES];
    int fanin_count;
    int fanout_count;
    int level;
};

Node nodes[MAX_NODES];
Gate gates[MAX_GATES];
int node_count = 0, gate_count = 0;

Node* find_or_create_node(const char* name) {
    for (int i = 0; i < node_count; ++i) {
        if (strcmp(nodes[i].name, name) == 0) {
            return &nodes[i];
        }
    }

    strcpy(nodes[node_count].name, name);
    return &nodes[node_count++];
}

Gate* find_or_create_gate(const char* name) {
    for (int i = 0; i < gate_count; ++i) {
        if (strcmp(gates[i].name, name) == 0) {
            return &gates[i];
        }
    }

    strcpy(gates[gate_count].name, name);
    gates[gate_count].fanin_count = 0;
    gates[gate_count].fanout_count = 0;
    gates[gate_count].level = -1;
    return &gates[gate_count++];
}

void assign_levels() {
    int levels_assigned;
    do {
        levels_assigned = 0;
        for (int i = 0; i < gate_count; ++i) {
            if (gates[i].level == -1) {
                int level = 0;
                int all_fanin_assigned = 1;
                for (int j = 0; j < gates[i].fanin_count; ++j) {
                    if (gates[i].fanin[j]->gate->level == -1) {
                        all_fanin_assigned = 0;
                        break;
                    }
                    if (gates[i].fanin[j]->gate->level >= level) {
                        level = gates[i].fanin[j]->gate->level + 1;
                    }
                }
                if (all_fanin_assigned) {
                    gates[i].level = level;
                    levels_assigned = 1;
                }
            }
        }
    } while (levels_assigned);
}

void read_circuit(const char* filename) {
    FILE* file = fopen(filename, "r");
    if (!file) {
        perror("Error opening file");
        exit(EXIT_FAILURE);
    }

    char line[256];
    while (fgets(line, sizeof(line), file)) {
        char gate_name[MAX_NAME_LEN], node_name[MAX_NAME_LEN];
        sscanf(line, "%s", gate_name);
        Gate* gate = find_or_create_gate(gate_name);

        char* token = strtok(line, " ");
        while (token != NULL) {
            if (strcmp(token, "->") == 0) {
                token = strtok(NULL, " ");
                Node* node = find_or_create_node(token);
                gate->fanout[gate->fanout_count++] = node;
                node->gate = gate;
            } else if (strcmp(token, gate_name) != 0) {
                Node* node = find_or_create_node(token);
                gate->fanin[gate->fanin_count++] = node;
            }
            token = strtok(NULL, " ");
        }
    }
    fclose(file);
}

void print_circuit() {
    for (int i = 0; i < gate_count; ++i) {
        printf("Gate: %s, Level: %d\n", gates[i].name, gates[i].level);
    }
}

int main() {
    read_circuit("S27.txt");  // Replace with your file path
    assign_levels();
    print_circuit();

    return 0;
}
