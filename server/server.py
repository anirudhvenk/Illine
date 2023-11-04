from flask import Flask, request
import networkx as nx
from graph import LineGraph

app = Flask(__name__)
line_graph = LineGraph()

@app.route('/add', methods=['POST'])
def get_neighbors():
    data = request.get_json()
    line_graph.update_adjacency_matrix(data)
    line_graph.draw_and_save_graph()
    # print(line_graph.adjacency_matrix)
    
    return "Data recieved!"

if __name__ == '__main__':
    app.run()