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
        self.fanin = []
        self.fanout = []

def create_gate(name, gate_type):
    return GateRecord(name, gate_type)

def add_to_list(node_list, name):
    if name not in node_list:
        node_list.append(name)

def find_or_create_gate(gates, name, gate_type):
    if name not in gates:
        gates[name] = create_gate(name, gate_type)
    return gates[name]

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
    cleaned_line = re.sub(r'[();]', ' ', line).replace(',', ' ')
    return cleaned_line.split()

def assign_levels(gates, input_nodes, dff_nodes):
    level = 0
    next_level_gates = input_nodes + dff_nodes

    while next_level_gates:
        current_level_gates = next_level_gates
        next_level_gates = []

        for gate_name in current_level_gates:
            gate = gates.get(gate_name)
            if gate and gate.level == -1:
                gate.level = level
                for fanout_name in gate.fanout:
                    if gates.get(fanout_name).level == -1:
                        next_level_gates.append(fanout_name)

        level += 1

def main():
    try:
        with open("S27.txt", "r") as file:
            lines = file.readlines()
    except IOError:
        print("Failed to open the file")
        return

    gates = {}
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
        gate = find_or_create_gate(gates, gate_name, gate_type)

        for i, connection_name in enumerate(tokens[2:]):
            if i == 0:
                add_to_list(gate.fanout, connection_name)
                if gate_type == GateType.DFF:
                    add_to_list(dff_nodes, connection_name)
            else:
                add_to_list(gate.fanin, connection_name)

    assign_levels(gates, input_nodes, dff_nodes)

    for gate in gates.values():
        print(f"Gate {gate.gate_name} (Level {gate.level}) of type {gate.gate_type}")
        for fanin in gate.fanin:
            print(f"  - Fanin: {fanin}")
        for fanout in gate.fanout:
            print(f"  - Fanout: {fanout}")

if __name__ == "__main__":
    main()
