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
    for wire in determine_inputs(nodes) + determine_dff_outputs(nodes):
        if wire in nodes:
            nodes[wire].Level = 0

    return gate_list, nodes

def determine_inputs(nodes):
    return [node_name for node_name, node in nodes.items() if not node.isFanout]

def determine_dff_outputs(nodes):
    return [node_name for node_name, node in nodes.items() if node.isDffFanout]

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

# Level assignment algorithm
global max
max = -1

def gate_marked(gate):
    global max
    max = -1
    for node in gate.fanin:
        e = node.gates[0]  # Assuming each node connects to only one gate
        if e.Level < 0:
            return False
        if max < e.Level:
            max = e.Level
    return True

def insert_fanout(gate, list_next):
    if gate.fanout and gate.fanout.gates[0].Level < 0:  # Check if fanout gate's level is < 0
        list_next.append(gate.fanout.gates[0])

def assign_level(gates):
    list_next = []
    for gate in gates:
        gate.Level = 0
        insert_fanout(gate, list_next)

    counter = 0
    max_count = 10000
    while list_next and counter < max_count:
        current_list = list_next
        list_next = []
        for gate in current_list:
            if gate_marked(gate):
                gate.Level = max
                insert_fanout(gate, list_next)
        counter += 1

    if counter >= max_count:
        print("Asynchronous Feedback")
        return False

    return True

# Example Usage
gate_list, nodes = read_circuit('S27.txt')  # Replace with the correct path to your file
input_gates = [nodes[wire].gates[0] for wire in determine_inputs(nodes)]  # Assuming each wire connects to only one gate
dff_gates = [nodes[wire].gates[0] for wire in determine_dff_outputs(nodes)]  # Assuming each wire connects to only one gate

assign_level(input_gates + dff_gates)
print_circuit(gate_list)
print_wires(nodes)
