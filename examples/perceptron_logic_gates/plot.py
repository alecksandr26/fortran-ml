import matplotlib.pyplot as plt  # Import the matplotlib
import numpy as np
import sys
from pathlib import Path


# main: Execute the main fucntion and catch the data
def main():
    if len(sys.argv) != 2:
        print(f"Error: Usage: {sys.argv[0]} file.txt")
        sys.exit(-1)
        
    lines = [line for line in open(sys.argv[1]).readlines()]
    data = {}

    for line in lines:
        line = line.rstrip().split()
        # Hash each keyword from the file with the correspond data
        if len(line[1:]) > 1:
            data[line[0][0:-1]] = [float(ele) for ele in line[1:]]
        else:
            data[line[0][0:-1]] = float(line[1:][0])
            
    def func_and(x : np.ndarray) -> np.ndarray:
        return - (data['and_w1'] * x + data['and_b']) / data['and_w2']

    def func_or(x : np.ndarray) -> np.ndarray:
        return - (data['or_w1'] * x + data['or_b']) / data['or_w2']

    def func_nand(x : np.ndarray) -> np.ndarray:
        return - (data['nand_w1'] * x + data['nand_b']) / data['nand_w2']

    # plot the data
    x = np.linspace(0.0, 1.0, num = 1000)
    figure, axis = plt.subplots(2, 2)

    axis[0, 0].scatter(data['x1'], data['x2'])
    axis[0, 0].plot(x, func_and(x))
    axis[0, 0].set_title("And")

    axis[0, 1].scatter(data['x1'], data['x2'])
    axis[0, 1].plot(x, func_or(x))
    axis[0, 1].set_title("Or")


    axis[1, 0].scatter(data['x1'], data['x2'])
    axis[1, 0].plot(x, func_nand(x))
    axis[1, 0].set_title("Nand")
    plt.savefig(f"{Path( __file__ ).parent.absolute()}/logic_gates.png")
    plt.show()

if __name__ == "__main__":
    main()

