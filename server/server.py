from flask import Flask, request, render_template
import networkx as nx
from graph import LineGraph

app = Flask(__name__, template_folder='template')
line_graph = LineGraph()

@app.route('/add', methods=['POST'])
def get_neighbors():
    data = request.get_json()
    print(data)
    line_graph.update_adjacency_matrix(data)
    # print(line_graph.adjacency_matrix)
    line_graph.draw_and_save_graph()
    
    return "Data recieved!"

@app.route('/')
def home():
    return render_template('home.html')

if __name__ == '__main__':
    app.run(host='10.193.89.254', port=5000)
