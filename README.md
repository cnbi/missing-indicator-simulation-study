
# Simulation Study for Missaing Indicator Method
R code of [The missing indicator method for response variables in binary transition models: A simulation study](https://hdl.handle.net/1887/3280474).

## Project organization
- PG = project-generated
- HW = human-writable
```
.
├── .gitignore
├── CITATION.md
├── README.md
├── results
│   ├── figures        <- Figures for the thesis. (PG)
└── scripts            <- R code for this project (HW)

```
## Running simulation
The scripts necessary for the simulation are:
1) Preparation: Contains the design matrix, libraries, and needed functions.
2) MyDataGeneration: This file is the function to create a non-missing dataset and introduce the missing data following the three mechanisms (MCAR, MAR, and MNAR).
3) SimulationOneCell: Contains MySimulationCell function that calls MyDataGeneration and fit the binomial logistic regression and the multinomial logistic regression in the case of missing.
4) SimulationAllCells: Calls MySimulationCell function and save the results in a file for every design cell.
5) collectResults: Load all the files that contain the results and combine them into a single matrix.
6) MyEvaluation: Includes the code to make boxplots, test MANOVA assumptions, run MANOVA and run ANOVA for each dependent variable.

To carry out the simulation, the files must be run in the following order:
Preparation → SimulationAllCells  → collectResults → MyEvaluation

#TODO
- Clean code 
- Make it easy to run (not running different scripts).
- Adding the figures obtained.
- Create citation
 