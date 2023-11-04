import networkx as nx
import matplotlib.pyplot as plt
import numpy as np

class LineGraph:
    
    def __init__(self):
        self.adjacency_dict = {}
        self.adjacency_matrix = []
        
    def adjacency_dict_to_matrix(self):
        vertices = list(self.adjacency_dict.keys())
        size = len(vertices)
        self.adjacency_matrix = [[0 for _ in range(size)] for _ in range(size)]
        
        for key, values in self.adjacency_dict.items():
            for value in values:
                i = vertices.index(key)
                j = vertices.index(value)
                self.adjacency_matrix[i][j] = 1
        
    def update_adjacency_matrix(self, data):
        id = next(iter(data))
        for id in data.keys():
            neighbors = data[id]
            self.adjacency_dict[id] = neighbors
    
        self.adjacency_dict_to_matrix()
        
    def draw_and_save_graph(self):
        graph = nx.from_numpy_array(np.asarray(self.adjacency_matrix))
        nx.draw(graph, with_labels=True)
        # plt.savefig('plotgraph.png', dpi=300, bbox_inches='tight')
        
        