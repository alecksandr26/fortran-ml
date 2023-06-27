import matplotlib.pyplot as plt  # Import the matplotlib
import numpy as np
import sys
from pathlib import Path


def main():
    if len(sys.argv) != 2:
        print(f"Error: Usage: {sys.argv[0]} file.txt")
        sys.exit(-1)
        
    lines = [line for line in open(sys.argv[1]).readlines()]
    data = {}

    for line in lines:
        line = line.rstrip().split()

        if len(line[1:]) > 1:
            data[line[0][0:-1]] = [float(ele) for ele in line[1:]]
        else:
            data[line[0][0:-1]] = float(line[1:][0])
            
    # plot the data
    x = np.linspace(0.0, max(data['inputs']), num = 1000)

    plt.scatter(data['inputs'], data['outputs'])
    plt.plot(x, data['weights'][0] + data['weights'][1] * x, color = 'r')
    plt.savefig(f"{Path( __file__ ).parent.absolute()}/sales_prediction.png")
    plt.show()


if __name__ == "__main__":
    main()
