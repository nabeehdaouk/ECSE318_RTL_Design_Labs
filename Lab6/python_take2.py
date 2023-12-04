class GateRecord:
    def __init__(self, name, gtype):
        self.GateName = name
        self.GateType = gtype
        self.Level = -1
        self.output = False
        self.Number = 0
        self.fanout = None
        self.fanin = []
        self.next = None

class Node:
    def __init__(self, name):
        self.NodeName = name
        self.gates = []
        self.isFanout = False
        self.isDffFanout = False
        self.Level = -1

class GateList:
    def __init__(self):
        self.head = None

    def add_gate(self, gate):
        if not self.head:
            self.head = gate
        else:
            current = self.head
            while current.next:
                current = current.next
            current.next = gate

    def find_gate(self, name):
        current = self.head
        while current:
            if current.GateName == name:
                return current
            current = current.next
        return None

def read_circuit(filename):
    gate_list = GateList()
    nodes = {}

    with open(filename, 'r') as file:
        for line in file:
            parts = line.strip().split()
            if len(parts) < 3 or '(' not in parts[2]:
                continue

            gate_type, gate_name = parts[0], parts[1]
            net_names = parts[2].strip('();').split(',')

            gate = gate_list.find_gate(gate_name) or GateRecord(gate_name, gate_type)

            for i, net_name in enumerate(net_names):
                if net_name not in nodes:
                    nodes[net_name] = Node(net_name)
                node = nodes[net_name]
                if i == 0:
                    gate.fanout = node
                    node.isFanout = True
                    if gate_type.lower().startswith('dff'):
                        node.isDffFanout = True
                else:
                    gate.fanin.append(node)
                node.gates.append(gate)

            if not gate_list.find_gate(gate_name):
                gate_list.add_gate(gate)

    return gate_list, nodes

def determine_inputs(nodes):
    return [node_name for node_name, node in nodes.items() if not node.isFanout]

def determine_dff_outputs(nodes):
    return [node_name for node_name, node in nodes.items() if node.isDffFanout]

def assign_levels(gate_list, nodes, initial_nodes, dff_output_nodes):
    # Set initial nodes (input wires) to level 0
    for node_name in initial_nodes:
        if node_name in nodes:
            nodes[node_name].Level = 0

    # Set DFF output nodes to level 0 and ensure they remain unchanged
    for node_name in dff_output_nodes:
        if node_name in nodes:
            nodes[node_name].Level = 0
            nodes[node_name].isDffFanout = True

    # Set DFF gates to level 0
    current = gate_list.head
    while current:
        if current.GateType.lower().startswith('dff'):
            current.Level = 0
        current = current.next

    all_gates_assigned = False
    while not all_gates_assigned:
        all_gates_assigned = True
        current = gate_list.head
        while current:
            if current.Level < 0:
                if all(node.Level > -1 for node in current.fanin):
                    highest_fanin_level = max(node.Level for node in current.fanin)
                    current.Level = highest_fanin_level + 1
                    if current.fanout and not current.fanout.isDffFanout:
                        current.fanout.Level = current.Level
                    all_gates_assigned = False
            current = current.next

def print_wires(nodes):
    print("List of all wires (nodes), their levels, and connected gates:")
    for node_name, node in nodes.items():
        connected_gate_names = [gate.GateName for gate in node.gates]
        print(f"Wire: {node_name}, Level: {node.Level}, Connected Gates: {', '.join(connected_gate_names)}")

def print_circuit(gate_list):
    current = gate_list.head
    while current:
        fanin_names = ', '.join(node.NodeName for node in current.fanin)
        fanout_name = current.fanout.NodeName if current.fanout else "None"
        print(f"Gate: {current.GateName}, Type: {current.GateType}, Level: {current.Level}, Fanout: {fanout_name}, Fanin: {fanin_names}")
        current = current.next

# Example Usage
gate_list, nodes = read_circuit('S27.txt')  # Replace with the correct path to your file
input_nodes = determine_inputs(nodes)
dff_output_nodes = determine_dff_outputs(nodes)
assign_levels(gate_list, nodes, input_nodes + dff_output_nodes,dff_output_nodes )
print_circuit(gate_list)
print_wires(nodes)
