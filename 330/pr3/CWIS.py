# Hannah Catabia, catabia@bu.edu
# Solution code for PA2, CS330 Fall 2020
# Adapted from:
# Gavin Brown, grbrown@bu.edu
# CS330 Fall 2019, Programming Exercise Solution 



import sys


############################

# DO NOT CHANGE THIS PART!!

############################

def readInput(input_file):
    with open(input_file, 'r') as f:
        raw = [[float(x) for x in s.split(',')] for s in f.read().splitlines()]
        # number of intervals
        N = int(raw[0][0])
        # max number to schedule
        k =  int(raw[1][0])
        # intervals, with name of interval as an int
        intervals = raw[2:]

        for i in range(len(intervals)):
            intervals[i][0] = int(intervals[i][0])
        return N, k, intervals
    

def writeOutput(schedule, output_file):
    with open(output_file, 'w') as f:
        for i in schedule:
            f.write(str(i) + '\n')


def Run(input_file, output_file):
    N, k, intervals = readInput(input_file)
    schedule = find_solution(N, k, intervals)
    assert all(isinstance(n, int) for n in schedule), "All items in schedule array should be type INT, otherwise the autograder will fail."
    writeOutput(schedule, output_file)


############################

# ADD YOUR OWN METHODS HERE
# (IF YOU'D LIKE)

############################


############################

# FINISH THESE METHODS

############################

def find_solution(N, k, intervals):

    intervals.sort(key = lambda x: x[2])        # Sort intervals by finish time
    intervals_by_start = sorted(intervals, key=lambda x: x[1])  # Create a copy sorted by start time
    p = []
    i = N - 1
    j = N - 1
    while(i >= 0):                              # Iterate through the start array from N - 1 to 0
        while(j >= 0 and intervals[j][2] > intervals_by_start[i][1]): # Decrement down to the highest finish time interval which is compatible with interval i. Any interval in the finish array not compatible with i can't be compatible with those in 0 to i-1 of the start array.
            j -= 1
        prev = 0        # If all intervals have been considered, there is no earlier compatible job, so assign to 0 (which means none)
        if j >= 0:
            prev = j+1      # Shift from 0-indexed to 1-indexed
        p.append((intervals_by_start[i][2], prev))      # Append p-value with finish time so that the list can be sorted to correct indexes in the following list comprehension
        i -= 1

    p = [tup[1] for tup in sorted(p, key=lambda x: x[0])]

    m = [[None]*(k+1) for _ in range(N+1)]
    b = [[None]*(k+1) for _ in range(N+1)]

    for i in range(N+1):        # Base cases
        m[i][0] = 0
    for j in range(k+1):
        m[0][j] = 0

    for i in range(1, N+1):
        for j in range(1, k+1):
            x = m[i-1][j]
            y = intervals[i-1][3]   # i - 1 for intervals and p since i is 1-indexed
            if p[i-1] != None:
                y += m[p[i-1]][j-1]
            if x > y:       # Take the larger of the two subproblems, as in homework 10
                m[i][j] = x
                b[i][j] = (i - 1, j)
            else:
                m[i][j] = y
                b[i][j] = (p[i-1], j - 1)

    schedule = []
    ptr = b[N][k]   # Backtrace using b to determine schedule
    i = N
    j = k
    while ptr != None:  
        if ptr[1] < j:      # If the chosen subproblem has smaller max num of intervals, then current interval is in optimal solution
            schedule.append(intervals[i-1][0])
        i, j = ptr
        ptr = b[i][j]
    
    return schedule




############################################

# CHANGE INPUT FILES FOR DEBUGGING HERE

############################################

def main(args=[]):
    # WHEN YOU SUBMIT TO THE AUTOGRADER, 
    # PLEASE MAKE SURE THE FOLLOWING FUNCTION LOOKS LIKE:
    # Run('input', 'output')
    Run('input', 'output')

if __name__ == "__main__":
    main(sys.argv[1:])    

