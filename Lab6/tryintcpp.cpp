#include <iostream>
#include <fstream>
#include <string>
#include <vector>
#include <unordered_map>

class GateRecord {
public:
    std::string GateName;
    std::string GateType;
    int Level;
    bool output;
    int Number;
    GateRecord* fanout;
    std::vector<GateRecord*> fanin;
    GateRecord* next;

    GateRecord(std::string name, std::string gtype) {
        GateName = name;
        GateType = gtype;
        Level = -1;
        output = false;
        Number = 0;
        fanout = nullptr;
        next = nullptr;
    }
};

class Node {
public:
    std::string NodeName;
    std::vector<GateRecord*> gates;
    bool isFanout;
    bool isDffFanout;
    int Level;

    Node(std::string name) {
        NodeName = name;
        isFanout = false;
        isDffFanout = false;
        Level = -1;
    }
};

class GateList {
public:
    GateRecord* head;

    GateList() {
        head = nullptr;
    }

    void add_gate(GateRecord* gate) {
        if (!head) {
            head = gate;
        }
        else {
            GateRecord* current = head;
            while (current->next) {
                current = current->next;
            }
            current->next = gate;
        }
    }

    GateRecord* find_gate(std::string name) {
        GateRecord* current = head;
        while (current) {
            if (current->GateName == name) {
                return current;
            }
            current = current->next;
        }
        return nullptr;
    }
};

std::pair<GateList*, std::unordered_map<std::string, Node*>> read_circuit(std::string filename) {
    GateList* gate_list = new GateList();
    std::unordered_map<std::string, Node*> nodes;
    std::ifstream file(filename);
    std::string line;
    while (std::getline(file, line)) {
        std::vector<std::string> parts;
        std::string part;
        for (char c : line) {
            if (c == ' ' || c == '\t') {
                if (!part.empty()) {
                    parts.push_back(part);
                    part.clear();
                }
            }
            else {
                part += c;
            }
        }
        if (!part.empty()) {
            parts.push_back(part);
        }
        if (parts.size() < 3 || parts[2].find('(') == std::string::npos) {
            continue;
        }
        std::string gate_type = parts[0];
        std::string gate_name = parts[1];
        std::string net_names = parts[2].substr(1, parts[2].size() - 2);
        GateRecord* gate = gate_list->find_gate(gate_name);
        if (!gate) {
            gate = new GateRecord(gate_name, gate_type);
            gate_list->add_gate(gate);
        }
        size_t pos = 0;
        std::string net_name;
        while ((pos = net_names.find(',')) != std::string::npos) {
            net_name = net_names.substr(0, pos);
            net_names.erase(0, pos + 1);
            if (nodes.find(net_name) == nodes.end()) {
                nodes[net_name] = new Node(net_name);
            }
            Node* node = nodes[net_name];
            if (gate->fanin.empty()) {
                gate->fanout = node;
                node->isFanout = true;
                if (gate_type.substr(0, 3) == "dff") {
                    node->isDffFanout = true;
                }
            }
            else {
                gate->fanin.push_back(node);
            }
            node->gates.push_back(gate);
        }
        if (nodes.find(net_names) == nodes.end()) {
            nodes[net_names] = new Node(net_names);
        }
        Node* node = nodes[net_names];
        if (gate->fanin.empty()) {
            gate->fanout = node;
            node->isFanout = true;
            if (gate_type.substr(0, 3) == "dff") {
                node->isDffFanout = true;
            }
        }
        else {
            gate->fanin.push_back(node);
        }
        node->gates.push_back(gate);
    }
    file.close();
    return std::make_pair(gate_list, nodes);
}

std::vector<std::string> determine_inputs(std::unordered_map<std::string, Node*> nodes) {
    std::vector<std::string> input_nodes;
    for (const auto& pair : nodes) {
        const std::string& node_name = pair.first;
        const Node* node = pair.second;
        if (!node->isFanout) {
            input_nodes.push_back(node_name);
        }
    }
    return input_nodes;
}

std::vector<std::string> determine_dff_outputs(std::unordered_map<std::string, Node*> nodes) {
    std::vector<std::string> dff_output_nodes;
    for (const auto& pair : nodes) {
        const std::string& node_name = pair.first;
        const Node* node = pair.second;
        if (node->isDffFanout) {
            dff_output_nodes.push_back(node_name);
        }
    }
    return dff_output_nodes;
}

void assign_levels(GateList* gate_list, std::unordered_map<std::string, Node*>& nodes, const std::vector<std::string>& initial_nodes, const std::vector<std::string>& dff_output_nodes) {
    for (const std::string& node_name : initial_nodes) {
        if (nodes.find(node_name) != nodes.end()) {
            nodes[node_name]->Level = 0;
        }
    }
    for (const std::string& node_name : dff_output_nodes) {
        if (nodes.find(node_name) != nodes.end()) {
            nodes[node_name]->Level = 0;
            nodes[node_name]->isDffFanout = true;
        }
    }
    GateRecord* current = gate_list->head;
    while (current) {
        if (current->GateType.substr(0, 3) == "dff") {
            current->Level = 0;
        }
        current = current->next;
    }
    bool all_gates_assigned = false;
    while (!all_gates_assigned) {
        all_gates_assigned = true;
        current = gate_list->head;
        while (current) {
            if (current->Level < 0) {
                bool all_fanin_assigned = true;
                for (GateRecord* node : current->fanin) {
                    if (node->Level < 0) {
                        all_fanin_assigned = false;
                        break;
                    }
                }
                if (all_fanin_assigned) {
                    int highest_fanin_level = -1;
                    for (GateRecord* node : current->fanin) {
                        if (node->Level > highest_fanin_level) {
                            highest_fanin_level = node->Level;
                        }
                    }
                    current->Level = highest_fanin_level + 1;
                    if (current->fanout && !current->fanout->isDffFanout) {
                        current->fanout->Level = current->Level;
                    }
                    all_gates_assigned = false;
                }
            }
            current = current->next;
        }
    }
}

void print_wires(const std::unordered_map<std::string, Node*>& nodes) {
    std::cout << "List of all wires (nodes), their levels, and connected gates:" << std::endl;
    for (const auto& pair : nodes) {
        const std::string& node_name = pair.first;
        const Node* node = pair.second;
        std::vector<std::string> connected_gate_names;
        for (const GateRecord* gate : node->gates) {
            connected_gate_names.push_back(gate->GateName);
        }
        std::cout << "Wire: " << node_name << ", Level: " << node->Level << ", Connected Gates: " << std::endl;
        for (const std::string& gate_name : connected_gate_names) {
            std::cout << gate_name << ", ";
        }
        std::cout << std::endl;
    }
}

void print_circuit(const GateList* gate_list) {
    const GateRecord* current = gate_list->head;
    while (current) {
        std::string fanin_names;
        for (const GateRecord* node : current->fanin) {
            fanin_names += node->GateName + ", ";
        }
        std::string fanout_name = current->fanout ? current->fanout->GateName : "None";
        std::cout << "Gate: " << current->GateName << ", Type: " << current->GateType << ", Level: " << current->Level << ", Fanout: " << fanout_name << ", Fanin: " << fanin_names << std::endl;
        current = current->next;
    }
}

void print_level_summary(const GateList* gate_list) {
    std::unordered_map<int, int> level_count;
    int total_gates = 0;
    const GateRecord* current = gate_list->head;
    while (current) {
        total_gates++;
        int level = current->Level;
        if (level_count.find(level) == level_count.end()) {
            level_count[level] = 0;
        }
        level_count[level]++;
        current = current->next;
    }
    std::cout << "-------------------------------------" << std::endl;
    std::cout << std::endl;
    std::cout << "Total number of gates: " << total_gates << std::endl;
    for (const auto& pair : level_count) {
        int level = pair.first;
        int count = pair.second;
        std::cout << "Level " << level << ": " << count << " gates" << std::endl;
    }
}

int main() {
    std::pair<GateList*, std::unordered_map<std::string, Node*>> circuit = read_circuit("S27.txt");
    GateList* gate_list = circuit.first;
    std::unordered_map<std::string, Node*> nodes = circuit.second;
    std::vector<std::string> input_nodes = determine_inputs(nodes);
    std::vector<std::string> dff_output_nodes = determine_dff_outputs(nodes);
    assign_levels(gate_list, nodes, input_nodes, dff_output_nodes);
    print_circuit(gate_list);
    std::cout << "------------------------------------------------------------------------" << std::endl;
    print_wires(nodes);
    print_level_summary(gate_list);
    return 0;
}


