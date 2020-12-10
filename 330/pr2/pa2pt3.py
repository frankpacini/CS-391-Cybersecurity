#!/usr/bin/env python3.6
import sys
import heapq
from queue import Queue
import math
import matplotlib.pyplot as plt
import numpy as np
import networkx as nx
############################

# DO NOT CHANGE THIS PART!!

############################
G = nx.Graph()
pos = {}
edge_colors = []
node_colors = []
def readGraph(input_file, locations_file):
    with open(input_file, 'r') as f:
        raw = [[float(x) for x in s.split(',')] for s in f.read().splitlines()]
    N = int(raw[0][0])
    m = int(raw[1][0])
    s = int(raw[2][0])
    adj_list = [[] for foo in range(N)]
    G.add_nodes_from(range(N))
    node_colors = ["#1f78b4"]*N
    node_colors[s] = "#c0ff27"
    for edge in raw[3:]:
        adj_list[int(edge[0])].append((int(edge[1]), edge[2]))

    with open(locations_file, 'r') as f:
        raw_locations = [[float(x) for x in s.split(',')] for s in f.read().splitlines()]
    for i, loc in enumerate(raw_locations[1:]):
        pos[i] = loc
    return N, m, s, adj_list


def writeOutput(output_file, N, s, distances, parents, mst):
    with open(output_file, 'w') as f:
        # output dijkstra
        for i in range(N):
            if i == s:
                f.write('0.0,-\n')
            else:
                f.write(str(distances[i])+','+str(parents[i])+'\n')
        
        # blank space
        f.write('\n')

        #output MST (just neighbors, no edge weights)
        for j in range(N):
            neighbors = []
            for node in mst[j]:
                neighbors.append(str(node[0]))
            # sort for the autograder
            neighbors.sort()
            f.write(','.join(neighbors) +'\n')

# 
def make_undirected_graph(N, adj_list):
    G = {}
    for u in range(N):
        G[u] ={}

    # move our stuff in
    for u in range(N):
        for v in adj_list[u]:
            G[u][v[0]] = v[1]
            G[v[0]][u] = v[1]
    #back to list
    adj_list = ['x' for x in range(N)]
    for u in range(N):
        neighbors = []
        for v in G[u].keys():
            neighbors.append((v, G[u][v]))
        adj_list[u] = list(set(neighbors))
    return adj_list





def Run(input_file, locations_file, output_file):
    N, m, s, adj_list = readGraph(input_file, locations_file)
    distances, parents =   dijkstra(N, m, s, adj_list)
    undirected_adj_list = make_undirected_graph(N, adj_list)
    mst = kruskal(N, m, undirected_adj_list)
    return findBetterTree(N, s, adj_list, distances, parents, mst)


def dijkstra(N, m, s, adj_list):

    pi = [float('inf')]*N
    distances = [float('inf')]*N
    pi[s] = 0.0
    parents = [None]*N
    S = {s: ""}             # Keep track of already fixed nodes to remove old heap entries
    Q = [(pi[i], i) for i in range(N)]  
    heapq.heapify(Q)
    while len(Q):
        while Q[0] in S:
            heapq.heappop(Q)   # Pop entries which have already been removed (which are the old ones)
        u = heapq.heappop(Q)[1] 
        distances[u] = pi[u]
        S[u] = ""
        for tup in adj_list[u]:
            (v, l_v) = tup
            if pi[v] > pi[u] + l_v:
                pi[v] = pi[u] + l_v
                heapq.heappush(Q, (pi[v], v))   # Instead of decrease-key, just push entry with lower weight
                parents[v] = u

    # Return two lists of size N, in which each index represents a node n:
    # distances: the shortest distance from s to n
    # parents: the last (previous) node before n on the shortest path
    return distances, parents

def kruskal(N, m, undirected_adj_list):
    
    E = []
    edgeDict = {}
    for i, adj in enumerate(undirected_adj_list):
        for tup in adj:
            (j, w) = tup
            if not ((i,j) in edgeDict or (j,i) in edgeDict):    # Use edge dict to exclude reverse direction of edge already added
                E.append([i,j,w])       # Store edges as a list of the two endpoints and weight
                edgeDict[(i,j)] = ""
    E = sorted(E, key = lambda x: x[2])     # Sort the edges by weight, the 3rd index of the list    
    size = [1]*N
    head = [None]*N
    mst_adj_list = [[] for _ in range(N)]
    for e in E:
        u, v, w = e
        h_u = u        # Interim "pointers" while finding head of u and v components
        h_v = v        # eventually will equal head[u] and head[v], respectively
        while head[h_u] != None or head[h_v] != None:
            h_u = head[h_u] if head[h_u] else h_u
            h_v = head[h_v] if head[h_v] else h_v
        if h_u != h_v:      # If u and v are in different components
            mst_adj_list[u].append((v, w))
            mst_adj_list[v].append((u, w))
            if size[h_u] > size[h_v]:     # Add the smaller of the two components to the other
                size[h_u] += size[h_v]
                head[h_v] = h_u
            else:
                size[h_v] += size[h_u]
                head[h_u] = h_v
            if max(size[h_u], size[h_v]) == N:  # If the combined component has N nodes, we're done
                break
    # Return the adjacency list for the MST, formatted as a list-of-lists in exactly the same way as undirected_adj_list
    return mst_adj_list

def findBetterTree(N, s, adj_list, sp_dist, sp_parents, mst):
    
    mst_cost, mst_dist = getCostDist(N, s, mst) # Get cost and distance of the mst to use in the TWR and to get the highest DR nodes
    """
    for child, parent in enumerate(sp_parents):
        if parent != None:
            G.add_edge(child, parent)
    """

    dist_ratios = [0 if sp_dist[u] == 0 or u == s else mst_dist[u]/sp_dist[u] for u in range(N)]
    sorted_dist_ratios = sorted(list(enumerate(dist_ratios)), key = lambda x: x[1])     # Sort by the distance ratios, storing the node since it no longer corresponds to the index.
    a = 0
    b = N
    while(a < b):   
        i = -1
        n = math.ceil((a + b)/2.0)  # Binary search for the minimizing value n
        tree = [arr.copy() for arr in mst]      # Reset the tree each iteration back to the mst
        while abs(i) < n:   # Start with the highest DR node, and add an edge only for the highest n
            u = sorted_dist_ratios[i][0]
            v = sp_parents[u]
            if not (v == None or v in [e[0] for e in tree[u]]):     # If there is a valid edge not already in the tree
                w = adj_list[u][[e[0] for e in adj_list[u]].index(v)][1]    # Weight not ctually needed but for consistency of tree adj list
                tree[u].append((v, w))
                tree[v].append((u, w))
            i -= 1
        
        tree_dist, tree_parents = dijkstra(N, 0, s, tree)   # Make it a tree by removing the now unnecessary (mst) edges
        tree_cost = 0.0
        for child, parent in enumerate(tree_parents):
            if parent != None:
                weight = 0
                for e in adj_list[parent]:
                    if e[0] == child:
                        weight = e[1]       # Calculate the cost for the new tree
                        break
                tree_cost += weight

        TWR = tree_cost / mst_cost
        MDR = max([0 if sp_dist[u] == 0 or u == s else tree_dist[u]/sp_dist[u] for u in range(N)])
        
        if(TWR < MDR):  # Can tighten considered range of values for n
            a = n + 1
        else:
            b = n - 1

    for child, parent in enumerate(tree_parents):
        if parent != None:
            G.add_edge(child, parent)   # Construct networkx graph of minimizing tree (for visualization)
    print(TWR, MDR, n)
    return TWR, MDR


def getCostDist(N, s, undirected_adj_list):
    dist = [0.0]*N
    cost = 0.0
    
    discovered = [False]*N
    discovered[s] = True
    q = Queue(maxsize=N+1)
    q.put(s)
    while not q.empty():
        node = q.get()
        for tup in undirected_adj_list[node]:
            neighbor, weight = tup
            if discovered[neighbor] == False:
                discovered[neighbor] = True
                q.put(neighbor)
                cost += weight
                dist[neighbor] = dist[node] + weight
                #G.add_edge(child, parent)

    return cost, dist

def main(args=[]):
    Run('g_randomEdges.txt', 'pa2_locations/g_randomLocations.txt', 'output')
    #Run('g_donutEdges.txt', 'pa2_locations/g_donutLocations.txt', 'output')
    #Run('g_zigzagEdges.txt', 'pa2_locations/g_zigzagLocations.txt', 'output')

    nx.draw(G, node_size=10, pos=pos, edge_color="#210000", width=0.75)
    plt.show()
 
if __name__ == "__main__":
    main(sys.argv[1:])    
