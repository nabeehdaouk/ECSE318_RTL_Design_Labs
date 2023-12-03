import re

class GateType:
    UNKNOWN = -1
    DFF = 1
    NOT = 2
    AND = 3
    NOR = 4
    OR = 5
    NAND = 6

class GateRecord:
    def __init__(self, name, gate_type):
        self.gate_name = name
        self.gate_type = gate_type
        self.level = -1
        self.output = False
        self.number = -1
        self.fanin = []
        self.fanout = []

def create_gate(name, gate_type):
    return GateRecord(name, gate_type)

def add_to_list(node_list, name):
    if name not in node_list:
        node_list.append(name)

def find_or_create_gate(head, name, gate_type):
    for gate in head:
        if gate.gate_name == name:
            return gate
    new_gate = create_gate(name, gate_type)
    head.append(new_gate)
    return new_gate

def gate_type_from_string(type_str):
    return {
        "dff1": GateType.DFF,
        "not": GateType.NOT,
        "and": GateType.AND,
        "nor": GateType.NOR,
        "or": GateType.OR,
        "nand": GateType.NAND,
        "dff": GateType.DFF
    }.get(type_str, GateType.UNKNOWN)

def parse_line(line):
    # Remove parentheses, split by semicolons, commas, and spaces
    cleaned_line = re.sub(r'[();]', ' ', line).replace(',', ' ')
    return cleaned_line.split()

def main():
    try:
        with open("S27.txt", "r") as file:
            lines = file.readlines()
    except IOError:
        print("Failed to open the file")
        return

    head = []
    dff_nodes = []
    input_nodes = []

    for line in lines:
        if line.startswith('\n') or line.startswith('/'):
            continue

        tokens = parse_line(line)
        if not tokens:
            continue

        if tokens[0] == 'input':
            for token in tokens[1:]:
                add_to_list(input_nodes, token)
            continue

        gate_type = gate_type_from_string(tokens[0])
        if gate_type == GateType.UNKNOWN:
            continue

        gate_name = tokens[1]
        gate = find_or_create_gate(head, gate_name, gate_type)

        # First token after the gate name is fanout, the rest are fanins
        for i, connection_name in enumerate(tokens[2:]):
            if i == 0:  # First connection is fanout
                add_to_list(gate.fanout, connection_name)
                if gate_type==1:
                    add_to_list(dff_nodes, connection_name)
            else:  # Remaining connections are fanin
                add_to_list(gate.fanin, connection_name)

    print("Nodes that outputs of DFF gates:")
    for name in dff_nodes:
        print(name)

    print("Input nodes of the circuit:")
    for name in input_nodes:
        print(name)

    for gate in head:
        print(f"Gate {gate.gate_name} of type {gate.gate_type}")
        for fanin in gate.fanin:
            print(f"  - Fanin: {fanin}")
        for fanout in gate.fanout:
            print(f"  - Fanout: {fanout}")

if __name__ == "__main__":
    main()
