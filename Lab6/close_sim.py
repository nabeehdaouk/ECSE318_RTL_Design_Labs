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
        self.state = 'X'  # Initialize state as unknown

class Node:
    def __init__(self, name):
        self.NodeName = name
        self.gates = []
        self.isFanout = False
        self.isDffFanout = False
        self.Level = -1
        self.state = 'X'  # Initialize state as unknown

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
    for node_name in initial_nodes:
        if node_name in nodes:
            nodes[node_name].Level = 0

    for node_name in dff_output_nodes:
        if node_name in nodes:
            nodes[node_name].Level = 0
            nodes[node_name].isDffFanout = True

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
    print("Circuit Structure:")
    current = gate_list.head
    while current:
        fanin_names = ', '.join(node.NodeName for node in current.fanin)
        fanout_name = current.fanout.NodeName if current.fanout else "None"
        print(f"Gate: {current.GateName}, Type: {current.GateType}, Level: {current.Level}, Fanout: {fanout_name}, Fanin: {fanin_names}")
        current = current.next

def print_level_summary(gate_list):
    level_count = {}
    total_gates = 0

    current = gate_list.head
    while current:
        total_gates += 1
        level = current.Level
        if level not in level_count:
            level_count[level] = 0
        level_count[level] += 1
        current = current.next
    print("-------------------------------------")
    print()
    print(f"Total number of gates: {total_gates}")
    for level, count in sorted(level_count.items()):
        print(f"Level {level}: {count} gates")

# Lookup tables for AND, OR, XOR, NOT, NOR, and NAND gates
AND_LUT = {
    ('0', '0'): '0', ('0', '1'): '0', ('1', '0'): '0', ('1', '1'): '1',
    ('0', 'X'): 'X', ('X', '0'): '0', ('1', 'X'): 'X', ('X', '1'): 'X', ('X', 'X'): 'X'
}
OR_LUT = {
    ('0', '0'): '0', ('0', '1'): '1', ('1', '0'): '1', ('1', '1'): '1',
    ('0', 'X'): 'X', ('X', '0'): 'X', ('1', 'X'): '1', ('X', '1'): '1', ('X', 'X'): 'X'
}
XOR_LUT = {
    ('0', '0'): '0', ('0', '1'): '1', ('1', '0'): '1', ('1', '1'): '0',
    ('0', 'X'): 'X', ('X', '0'): 'X', ('1', 'X'): 'X', ('X', '1'): 'X', ('X', 'X'): 'X'
}
NOT_LUT = {'0': '1', '1': '0', 'X': 'X'}
NOR_LUT = {
    ('0', '0'): '1', ('0', '1'): '0', ('1', '0'): '0', ('1', '1'): '0',
    ('0', 'X'): 'X', ('X', '0'): 'X', ('1', 'X'): '0', ('X', '1'): '0', ('X', 'X'): 'X'
}
NAND_LUT = {
    ('0', '0'): '1', ('0', '1'): '1', ('1', '0'): '1', ('1', '1'): '0',
    ('0', 'X'): 'X', ('X', '0'): 'X', ('1', 'X'): '1', ('X', '1'): '1', ('X', 'X'): 'X'
}

def evaluate_gate(gate_type, input1, input2=None):
    if gate_type == "NOT":
        return NOT_LUT[input1]
    elif gate_type == "AND":
        return AND_LUT[(input1, input2)]
    elif gate_type == "OR":
        return OR_LUT[(input1, input2)]
    elif gate_type == "XOR":
        return XOR_LUT[(input1, input2)]
    elif gate_type == "NOR":
        return NOR_LUT[(input1, input2)]
    elif gate_type == "NAND":
        return NAND_LUT[(input1, input2)]
    else:
        raise ValueError("Unsupported gate type")

def propagate_states(gate_list):
    changes = True
    while changes:
        changes = False
        current = gate_list.head
        while current:
            if current.GateType.lower() in ["not", "and", "or", "xor", "nor", "nand"]:
                new_state = evaluate_gate(current.GateType.upper(), current.fanin[0].state, current.fanin[1].state if len(current.fanin) > 1 else None)
                if new_state != current.state:
                    current.state = new_state
                    changes = True
            current = current.next

def update_dff_states(gate_list, nodes):
    current = gate_list.head
    while current:
        if current.GateType.lower().startswith('dff'):
            # Find the input node for the DFF gate
            input_node = current.fanin[0] if current.fanin else None
            
            # Print the DFF gate and its input value
            input_value = input_node.state if input_node else 'Unknown'
            print(f"Gate {current.GateName} ({current.GateType}): State = {current.state}, input = {input_value}")
            
            # Update the DFF state to the state of its input (fan-in)
            if input_node:
                current.state = input_node.state
                # Update the output of the DFF gate to match its new state
                for node in nodes.values():
                    if node.isFanout and node.isDffFanout:
                        node.state = current.state
        current = current.next


def prompt_for_inputs(nodes):
    for node_name, node in nodes.items():
        if node.isFanout:  # Skip fanout nodes
            continue
        value = input(f"Enter value for input {node_name} (0, 1, X): ").strip().upper()
        while value not in ['0', '1', 'X']:
            print("Invalid input. Please enter 0, 1, or X.")
            value = input(f"Enter value for input {node_name} (0, 1, X): ").strip().upper()
        node.state = '0' if value == '0' else '1' if value == '1' else 'X'

def print_circuit_state(gate_list):
    current = gate_list.head
    while current:
        print(f"Gate {current.GateName} ({current.GateType}): State = {current.state}")
        current = current.next

def simulate_circuit(filename):
    # BEFORE SIM, PRINT CIRCUIT:
    gate_list, nodes = read_circuit('S27.txt')  # Replace with the correct path to your file
    input_nodes = determine_inputs(nodes)
    dff_output_nodes = determine_dff_outputs(nodes)
    assign_levels(gate_list, nodes, input_nodes + dff_output_nodes, dff_output_nodes)
    print_circuit(gate_list)
    print("------------------------------------------------------------------------")
    #print_wires(nodes)
    print_level_summary(gate_list)
    print("------------------------------------------------------------------------")
    print("STARTING SIMULATION")
    # Ask the user if they want to run the simulation
    run_simulation = input("Do you want to run the simulation? (y/n): ").strip().lower()
    if run_simulation != 'y':
        return  # Exit the function if the user doesn't want to run the simulation
    
    gate_list, nodes = read_circuit(filename)
    input_nodes = determine_inputs(nodes)
    dff_output_nodes = determine_dff_outputs(nodes)
    assign_levels(gate_list, nodes, input_nodes, dff_output_nodes)

    # Find the maximum level in the circuit
    max_level = max(node.Level for node in nodes.values())

    while True:
        prompt_for_inputs(nodes)

        # Set the output nodes of DFF gates to their current values
        for node_name in dff_output_nodes:
            node = nodes.get(node_name)
            if node:
                node.state = node.gates[0].state

        # Evaluate gates level by level
        for level in range(max_level + 1):
            current = gate_list.head
            while current:
                if current.Level == level:
                    if current.GateType.lower() in ["not", "and", "or", "xor", "nor", "nand"]:
                        new_state = evaluate_gate(current.GateType.upper(), current.fanin[0].state, current.fanin[1].state if len(current.fanin) > 1 else None)
                        if new_state != current.state:
                            current.state = new_state

                    # Propagate the values to fanout nodes
                    if current.fanout and not current.fanout.isDffFanout:
                        current.fanout.state = current.state

                current = current.next

        # Update DFF states
        current = gate_list.head
        while current:
            if current.GateType.lower().startswith('dff'):
                # Find the input node for the DFF gate
                input_node = current.fanin[0] if current.fanin else None

                # Print the DFF gate and its input value
                input_value = input_node.state if input_node else 'Unknown'
                print(f"Gate {current.GateName} ({current.GateType}): State = {current.state}, input = {input_value}")

                # Update the DFF state to the state of its input (fan-in)
                if input_node:
                    current.state = input_node.state
            current = current.next

        print("Node values after this input cycle:")
        for node_name, node in nodes.items():
            print(f"Node {node_name}: State = {node.state}")
        if input("Continue simulation? (y/n): ").strip().lower() != 'y':
            return




# Call the simulation function with the file path
simulate_circuit('S27.txt')  # Replace with the correct file path


