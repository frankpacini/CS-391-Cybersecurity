import sys
import random
from queue import Queue
import matplotlib.pyplot as plt
import numpy as np

############################

# DO NOT CHANGE THIS PART!!

############################

def readGraph(input_file):
    with open(input_file, 'r') as f:
        raw = [line.split(',') for line in f.read().splitlines()]

    N = int(raw[0][0])
    sin = raw[1]
    s = []
    for st in sin:
        s.append(int(st))
    adj_list = []
    for line in raw[2:]:
        if line == ['-']:
            adj_list.append([])
        else:
            adj_list.append([int(index) for index in line])
    return N, s, adj_list

def writeOutput(output_file, prob_infect, avg_day):
    with open(output_file, 'w') as f:
        for i in prob_infect:
            f.write(str(i) + '\n')
        f.write('\n')
        for i in avg_day:
            f.write(str(i) + '\n')

 

def Run(input_file, output_file):
    N, s, adj_list = readGraph(input_file)
    #prob_infect, avg_day =   model_outbreak(N, s, adj_list, 0.7)
    model(N, s, adj_list)
    #writeOutput(output_file, prob_infect, avg_day)



def BFS(N, s, adj_list):
    level = ['x']*N
    #######################################

    # COPY YOUR BFS CODE FROM PART 1 HERE

    ########################################
    source = N
    adj_list.append([int(index) for index in s] if type(s) is list else [s])

    discovered = [False]*(N+1)
    discovered[source] = True

    q = Queue(maxsize=N+1)
    q.put(source)

    while not q.empty():
        node = q.get()
        for neighbor in adj_list[node]:
            if discovered[neighbor] == False:
                discovered[neighbor] = True
                q.put(neighbor)
                if not node == source:
                    level[neighbor] = level[node]+1
                else:
                    level[neighbor] = 0
    return level

#######################################

# WRITE YOUR SOLUTION IN THIS FUNCTION

########################################

def model(N, s, adj_list):
    probs = [0.1, 0.24, 0.25, 0.7]
    fig, ax = plt.subplots(nrows=2, ncols=2, gridspec_kw={'width_ratios': [1, 3]})
    ax0, ax1, ax2, ax3 = ax.flatten()
    day = []
    num_inf = []
    num_days = []
    top = 0
    colors = ["skyblue", "seagreen", "b", "maroon"]
    for p in probs:
        prob_infect, avg_day, avg_num = model_outbreak(N, s, adj_list, p)
        avg_day = [round(i) for i in avg_day if i != "inf"]
        top = max(top, sorted(avg_day)[-1])
        prob_infect.sort(reverse=True)
        x = np.linspace(1, len(prob_infect), len(prob_infect))
        ax1.plot(x, prob_infect, label="p="+str(p)#color=colors[int(p/0.2) - 1]
        )
        day.append(avg_day)
        num_inf.append(avg_num)
        num_days.append(sum(avg_day)/len(avg_day))
    y = np.linspace(0, int(top)+1, 2*int(top) + 3)
    print(num_inf)
    print(num_days)
    ax0.bar(probs, num_inf, width=0.1)
    ax2.bar(probs, num_days, width=0.1)
    ax3.hist(day, y, histtype='bar', stacked=True, label=["p="+str(p) for p in probs])
    ax1.legend()
    ax3.legend()
    ax1.set_xlabel("nodes")
    ax2.set_xlabel("p value")
    ax3.set_xlabel("day infected")
    ax1.set_ylabel("probability of infection")
    ax3.set_ylabel("number of nodes")
    ax0.set_title("average number of infections")
    ax2.set_title("average day of infection")
    ax1.set_title("probability distribution of infection")
    ax3.set_title("distribution of average infection day")
    fig.suptitle("SF low", fontsize=20)
    plt.show()

def model_outbreak(N, s, adj_list, p):
    # Again, you are given N, s, and the adj_list
    # You can also call your BFS algorithm in this function,
    # or write other functions to use here.
    # Return two lists of size n, where each entry represents one vertex:
    prob_infect = [0]*N
    # the probability that each node gets infected after a run of the experiment
    avg_day = ['inf']*N
    # the average day of infection for each node
    # (you can write 'inf' for infinity if the node is never infected)
    # The code will write this information to a single text file.
    # If you do not name this file at the command prompt, it will be called 'outbreak_output.txt'.
    # The first N lines of the file will have the probability infected for each node.
    # Then there will be a single space.
    # Then the following N lines will have the avg_day_infected for each node.
    avg_num = 0
    trials = 100
    num = 0
    for i in range(trials):
        level = randBFS(N, s, adj_list, p)
        for j in range(N):
            if level[j] != 'x':
                num += 1
                prob_infect[j] += 1
                if avg_day[j] == 'inf':
                    avg_day[j] = 0
                avg_day[j] += level[j]
        avg_num += num
        num = 0
    for i in range(N):
        if not avg_day[i] == 'inf':
            if type(avg_day[i]) is str:
                print(avg_day[i]) 
            avg_day[i] /= prob_infect[i]
        prob_infect[i] /= trials
    avg_num /= trials

    return prob_infect, avg_day, avg_num

def randBFS(N, s, adj_list, p):
    rand_adj_list = [[] for i in range(N)]
    for i in range(N):
        for j in adj_list[i]:
            if j > i and random.random() <= p:
                rand_adj_list[i].append(j)
                rand_adj_list[j].append(i)
    return BFS(N, s, rand_adj_list)


############################

# DO NOT CHANGE THIS PART!!

############################


# read command line arguments and then run
def main(args=[]):
    filenames = []

    #graph file
    if len(args)>0:
        filenames.append(args[0])
        input_file = filenames[0]
    else:
        print()
        print('ERROR: Please enter file names on the command line:')
        print('>> python outbreak.py graph_file.txt output_file.txt')
        print()
        return

    # output file
    if len(args)>1:
        filenames.append(args[1])
    else:
        filenames.append('outbreak_output.txt')
    output_file = filenames[1]

    Run(input_file, output_file)


if __name__ == "__main__":
    main(sys.argv[1:])    
