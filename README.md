# CVRP Solver with Cluster-First Route-Second, NSGA-II and Local Search Optimization

This repository contains a MATLAB implementation of a Capacitated Vehicle Routing Problem (CVRP) solver that uses a **Cluster-First Route-Second (CFRS)** strategy followed by **NSGA-II (Non-dominated Sorting Genetic Algorithm II)** and **Local Search (LS)** for multi-objective optimization.

## 📌 Description

This project aims to solve the CVRP by first applying **K-Medoids clustering** to group customer nodes into clusters based on spatial proximity. This helps reduce complexity and improve the initial solution quality, as opposed to starting with random routes.

Once the clusters are formed, a Genetic Algorithm (GA) is applied within each cluster to generate initial routes. Afterward, the solution is optimized further using **NSGA-II and LS**, which balances multiple objectives such as:

- Minimizing total distance
- Balancing load between vehicles
- Reducing the number of routes used

This approach is particularly effective for large-scale CVRP problems, providing a scalable and close-to-optimal solution framework.

## 📁 Dataset

The dataset used is from the **Augerat CVRP benchmark instances**, a well-known open-source dataset for testing VRP algorithms. You can download it from:
- [CVRPLIB - Augerat Set A](http://vrp.atd-lab.inf.puc-rio.br/index.php/en/)

Example file: `A-n32-k5.xlsx` (converted from `.vrp` to `.xlsx` for easy MATLAB processing)

## 🛠 Features

- K-Medoids clustering for CFRS strategy
- Route optimization using Genetic Algorithm
- Multi-objective fine-tuning with NSGA-II
- Route visualization using MATLAB
- Supports capacity constraints and depot handling

## ⚙️ How It Works
1. Clustering Phase
- Customers are grouped into clusters based on spatial proximity using K-Medoids.
- This follows the Cluster-First Route-Second (CFRS) approach, which provides a more guided initial solution rather than starting from random permutations.
- Each cluster is constrained such that the total demand does not exceed vehicle capacity.
2. Routing Phase
- After clustering, a complete route covering all customers is constructed by merging cluster solutions into a single route sequence.
- This initial solution is used to seed the population for the Genetic Algorithm.
3. Optimization Phase (NSGA-II + Local Search)
- A Genetic Algorithm evolves the population using selection, single-point crossover, and mutation.
- Elitism ensures the best solutions are retained each generation.
- A Local Search procedure is applied to the best individual (gbest) in each generation to further refine the solution.
- Local search explores neighboring solutions using mutation-based operators (e.g., swap, scramble, insert).
4. Multi-Objective Fitness Evaluation
-Each solution is evaluated based on the following objectives:
- Total route distance
- Number of vehicles used
- (Optional) Load balancing among vehicles (if enabled in the objective function)
5. Convergence & Output
- The algorithm tracks and plots convergence over generations.
- The best route found is decoded and displayed per vehicle, along with route distance.

## 🚀 How to Run

1. Make sure you have MATLAB installed.
2. Place the dataset (e.g., `A-n32-k5.xlsx`) in the project directory.
3. Run the main script:

```matlab
vrp_cluster_optimization
```
## 📄 This will output:

- Cluster plots with centroids and routes
- Optimized vehicle routes and total distance
- Multi-objective Pareto front using NSGA-II

## 📊 Results & Visualization
The script includes plotting functionalities that show:

1. Customer distribution with clusters
2. Route path for each vehicle
3. Pareto front of optimized solutions

## 📎 Dependencies
- MATLAB R2020b or later
- Optimization Toolbox (for GA and NSGA-II)

## 🧑‍💻 Author
This project was developed as part of a thesis research in logistics optimization using evolutionary algorithms.
Feel free to explore, fork, and contribute!
