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
    char state;

    GateRecord(std::string name, std::string gtype) {
        GateName = name;
        GateType = gtype;
        Level = -1;
        output = false;
        Number = 0;
        fanout = nullptr;
        next = nullptr;
        state = 'X';
    }
};

class Node {
public:
    std::string NodeName;
    std::vector<GateRecord*> gates;
    bool isFanout;
    bool isDffFanout;
    int Level;
    char state;

    Node(std::string name) {
        NodeName = name;
        isFanout = false;
        isDffFanout = false;
        Level = -1;
        state = 'X';
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

GateList read_circuit(std::string filename) {
    GateList gate_list;
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
        GateRecord* gate = gate_list.find_gate(gate_name);
        if (!gate) {
            gate = new GateRecord(gate_name, gate_type);
            gate_list.add_gate(gate);
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
                if (gate_type.substr(0, 3) == "DFF") {
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
            if (gate_type.substr(0, 3) == "DFF") {
                node->isDffFanout = true;
            }
        }
        else {
            gate->fanin.push_back(node);
        }
        node->gates.push_back(gate);
    }
    file.close();
    return gate_list;
}

std::vector<std::string> determine_inputs(std::unordered_map<std::string, Node*> nodes) {
    std::vector<std::string> inputs;
    for (const auto& pair : nodes) {
        const std::string& node_name = pair.first;
        const Node* node = pair.second;
        if (!node->isFanout) {
            inputs.push_back(node_name);
        }
    }
    return inputs;
}

std::vector<std::string> determine_dff_outputs(std::unordered_map<std::string, Node*> nodes) {
    std::vector<std::string> dff_outputs;
    for (const auto& pair : nodes) {
        const std::string& node_name = pair.first;
        const Node* node = pair.second;
        if (node->isDffFanout) {
            dff_outputs.push_back(node_name);
        }
    }
    return dff_outputs;
}

void assign_levels(GateList& gate_list, std::unordered_map<std::string, Node*>& nodes, const std::vector<std::string>& initial_nodes, const std::vector<std::string>& dff_output_nodes) {
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
    GateRecord* current = gate_list.head;
    while (current) {
        if (current->GateType.substr(0, 3) == "DFF") {
            current->Level = 0;
        }
        current = current->next;
    }
    bool all_gates_assigned = false;
    while (!all_gates_assigned) {
        all_gates_assigned = true;
        current = gate_list.head;
        while (current) {
            if (current->Level < 0) {
                bool all_fanin_assigned = true;
                for (const GateRecord* fanin : current->fanin) {
                    if (fanin->Level < 0) {
                        all_fanin_assigned = false;
                        break;
                    }
                }
                if (all_fanin_assigned) {
                    int highest_fanin_level = -1;
                    for (const GateRecord* fanin : current->fanin) {
                        if (fanin->Level > highest_fanin_level) {
                            highest_fanin_level = fanin->Level;
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
        std::cout << "Wire: " << node_name << ", Level: " << node->Level << ", Connected Gates: " << join(connected_gate_names, ", ") << std::endl;
    }
}

void print_circuit(const GateList& gate_list) {
    std::cout << "Circuit Structure:" << std::endl;
    GateRecord* current = gate_list.head;
    while (current) {
        std::vector<std::string> fanin_names;
        for (const Node* node : current->fanin) {
            fanin_names.push_back(node->NodeName);
        }
        std::string fanout_name = current->fanout ? current->fanout->NodeName : "None";
        std::cout << "Gate: " << current->GateName << ", Type: " << current->GateType << ", Level: " << current->Level << ", Fanout: " << fanout_name << ", Fanin: " << join(fanin_names, ", ") << std::endl;
        current = current->next;
    }
}

void print_level_summary(const GateList& gate_list) {
    std::unordered_map<int, int> level_count;
    int total_gates = 0;
    GateRecord* current = gate_list.head;
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

std::unordered_map<std::string, std::string> AND_LUT = {
    {"00", "0"}, {"01", "0"}, {"10", "0"}, {"11", "1"},
    {"0X", "X"}, {"X0", "0"}, {"1X", "X"}, {"X1", "X"}, {"XX", "X"}
};

std::unordered_map<std::string, std::string> OR_LUT = {
    {"00", "0"}, {"01", "1"}, {"10", "1"}, {"11", "1"},
    {"0X", "X"}, {"X0", "X"}, {"1X", "1"}, {"X1", "1"}, {"XX", "X"}
};

std::unordered_map<std::string, std::string> XOR_LUT = {
    {"00", "0"}, {"01", "1"}, {"10", "1"}, {"11", "0"},
    {"0X", "X"}, {"X0", "X"}, {"1X", "X"}, {"X1", "X"}, {"XX", "X"}
};

std::unordered_map<std::string, std::string> NOT_LUT = {
    {"0", "1"}, {"1", "0"}, {"X", "X"}
};

std::unordered_map<std::string, std::string> NOR_LUT = {
    {"00", "1"}, {"01", "0"}, {"10", "0"}, {"11", "0"},
    {"0X", "X"}, {"X0", "X"}, {"1X", "0"}, {"X1", "0"}, {"XX", "X"}
};

std::unordered_map<std::string, std::string> NAND_LUT = {
    {"00", "1"}, {"01", "1"}, {"10", "1"}, {"11", "0"},
    {"0X", "X"}, {"X0", "X"}, {"1X", "1"}, {"X1", "1"}, {"XX", "X"}
};

std::string evaluate_gate(const std::string& gate_type, const std::string& input1, const std::string& input2 = "") {
    if (gate_type == "NOT") {
        return NOT_LUT[input1];
    }
    else if (gate_type == "AND") {
        return AND_LUT[input1 + input2];
    }
    else if (gate_type == "OR") {
        return OR_LUT[input1 + input2];
    }
    else if (gate_type == "XOR") {
        return XOR_LUT[input1 + input2];
    }
    else if (gate_type == "NOR") {
        return NOR_LUT[input1 + input2];
    }
    else if (gate_type == "NAND") {
        return NAND_LUT[input1 + input2];
    }
    else {
        throw std::invalid_argument("Unsupported gate type");
    }
}

void propagate_states(GateList& gate_list) {
    bool changes = true;
    while (changes) {
        changes = false;
        GateRecord* current = gate_list.head;
        while (current) {
            if (current->GateType == "NOT" || current->GateType == "AND" || current->GateType == "OR" || current->GateType == "XOR" || current->GateType == "NOR" || current->GateType == "NAND") {
                std::string new_state = evaluate_gate(current->GateType, std::string(1, current->fanin[0]->state), current->fanin.size() > 1 ? std::string(1, current->fanin[1]->state) : "");
                if (new_state != std::string(1, current->state)) {
                    current->state = new_state[0];
                    changes = true;
                }
            }
            current = current->next;
        }
    }
}

void update_dff_states(GateList& gate_list, std::unordered_map<std::string, Node*>& nodes) {
    GateRecord* current = gate_list.head;
    while (current) {
        if (current->GateType.substr(0, 3) == "DFF") {
            Node* input_node = current->fanin.empty() ? nullptr : current->fanin[0];
            std::string input_value = input_node ? std::string(1, input_node->state) : "Unknown";
            std::cout << "Gate " << current->GateName << " (" << current->GateType << "): State = " << current->state << ", input = " << input_value << std::endl;
            if (input_node) {
                current->state = input_node->state;
                for (const auto& pair : nodes) {
                    Node* node = pair.second;
                    if (node->isFanout && node->isDffFanout) {
                        node->state = current->state;
                    }
                }
            }
        }
        current = current->next;
    }
}

void prompt_for_inputs(std::unordered_map<std::string, Node*>& nodes) {
    for (const auto& pair : nodes) {
        const std::string& node_name = pair.first;
        Node* node = pair.second;
        if (!node->isFanout) {
            std::string value;
            while (true) {
                std::cout << "Enter value for input " << node_name << " (0, 1, X): ";
                std::cin >> value;
                if (value == "0" || value == "1" || value == "X") {
                    break;
                }
                std::cout << "Invalid input. Please enter 0, 1, or X." << std::endl;
            }
            node->state = value[0];
        }
    }
}

void print_circuit_state(const GateList& gate_list) {
    GateRecord* current = gate_list.head;
    while (current) {
        std::cout << "Gate " << current->GateName << " (" << current->GateType << "): State = " << current->state << std::endl;
        current = current->next;
    }
}

void simulate_circuit(const std::string& filename) {
    GateList gate_list = read_circuit("S27.txt");
    std::unordered_map<std::string, Node*> nodes;
    std::vector<std::string> input_nodes = determine_inputs(nodes);
    std::vector<std::string> dff_output_nodes = determine_dff_outputs(nodes);
    assign_levels(gate_list, nodes, input_nodes + dff_output_nodes, dff_output_nodes);
    print_circuit(gate_list);
    std::cout << "------------------------------------------------------------------------" << std::endl;
    print_level_summary(gate_list);
    std::cout << "------------------------------------------------------------------------" << std::endl;
    std::cout << "STARTING SIMULATION" << std::endl;
    std::string run_simulation;
    std::cout << "Do you want to run the simulation? (y/n): ";
    std::cin >> run_simulation;
    if (run_simulation != "y") {
        return;
    }
    gate_list = read_circuit(filename);
    nodes.clear();
    input_nodes = determine_inputs(nodes);
    dff_output_nodes = determine_dff_outputs(nodes);
    assign_levels(gate_list, nodes, input_nodes, dff_output_nodes);
    int max_level = 0;
    for (const auto& pair : nodes) {
        const Node* node = pair.second;
        if (node->Level > max_level) {
            max_level = node->Level;
        }
    }
    while (true) {
        prompt_for_inputs(nodes);
        for (const std::string& node_name : dff_output_nodes) {
            Node* node = nodes[node_name];
            if (node) {
                node->state = node->gates[0]->state;
            }
        }
        for (int level = 0; level <= max_level; level++) {
            GateRecord* current = gate_list.head;
            while (current) {
                if (current->Level == level) {
                    if (current->GateType == "NOT" || current->GateType == "AND" || current->GateType == "OR" || current->GateType == "XOR" || current->GateType == "NOR" || current->GateType == "NAND") {
                        std::string new_state = evaluate_gate(current->GateType, std::string(1, current->fanin[0]->state), current->fanin.size() > 1 ? std::string(1, current->fanin[1]->state) : "");
                        if (new_state != std::string(1, current->state)) {
                            current->state = new_state[0];
                        }
                    }
                    if (current->fanout && !current->fanout->isDffFanout) {
                        current->fanout->state = current->state;
                    }
                }
                current = current->next;
            }
        }
        GateRecord* current = gate_list.head;
        while (current) {
            if (current->GateType.substr(0, 3) == "DFF") {
                Node* input_node = current->fanin.empty() ? nullptr : current->fanin[0];
                std::string input_value = input_node ? std::string(1, input_node->state) : "Unknown";
                std::cout << "Gate " << current->GateName << " (" << current->GateType << "): State = " << current->state << ", input = " << input_value << std::endl;
                if (input_node) {
                    current->state = input_node->state;
                }
            }
            current = current->next;
        }
        std::cout << "Node values after this input cycle:" << std::endl;
        for (const auto& pair : nodes) {
            const std::string& node_name = pair.first;
            const Node* node = pair.second;
            std::cout << "Node " << node_name << ": State = " << node->state << std::endl;
        }
        std::string continue_simulation;
        std::cout << "Continue simulation? (y/n): ";
        std::cin >> continue_simulation;
        if (continue_simulation != "y") {
            return;
        }
    }
}

int main() {
    simulate_circuit("S27.txt");
    return 0;
}


