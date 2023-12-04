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

class WireRecord:
    def __init__(self, name):
        self.wire_name = name
        self.level = -1

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

# Define the gate_marked function
def gate_marked(gate, max_level):
    max_level[0] = -1
    for fanin_gate in gate.fanin:
        if fanin_gate.level < 0:
            return False
        if max_level[0] < fanin_gate.level:
            max_level[0] = fanin_gate.level
    return True

# Define the insert_fanout function
def insert_fanout(gate, fanout_list):
    for fanout_gate in gate.fanout:
        if fanout_gate.level < 0:
            temp = fanout_gate.next
            fanout_gate.next = fanout_list
            fanout_list = fanout_gate
            fanout_gate = temp
    return fanout_list

# Define the Max_count variable
Max_count = 10000

# Modify the assign_levels function to incorporate the logic
def assign_levels(gates, input_nodes, dff_nodes, wire_records):
    max_level = [-1]
    ListNext = None

    for input_gate_name in input_nodes + dff_nodes:
        input_gate = gates.get(input_gate_name)
        if input_gate:
            input_gate.level = 0
            ListNext = insert_fanout(input_gate, ListNext)

        
    Counter = 0
    while ListNext is not None and Counter < Max_count:
        List = ListNext
        ListNext = None
        while List is not None:
            if gate_marked(List.g, max_level):
                List.g.level = max_level[0]
                ListNext = insert_fanout(List.g, ListNext)
                List = List.next
            else:
                temp = List.next
                List.next = ListNext
                ListNext = List
                List = temp
        Counter += 1

    if Counter >= Max_count:
        print("Asynchronous Feedback")
        return False

    return True

# Define the print_wire_levels function
def print_wire_levels(wire_records):
    for wire_record in wire_records:
        print(f"Wire {wire_record.wire_name} (Level {wire_record.level})")

# Main function
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
    wire_records = []  # Store wire records separately

    for line in lines:
        if line.startswith('\n') or line.startswith('/'):
            continue

        tokens = parse_line(line)
        if not tokens:
            continue

        if tokens[0] == 'input':
            for token in tokens[1:]:
                add_to_list(input_nodes, token)
                wire_records.append(WireRecord(token))
                wire_records[-1].level = 0

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
                    wire_records.append(WireRecord(connection_name))
                    wire_records[-1].level = 0

                # Check if it's a wire and create a WireRecord
                if connection_name not in input_nodes + dff_nodes:
                    wire_records.append(WireRecord(connection_name))
            else:
                add_to_list(gate.fanin, connection_name)

    # Call the assign_levels function
    if assign_levels(gates, input_nodes, dff_nodes, wire_records):
        for gate in gates.values():
            print(f"Gate {gate.gate_name} (Level {gate.level}) of type {gate.gate_type}")
            for fanin in gate.fanin:
                print(f"  - Fanin: {fanin}")
            for fanout in gate.fanout:
                print(f"  - Fanout: {fanout}")

    # Print wire levels
    print_wire_levels(wire_records)

if __name__ == "__main__":
    main()
