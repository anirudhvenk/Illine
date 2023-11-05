import networkx as nx
import matplotlib.pyplot as plt
from networkx.drawing.nx_pydot import to_pydot
import numpy as np

class LineGraph:
    
    def __init__(self):
        self.adjacency_dict = {}
        self.adjacency_matrix = []
        self.head_idx = None
        self.head_graph = None
        self.line = None
        
        self.past_connect = None
        self.cycle_count = 0
        self.wait_time = 0
    
    def get_head_graph(self):
        graph = nx.from_numpy_array(self.adjacency_matrix)
        cc = [graph.subgraph(c).copy() for c in nx.connected_components(graph)]
        for g in cc:
            if g.has_node(self.head_idx):
                self.head_graph = g
    
    def adjacency_dict_to_matrix(self):
        vertices = list(self.adjacency_dict.keys())
        size = len(vertices)
        if (size == 1):
            self.head_idx = 0
        self.adjacency_matrix = np.asarray([[0 for _ in range(size)] for _ in range(size)])

        for key, values in self.adjacency_dict.items():
            for value in values:
                if key not in vertices:
                    vertices.append(key)
                    new_matrix = np.zeros((size + 1, size + 1))
                    new_matrix[:size, :size] = self.adjacency_matrix
                    self.adjacency_matrix = new_matrix
                    size += 1
                if value not in vertices:
                    vertices.append(value)
                    new_matrix = np.zeros((size + 1, size + 1))
                    new_matrix[:size, :size] = self.adjacency_matrix
                    self.adjacency_matrix = new_matrix
                    size += 1

                i = vertices.index(key)
                j = vertices.index(value)
                self.adjacency_matrix[i][j] = 1
                
        self.get_head_graph()
        
    def update_adjacency_matrix(self, data):
        for id in data.keys():
            neighbors = data[id]
            self.adjacency_dict[id] = neighbors
    
        self.adjacency_dict_to_matrix()
        # print(self.findshortestpaths())
        if (len(self.findshortestpaths()) >= 3):
            self.line = self.findshortestpaths()
        
    def draw_and_save_graph(self):
        if (self.head_idx is not None):
            graph = self.head_graph
            P = to_pydot(graph)
            P.write_png('./static/images/graph.png')
        
    def getmaxdistance(self):
        line = False
        graph = nx.from_numpy_array(np.asarray(self.adjacency_matrix))
        distances = {}
    
        # Use BFS to traverse the graph and calculate distances.
        for node in nx.bfs_tree(graph, source=self.head_idx):
            distance = nx.shortest_path_length(graph, source=self.head_idx, target=node)
            distances[node] = distance
    
        # Find the farthest node by maximum distance.
        farthest = max(distances, key=distances.get)
        if(farthest>10):
            return farthest
        return 0
    
    def findshortestpaths(self):
        graph = nx.from_numpy_array(np.asarray(self.adjacency_matrix))
        farthest_node = self.findfarthestnode()
        return nx.shortest_path(graph, source=self.head_idx , target=farthest_node)
    
    def findfarthestnode(self):
        graph = nx.from_numpy_array(np.asarray(self.adjacency_matrix))
        shortest_path_lengths = nx.single_source_shortest_path_length(graph, self.head_idx)
    
        farthest = max(shortest_path_lengths, key=shortest_path_lengths.get)
    
        return farthest
    
        

