# How to code linear regression from scratch quick easy
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt

# cost: Compute the mean squared error
def cost(X, Y, M):
    n = len(Y)
    # Predict an output, matrix multiplication
    pred = X @ M.T
    
    return (1 / n) * np.sum((pred - Y) ** 2)

# gradient: Return the gradient from a vector M
def gradient(M, X, Y) -> np.array:
    n = len(Y)
    
    pred = X @ M.T
    
    diff = pred - Y
    grad = np.zeros(len(M))
    
    for j in range(len(M)):
        for i in range(len(X)):
            grad[j] += diff[i] * X.item(i, j)
        grad[j] *= (2 / n)
    return grad
    

# gradient_descent: Heart from our algorithm
def gradient_descent(X, Y, M, learning_rate, iterations):
    n = len(Y)
    cost_history = []
    
    for _ in range(iterations):
        grad = learning_rate * gradient(M, X, Y)
        M = M - grad
        cost_history.append(cost(X, Y, M))

    return (cost_history, M)


def main() -> None:
    # Read the data from the csv
    df = pd.read_csv("sells.csv")

    # Extract the variables baby
    X = df["hours"].to_numpy()
    Y = df["sells"].to_numpy()

    # Add bias term into X to avoid keeping track of it
    X = X.reshape(-1, 1)
    ones = np.ones((X.shape[0], 1))
    X = np.hstack((ones, X))

    # Create the params
    M = np.array([0, 0])

    # Execute the gradient descent
    costs, M = gradient_descent(X, Y, M, 0.001, 100000)
    # print(costs)
    print("coefficients: ", M)
    print("gradient: ", gradient(M, X, Y))
    print("cost function: ", cost(X, Y, M))


if __name__ == "__main__":
    main()


