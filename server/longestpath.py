from collections import defaultdict

class longestpath:
    def __init__(self, vertices):
        self.graph = defaultdict(list)
        self.V = vertices

    def addEdge(self, u, v):
        self.graph[u].append(v)

    def topologicalSortUtil(self, v, visited, stack):
        visited[v] = True
        if v in self.graph:
            for i in self.graph[v]:
                if visited[i] == False:
                    self.topologicalSortUtil(i, visited, stack)
        stack.insert(0, v)

    def topologicalSort(self):
        visited = [False] * self.V
        stack = []

        for i in range(self.V):
            if visited[i] == False:
                self.topologicalSortUtil(i, visited, stack)

        return stack

    def findLongestPath(self, s):
        dist = [-float('inf')] * self.V
        dist[s] = 0
        stack = self.topologicalSort()

        for vertex in stack:
            for neighbor in self.graph[vertex]:
                if dist[neighbor] < dist[vertex] + 1:
                    dist[neighbor] = dist[vertex] + 1

        max_path = max(dist)
        return max_path

