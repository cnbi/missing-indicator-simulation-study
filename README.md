# Simulation study

R code of "The missing indicator method for response variables in binary transition models: A simulation study"

For the simulation is necessary to have six scripts:
1) Preparation: Contains the design matrix, libraries and the functions that are needed.
2) MyDataGeneration: In this file is the function to create a non-missing dataset and introduce the missing data following the three mechanisms (MCAR, MAR, and MNAR).
3) SimulationOneCell: Contains MySimulationCell function that calls MyDataGeneration and fit the binomial logistic regression and the multinomial logistic regression in the case of missing.
4) SimulationAllCells: Calls MySimulationCell function and save the results in a file for every design cell.
5) collectResults: Load all the files that contain the results and combine them into a single matrix.
6) MyEvaluation: In this script we make boxplots, test MANOVA assumptions, run MANOVA and run ANOVA for each dependent variable.

In order to run the simulation, the files should be run in the following orer:
Preparation → SimulationAllCells  → collecyResults → MyEvaluation
