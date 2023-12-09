import java.util.HashMap;
import java.util.Map;
import java.util.ArrayList;
import java.util.List;
import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;

class GateRecord {
    public String GateName;
    public String GateType;
    public int Level;
    public boolean output;
    public int Number;
    public Node fanout;
    public List<Node> fanin;
    public GateRecord next;
    public char state;

    public GateRecord(String name, String gtype) {
        this.GateName = name;
        this.GateType = gtype;
        this.Level = -1;
        this.output = false;
        this.Number = 0;
        this.fanout = null;
        this.fanin = new ArrayList<>();
        this.next = null;
        this.state = 'X';
    }
}

class Node {
    public String NodeName;
    public List<GateRecord> gates;
    public boolean isFanout;
    public boolean isDffFanout;
    public int Level;
    public char state;

    public Node(String name) {
        this.NodeName = name;
        this.gates = new ArrayList<>();
        this.isFanout = false;
        this.isDffFanout = false;
        this.Level = -1;
        this.state = 'X';
    }
}

class GateList {
    public GateRecord head;

    public GateList() {
        this.head = null;
    }

    public void add_gate(GateRecord gate) {
        if (this.head == null) {
            this.head = gate;
        } else {
            GateRecord current = this.head;
            while (current.next != null) {
                current = current.next;
            }
            current.next = gate;
        }
    }

    public GateRecord find_gate(String name) {
        GateRecord current = this.head;
        while (current != null) {
            if (current.GateName.equals(name)) {
                return current;
            }
            current = current.next;
        }
        return null;
    }
}

public class Main {
    private static final Map<String, String> AND_LUT = new HashMap<String, String>() {{
        put("00", "0");
        put("01", "0");
        put("10", "0");
        put("11", "1");
        put("0X", "X");
        put("X0", "0");
        put("1X", "X");
        put("X1", "X");
        put("XX", "X");
    }};
    private static final Map<String, String> OR_LUT = new HashMap<String, String>() {{
        put("00", "0");
        put("01", "1");
        put("10", "1");
        put("11", "1");
        put("0X", "X");
        put("X0", "X");
        put("1X", "1");
        put("X1", "1");
        put("XX", "X");
    }};
    private static final Map<String, String> XOR_LUT = new HashMap<String, String>() {{
        put("00", "0");
        put("01", "1");
        put("10", "1");
        put("11", "0");
        put("0X", "X");
        put("X0", "X");
        put("1X", "X");
        put("X1", "X");
        put("XX", "X");
    }};
    private static final Map<String, String> NOT_LUT = new HashMap<String, String>() {{
        put("0", "1");
        put("1", "0");
        put("X", "X");
    }};
    private static final Map<String, String> NOR_LUT = new HashMap<String, String>() {{
        put("00", "1");
        put("01", "0");
        put("10", "0");
        put("11", "0");
        put("0X", "X");
        put("X0", "X");
        put("1X", "0");
        put("X1", "0");
        put("XX", "X");
    }};
    private static final Map<String, String> NAND_LUT = new HashMap<String, String>() {{
        put("00", "1");
        put("01", "1");
        put("10", "1");
        put("11", "0");
        put("0X", "X");
        put("X0", "X");
        put("1X", "1");
        put("X1", "1");
        put("XX", "X");
    }};

    private static GateList read_circuit(String filename) throws IOException {
        GateList gate_list = new GateList();
        Map<String, Node> nodes = new HashMap<>();
        BufferedReader reader = new BufferedReader(new FileReader(filename));
        String line;
        while ((line = reader.readLine()) != null) {
            String[] parts = line.trim().split("\\s+");
            if (parts.length < 3 || !parts[2].contains("(")) {
                continue;
            }
            String gate_type = parts[0];
            String gate_name = parts[1];
            String[] net_names = parts[2].replaceAll("[();]", "").split(",");
            GateRecord gate = gate_list.find_gate(gate_name);
            if (gate == null) {
                gate = new GateRecord(gate_name, gate_type);
            }
            for (int i = 0; i < net_names.length; i++) {
                String net_name = net_names[i];
                Node node = nodes.get(net_name);
                if (node == null) {
                    node = new Node(net_name);
                    nodes.put(net_name, node);
                }
                if (i == 0) {
                    gate.fanout = node;
                    node.isFanout = true;
                    if (gate_type.toLowerCase().startsWith("dff")) {
                        node.isDffFanout = true;
                    }
                } else {
                    gate.fanin.add(node);
                }
                node.gates.add(gate);
            }
            gate_list.add_gate(gate);
        }
        reader.close();
        return gate_list;
    }

    private static List<String> determine_inputs(Map<String, Node> nodes) {
        List<String> inputs = new ArrayList<>();
        for (Map.Entry<String, Node> entry : nodes.entrySet()) {
            String node_name = entry.getKey();
            Node node = entry.getValue();
            if (!node.isFanout) {
                inputs.add(node_name);
            }
        }
        return inputs;
    }

    private static List<String> determine_dff_outputs(Map<String, Node> nodes) {
        List<String> dff_outputs = new ArrayList<>();
        for (Map.Entry<String, Node> entry : nodes.entrySet()) {
            String node_name = entry.getKey();
            Node node = entry.getValue();
            if (node.isDffFanout) {
                dff_outputs.add(node_name);
            }
        }
        return dff_outputs;
    }

    private static void assign_levels(GateList gate_list, Map<String, Node> nodes, List<String> initial_nodes, List<String> dff_output_nodes) {
        for (String node_name : initial_nodes) {
            Node node = nodes.get(node_name);
            if (node != null) {
                node.Level = 0;
            }
        }
        for (String node_name : dff_output_nodes) {
            Node node = nodes.get(node_name);
            if (node != null) {
                node.Level = 0;
                node.isDffFanout = true;
            }
        }
        GateRecord current = gate_list.head;
        while (current != null) {
            if (current.GateType.toLowerCase().startsWith("dff")) {
                current.Level = 0;
            }
            current = current.next;
        }
        boolean all_gates_assigned = false;
        while (!all_gates_assigned) {
            all_gates_assigned = true;
            current = gate_list.head;
            while (current != null) {
                if (current.Level < 0) {
                    boolean all_fanin_assigned = true;
                    for (Node node : current.fanin) {
                        if (node.Level < 0) {
                            all_fanin_assigned = false;
                            break;
                        }
                    }
                    if (all_fanin_assigned) {
                        int highest_fanin_level = -1;
                        for (Node node : current.fanin) {
                            if (node.Level > highest_fanin_level) {
                                highest_fanin_level = node.Level;
                            }
                        }
                        current.Level = highest_fanin_level + 1;
                        if (current.fanout != null && !current.fanout.isDffFanout) {
                            current.fanout.Level = current.Level;
                        }
                        all_gates_assigned = false;
                    }
                }
                current = current.next;
            }
        }
    }

    private static void print_wires(Map<String, Node> nodes) {
        System.out.println("List of all wires (nodes), their levels, and connected gates:");
        for (Map.Entry<String, Node> entry : nodes.entrySet()) {
            String node_name = entry.getKey();
            Node node = entry.getValue();
            List<String> connected_gate_names = new ArrayList<>();
            for (GateRecord gate : node.gates) {
                connected_gate_names.add(gate.GateName);
            }
            System.out.printf("Wire: %s, Level: %d, Connected Gates: %s%n", node_name, node.Level, String.join(", ", connected_gate_names));
        }
    }

    private static void print_circuit(GateList gate_list) {
        System.out.println("Circuit Structure:");
        GateRecord current = gate_list.head;
        while (current != null) {
            List<String> fanin_names = new ArrayList<>();
            for (Node node : current.fanin) {
                fanin_names.add(node.NodeName);
            }
            String fanout_name = current.fanout != null ? current.fanout.NodeName : "None";
            System.out.printf("Gate: %s, Type: %s, Level: %d, Fanout: %s, Fanin: %s%n", current.GateName, current.GateType, current.Level, fanout_name, String.join(", ", fanin_names));
            current = current.next;
        }
    }

    private static void print_level_summary(GateList gate_list) {
        Map<Integer, Integer> level_count = new HashMap<>();
        int total_gates = 0;
        GateRecord current = gate_list.head;
        while (current != null) {
            total_gates++;
            int level = current.Level;
            if (!level_count.containsKey(level)) {
                level_count.put(level, 0);
            }
            level_count.put(level, level_count.get(level) + 1);
            current = current.next;
        }
        System.out.println("-------------------------------------");
        System.out.println();
        System.out.printf("Total number of gates: %d%n", total_gates);
        for (Map.Entry<Integer, Integer> entry : level_count.entrySet()) {
            int level = entry.getKey();
            int count = entry.getValue();
            System.out.printf("Level %d: %d gates%n", level, count);
        }
    }

    private static char evaluate_gate(String gate_type, char input1, Character input2) {
        if (gate_type.equals("NOT")) {
            return NOT_LUT.get(input1);
        } else if (gate_type.equals("AND")) {
            return AND_LUT.get(input1 + input2);
        } else if (gate_type.equals("OR")) {
            return OR_LUT.get(input1 + input2);
        } else if (gate_type.equals("XOR")) {
            return XOR_LUT.get(input1 + input2);
        } else if (gate_type.equals("NOR")) {
            return NOR_LUT.get(input1 + input2);
        } else if (gate_type.equals("NAND")) {
            return NAND_LUT.get(input1 + input2);
        } else {
            throw new IllegalArgumentException("Unsupported gate type");
        }
    }

    private static void propagate_states(GateList gate_list) {
        boolean changes = true;
        while (changes) {
            changes = false;
            GateRecord current = gate_list.head;
            while (current != null) {
                if (current.GateType.toLowerCase().matches("not|and|or|xor|nor|nand")) {
                    char new_state = evaluate_gate(current.GateType.toUpperCase(), current.fanin.get(0).state, current.fanin.size() > 1 ? current.fanin.get(1).state : null);
                    if (new_state != current.state) {
                        current.state = new_state;
                        changes = true;
                    }
                }
                current = current.next;
            }
        }
    }

    private static void update_dff_states(GateList gate_list, Map<String, Node> nodes) {
        GateRecord current = gate_list.head;
        while (current != null) {
            if (current.GateType.toLowerCase().startsWith("dff")) {
                Node input_node = current.fanin.size() > 0 ? current.fanin.get(0) : null;
                char input_value = input_node != null ? input_node.state : 'U';
                System.out.printf("Gate %s (%s): State = %c, input = %c%n", current.GateName, current.GateType, current.state, input_value);
                if (input_node != null) {
                    current.state = input_node.state;
                    for (Node node : nodes.values()) {
                        if (node.isFanout && node.isDffFanout) {
                            node.state = current.state;
                        }
                    }
                }
            }
            current = current.next;
        }
    }

    private static void prompt_for_inputs(Map<String, Node> nodes) {
        for (Map.Entry<String, Node> entry : nodes.entrySet()) {
            String node_name = entry.getKey();
            Node node = entry.getValue();
            if (!node.isFanout) {
                String value = System.console().readLine(String.format("Enter value for input %s (0, 1, X): ").strip().toUpperCase());
                while (!value.matches("[01X]")) {
                    System.out.println("Invalid input. Please enter 0, 1, or X.");
                    value = System.console().readLine(String.format("Enter value for input %s (0, 1, X): ").strip().toUpperCase());
                }
                node.state = value.charAt(0);
            }
        }
    }

    private static void print_circuit_state(GateList gate_list) {
        GateRecord current = gate_list.head;
        while (current != null) {
            System.out.printf("Gate %s (%s): State = %c%n", current.GateName, current.GateType, current.state);
            current = current.next;
        }
    }

    private static void simulate_circuit(String filename) throws IOException {
        GateList gate_list = read_circuit("S27.txt");
        Map<String, Node> nodes = new HashMap<>();
        List<String> input_nodes = determine_inputs(nodes);
        List<String> dff_output_nodes = determine_dff_outputs(nodes);
        assign_levels(gate_list, nodes, input_nodes, dff_output_nodes);
        print_circuit(gate_list);
        System.out.println("------------------------------------------------------------------------");
        print_level_summary(gate_list);
        System.out.println("------------------------------------------------------------------------");
        System.out.println("STARTING SIMULATION");
        String run_simulation = System.console().readLine("Do you want to run the simulation? (y/n): ").strip().toLowerCase();
        if (!run_simulation.equals("y")) {
            return;
        }
        gate_list = read_circuit(filename);
        nodes = new HashMap<>();
        input_nodes = determine_inputs(nodes);
        dff_output_nodes = determine_dff_outputs(nodes);
        assign_levels(gate_list, nodes, input_nodes, dff_output_nodes);
        int max_level = nodes.values().stream().mapToInt(node -> node.Level).max().orElse(-1);
        while (true) {
            prompt_for_inputs(nodes);
            for (String node_name : dff_output_nodes) {
                Node node = nodes.get(node_name);
                if (node != null) {
                    node.state = node.gates.get(0).state;
                }
            }
            for (int level = 0; level <= max_level; level++) {
                GateRecord current = gate_list.head;
                while (current != null) {
                    if (current.Level == level) {
                        if (current.GateType.toLowerCase().matches("not|and|or|xor|nor|nand")) {
                            char new_state = evaluate_gate(current.GateType.toUpperCase(), current.fanin.get(0).state, current.fanin.size() > 1 ? current.fanin.get(1).state : null);
                            if (new_state != current.state) {
                                current.state = new_state;
                            }
                        }
                        if (current.fanout != null && !current.fanout.isDffFanout) {
                            current.fanout.state = current.state;
                        }
                    }
                    current = current.next;
                }
            }
            GateRecord current = gate_list.head;
            while (current != null) {
                if (current.GateType.toLowerCase().startsWith("dff")) {
                    Node input_node = current.fanin.size() > 0 ? current.fanin.get(0) : null;
                    char input_value = input_node != null ? input_node.state : 'U';
                    System.out.printf("Gate %s (%s): State = %c, input = %c%n", current.GateName, current.GateType, current.state, input_value);
                    if (input_node != null) {
                        current.state = input_node.state;
                    }
                }
                current = current.next;
            }
            System.out.println("Node values after this input cycle:");
            for (Map.Entry<String, Node> entry : nodes.entrySet()) {
                String node_name = entry.getKey();
                Node node = entry.getValue();
                System.out.printf("Node %s: State = %c%n", node_name, node.state);
            }
            String continue_simulation = System.console().readLine("Continue simulation? (y/n): ").strip().toLowerCase();
            if (!continue_simulation.equals("y")) {
                return;
            }
        }
    }

    public static void main(String[] args) throws IOException {
        simulate_circuit("S27.txt");
    }
}


