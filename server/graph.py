import networkx as nx
import matplotlib.pyplot as plt
from networkx.drawing.nx_pydot import to_pydot
import numpy as np

class LineGraph:
    
    def __init__(self):
        self.adjacency_dict = {}
        self.adjacency_matrix = []
      
    def adjacency_dict_to_matrix(self):
        vertices = list(self.adjacency_dict.keys())
        size = len(vertices)
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
        
    def update_adjacency_matrix(self, data):
        for id in data.keys():
            neighbors = data[id]
            self.adjacency_dict[id] = neighbors
    
        self.adjacency_dict_to_matrix()
        
    def draw_and_save_graph(self):
        graph = nx.from_numpy_array(self.adjacency_matrix)
        P = to_pydot(graph)
        P.write_png('./static/images/graph.png')
        
    def getmaxdistance(self):
        line = False
        graph = nx.from_numpy_array(np.asarray(self.adjacency_matrix))
        distances = {}
    
         # Use BFS to traverse the graph and calculate distances.
        for node in nx.bfs_tree(graph, source=start_node):
            distance = nx.shortest_path_length(graph, source=start_node, target=node)
            distances[node] = distance
    
    # Find the farthest node by maximum distance.
        farthest = max(distances, key=distances.get)
        if(farthest>10):
            return farthest
        return 0
    def findshortestpaths(self):
        graph = nx.from_numpy_array(np.asarray(self.adjacency_matrix))
        return nx.shortest_path(graph, source = start_node , target = node)
    def findfarthestnode(self):
        graph = nx.from_numpy_array(np.asarray(self.adjacency_matrix))
        shortest_path_lengths = nx.single_source_shortest_path_length(graph, start_node)
    
        farthest = max(shortest_path_lengths, key=shortest_path_lengths.get)
    
        return farthest
    
        

