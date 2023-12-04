import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
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

    public GateRecord(String name, String gtype) {
        this.GateName = name;
        this.GateType = gtype;
        this.Level = -1;
        this.output = false;
        this.Number = 0;
        this.fanout = null;
        this.fanin = new ArrayList<>();
        this.next = null;
    }
}

class Node {
    public String NodeName;
    public List<GateRecord> gates;
    public boolean isFanout;
    public boolean isDffFanout;
    public int Level;

    public Node(String name) {
        this.NodeName = name;
        this.gates = new ArrayList<>();
        this.isFanout = false;
        this.isDffFanout = false;
        this.Level = -1;
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
    public static void main(String[] args) {
        GateList gate_list = read_circuit("S27.txt");
        Map<String, Node> nodes = new HashMap<>();
        List<String> input_nodes = determine_inputs(nodes);
        List<String> dff_output_nodes = determine_dff_outputs(nodes);
        assign_levels(gate_list, nodes, input_nodes, dff_output_nodes);
        print_circuit(gate_list);
        System.out.println("------------------------------------------------------------------------");
        print_wires(nodes);
        print_level_summary(gate_list);
    }

    public static GateList read_circuit(String filename) {
        GateList gate_list = new GateList();
        Map<String, Node> nodes = new HashMap<>();
        try (BufferedReader br = new BufferedReader(new FileReader(filename))) {
            String line;
            while ((line = br.readLine()) != null) {
                String[] parts = line.strip().split("\\s+");
                if (parts.length < 3 || !parts[2].contains("(")) {
                    continue;
                }
                String gate_type = parts[0];
                String gate_name = parts[1];
                String[] net_names = parts[2].replaceAll("[();]", "").split(",");
                GateRecord gate = gate_list.find_gate(gate_name);
                if (gate == null) {
                    gate = new GateRecord(gate_name, gate_type);
                    gate_list.add_gate(gate);
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
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
        return gate_list;
    }

    public static List<String> determine_inputs(Map<String, Node> nodes) {
        List<String> input_nodes = new ArrayList<>();
        for (Map.Entry<String, Node> entry : nodes.entrySet()) {
            String node_name = entry.getKey();
            Node node = entry.getValue();
            if (!node.isFanout) {
                input_nodes.add(node_name);
            }
        }
        return input_nodes;
    }

    public static List<String> determine_dff_outputs(Map<String, Node> nodes) {
        List<String> dff_output_nodes = new ArrayList<>();
        for (Map.Entry<String, Node> entry : nodes.entrySet()) {
            String node_name = entry.getKey();
            Node node = entry.getValue();
            if (node.isDffFanout) {
                dff_output_nodes.add(node_name);
            }
        }
        return dff_output_nodes;
    }

    public static void assign_levels(GateList gate_list, Map<String, Node> nodes, List<String> initial_nodes, List<String> dff_output_nodes) {
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

    public static void print_wires(Map<String, Node> nodes) {
        System.out.println("List of all wires (nodes), their levels, and connected gates:");
        for (Map.Entry<String, Node> entry : nodes.entrySet()) {
            String node_name = entry.getKey();
            Node node = entry.getValue();
            List<String> connected_gate_names = new ArrayList<>();
            for (GateRecord gate : node.gates) {
                connected_gate_names.add(gate.GateName);
            }
            System.out.println("Wire: " + node_name + ", Level: " + node.Level + ", Connected Gates: " + String.join(", ", connected_gate_names));
        }
    }

    public static void print_circuit(GateList gate_list) {
        GateRecord current = gate_list.head;
        while (current != null) {
            List<String> fanin_names = new ArrayList<>();
            for (Node node : current.fanin) {
                fanin_names.add(node.NodeName);
            }
            String fanout_name = current.fanout != null ? current.fanout.NodeName : "None";
            System.out.println("Gate: " + current.GateName + ", Type: " + current.GateType + ", Level: " + current.Level + ", Fanout: " + fanout_name + ", Fanin: " + String.join(", ", fanin_names));
            current = current.next;
        }
    }

    public static void print_level_summary(GateList gate_list) {
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
        System.out.println("Total number of gates: " + total_gates);
        for (Map.Entry<Integer, Integer> entry : level_count.entrySet()) {
            int level = entry.getKey();
            int count = entry.getValue();
            System.out.println("Level " + level + ": " + count + " gates");
        }
    }
}
