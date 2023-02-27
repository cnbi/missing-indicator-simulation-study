#=================================================================
#                   My simulation function
#=================================================================

## Input arguments:
## Design = design matrix
## RowOfDesign: number that refers to the row of the design matrix. 
## K: Total number of replications = number of data sets generated in one cell

MySimulationCell <- function(Design = Design, RowOfDesign = Row, K = 100) { #TODO change name of function to lower caps.
  #Create matrix or dataframe to store the results:
  MyResult <- matrix(NA, nrow = K * 4, ncol = 5) #TODO change name of object.
  colnames(MyResult) <- c("type", "Intercept", "timepoint", "Prev_resp_1", "mother_smoke")
  
  #Create a loop over the replications k = 1 to K:
  r_res <- 1
  for (k in 1:K) {
    #Generate data
    #set a random number seed to be able to replicate the result exactly
    set.seed((k + 1000) * RowOfDesign)
    SimDat <- do.call(MyDataGeneration, Design[RowOfDesign, ]) #TODO change the name of object to lower caps.
    
    #Fit logistic regression full data
    model <- glm(y ~ t + y_1 + mother.smoke, data = SimDat[[1]], family = binomial, 
                 maxit = 50)
    
    #Extract the logistic coefficients
    model_coef <- data.frame(coef(model))
    coef_array <- as.vector(t(model_coef))
    MyResult[r_res, ] <- c(names(SimDat)[1], coef_array) #TODO change name of object.
    r_res <- r_res + 1
    
    #Fit multinomial logistic regression
    for (q in 2:4) {
      model <- vglm(y ~ t + y_1 + mother.smoke, control = vglm.control(maxit = 50), 
                    family = multinomial(refLevel = "0"), data = SimDat[[q]])
      #Extract model coefficients
      model_coef <- data.frame(Coef(model))
      model_coef <- model_coef %>% filter(str_ends(row.names(model_coef), "1"))
      model_coef <- model_coef[-which(row.names(model_coef) == "y_1m:1"), ]
      MyResult[r_res, ] <- c(names(SimDat)[q], model_coef) #TODO change name of object.
      r_res <- r_res + 1
    }
  }
  return(MyResult) #TODO change the name of object.
}
