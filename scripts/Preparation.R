#=================================================================
#                   Preparation of the analysis
#=================================================================

## Initialize the factors of your design:
samp <- c(100, 1000)
proportion <- c(0.4, 0.25)
Design <- expand.grid(samp = samp, prop = proportion) #TODO change the name of the variable to design

## Libraries
library(nnet) #Multinomial log linear
library(MASS)
library(VGAM)
library(tidyverse)
library(ggplot2)
library(stats)
library(effectsize)
library(gplots)
library(MVN)
library(heplots)
library(ggpubr)
library(rstatix)
library(kableExtra)

## Functions
source("MyDataGeneration.R")
source("SimulationOneCell.R")

## Running simulation
#TODO Source all the scripts to run the simulation from this file.
