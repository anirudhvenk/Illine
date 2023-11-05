from flask import Flask, request, render_template
import networkx as nx
from graph import LineGraph

app = Flask(__name__, template_folder='template')
# past_connect = None
# cycle_count = 0
# wait_time = 0
line_graph = LineGraph()

@app.route('/add', methods=['POST'])
def get_neighbors():
    data = request.get_json()
    line_graph.update_adjacency_matrix(data)
    line_graph.draw_and_save_graph()
    # print(line_graph.line)
    
    if line_graph.line is not None:
        line_graph.cycle_count = line_graph.cycle_count + 1
        if (line_graph.line[1] != line_graph.past_connect):
            line_graph.wait_time = line_graph.cycle_count * 15 * len(line_graph.line)
        line_graph.past_connect = line_graph.line[1]
        print("Wait time: ", line_graph.wait_time)
    
    return "Data recieved!"

@app.route('/')
def home():
    return render_template('home.html')

if __name__ == '__main__':
    app.run(host='10.193.89.254', port=5001)
