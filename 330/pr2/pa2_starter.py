
import sys
import heapq
import math
############################

# DO NOT CHANGE THIS PART!!

############################

def readGraph(input_file):
    with open(input_file, 'r') as f:
        raw = [[float(x) for x in s.split(',')] for s in f.read().splitlines()]
    N = int(raw[0][0])
    m = int(raw[1][0])
    s = int(raw[2][0])
    adj_list = [[] for foo in range(N)]
    for edge in raw[3:]:
        adj_list[int(edge[0])].append((int(edge[1]), edge[2]))
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





def Run(input_file, output_file):
    N, m, s, adj_list = readGraph(input_file)
    distances, parents =   dijkstra(N, m, s, adj_list)
    undirected_adj_list = make_undirected_graph(N, adj_list)
    mst = kruskal(N, m, undirected_adj_list)
    writeOutput(output_file, N, s, distances, parents, mst)


############################

# ADD YOUR OWN METHODS HERE (IF YOU'D LIKE)

############################

############################

# FINISH THESE METHODS

############################



def dijkstra(N, m, s, adj_list):
    # You are given the following variables:
    # N = number of nodes in the graph
    # m = number of edges in the graph
    # s = source node for the algorithm
    # adj_list = a list of lists of size N, where each index represents a node n
    #               the sublist at index n has a list of two-tuples,
    #               representing outgoing edges from n: (adjacent node, weight of edge)
    #               NOTE: If a node has no outgoing edges, it is represented by an empty list
    #
    # WRITE YOUR CODE HERE:
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
    #print(distances)
    #print(parents)
    return distances, parents

def kruskal(N, m, undirected_adj_list):
    # You are given the following variables:
    # N = number of nodes in the graph
    # PLEASE NOTE THAT THE ADJACENCY LIST IS FORMATTED ENTIRELY DIFFERENTLY FROM DIJKSTRA ABOVE
    # undireced_adj_list = a list of lists of size N, where each index represents a node n
    #                       the sublist at index n has a list of two-tuples, representing edges from n: (adjacent node, weight of edge)
    #                       NOTE: Since the graph is undirected, each edge (u,v) is now represented twice in this adjacency list:
    #                               once at index u and once at index v
    #
    # WRITE YOUR CODE HERE:
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

#############################
# CHANGE INPUT FILES FOR PART 2 HERE

#############################

def main(args=[]):
    # WHEN YOU SUBMIT TO THE AUTOGRADER, 
    # PLEASE MAKE SURE THE FOLLOWING FUNCTION LOOKS LIKE:
    # Run('input', 'output')
    Run('input', 'output')

    # AFTER YOUR RUN THE AUTOGRADER,
    # you may change comment out the above line
    # and uncomment the Run commend for the graph from part 2
    # that you wish to work on:
    
    #Run('g_randomEdges.txt', 'output')
    #Run('g_donutEdges.txt', 'output')
    #Run('g_zigzagEdges.txt', 'output')

if __name__ == "__main__":
    main(sys.argv[1:])    