#================================================================
#                  Data Generation Function
#================================================================

## Input arguments:
## samp: Sample size
## proportion: Proportion of missing full_data

## Model variables:
## id = repeat every id three times.
## t = time point 10, 9, 8.
## mother.smoke (m) = For the time point=8 it is from a binomial distribution with size 1 and probability 0.5. At 
##    time points 9 and 10, the value is the same as the time point 8.
## y_1 = At time point 8 the value is from a binomial distribution with size 1 and probability 0.2 (as the proportion in the example).
##    At time points 9 and 10 the answer depends on the response of previous time point.
## y = -0.293 + (0.296*m) - (0.243*t) + (2.211*y_1), from Agresti (2002).


MyDataGeneration <- function(samp=samp, proportion=proportion){
  full_data <- data.frame(id = numeric(samp*3), t = numeric(samp*3), mother.smoke = numeric(samp*3), 
                          y_1 = numeric(samp*3), y = numeric(samp*3))
  full_data$id <- rep(1:samp, each = 3) 
  full_data$t <- rep(c(10, 9, 8), samp)
  
  ##Generate maternal smoke: Random for t=8 and is the same for t=9 and t=10
  full_data$mother.smoke <- rep(rbinom(n = samp, size = 1, prob = 0.5), each = 3)
  full_data[full_data$t == 8, "y_1"] <- rbinom(n = samp, size = 1, prob = 0.2)
  
  ##Estimate y at t=8
  odds <- exp(-(-0.293 + (0.296*full_data[full_data$t == 8, "mother.smoke"]) - (0.243*8) + 
                  (2.211*full_data[full_data$t == 8, "y_1"]))) # t=8
  probability <- 1/(1 + odds)
  full_data[full_data$t == 8,  "y"] <-  rbinom(n = samp, size = 1, prob = probability)
  
  ##Replace y_1 with the previous response and estimate y
  for (u in 9:10) {
    full_data[full_data$t == u, "y_1"] <- full_data[full_data$t == (u - 1), "y"]
    odds <- exp(-(-0.293 + (0.296*full_data[full_data$t == u, "mother.smoke"]) - (0.243*full_data[full_data$t == u, "t"]) + 
                    (2.211*full_data[full_data$t == u, "y_1"])))
    probability <- 1/(1 + odds)
    full_data[full_data$t == u, "y"] <- rbinom(n = samp, size = 1, prob = probability)
    full <- full_data
  }
  
  # Generate MCAR -----------------------------------------------
  mcar_df <- full
  if (proportion == 0.4) {
    mu <- -0.4 # For 40%
  } else if (proportion == 0.25) {
    mu <- -1.1 #For 25
  }
  prob <- exp(mu) / (1 + exp(mu))
  missing <- rbinom(n = nrow(mcar_df), size = 1, prob = prob)
  mcar_df$missing <- missing
  ##Replace y with "m"
  for (a in 1:nrow(mcar_df)) {
    if (mcar_df[a, "missing"] == 1) {
      mcar_df[a, "y"] = "m"
    }
  }
  ##Replace y_1 with "m"
  for (b in 1:nrow(mcar_df)) {
    if (mcar_df[b, "t"] != 8) {
      if (mcar_df[(b + 1), "y"] == "m") {
        mcar_df[b, "y_1"] <- "m"
      }
    }       
  }
  
  # Generate MAR -------------------------------------------------
  mar_df <- full
  if (proportion == 0.4) {
    mu <- -0.3 - (0.2*full$y_1) #40%
  } else if (proportion == 0.25) {
    mu <- -1 - (0.2*full$y_1) #25%
  }
  prob <- exp(mu) / (1 + exp(mu))
  missing <- rbinom(n = nrow(mar_df), size = 1,prob = prob)
  mar_df$missing <- missing
  ##Replace y with "m"
  for (a in 1:nrow(mar_df)) {
    if (mar_df[a, "missing"] == 1) {
      mar_df[a, "y"] = "m"
    }
  }
  ##Replace y_1 with "m"
  for (b in 1:nrow(mar_df)) {
    if (mar_df[b, "t"] != 8) {
      if (mar_df[(b + 1), "y"] == "m") {
        mar_df[b, "y_1"] <- "m"
      }
    }       
  }
  
  # Generate MNAR ------------------------------------------------
  mnar_df <- full
  if (proportion == 0.4) {
    mu <- -0.3 - (0.2*full$y_1) - (0.3*full$y) 
  } else if (proportion == 0.25) {
    mu <- -1 - (0.2*full$y_1) - (0.3*full$y) 
  }
  prob <- exp(mu) / (1 + exp(mu))
  missing <- rbinom(n = nrow(mnar_df), size = 1,prob = prob)
  mnar_df$missing <- missing
  ##Replace y with "m"
  for (y in 1:nrow(mnar_df)) {
    if (mnar_df[y, "missing"] == 1) {
      mnar_df[y, "y"] = "m"
    }
  }
  ##Replace y_1 with "m"
  for (x in 1:nrow(mnar_df)) {
    if (mnar_df[x, "t"] != 8) {
      if (mnar_df[(x + 1), "y"] == "m") {
        mnar_df[x, "y_1"] <- "m"
      }
    }       
  }
  output = list(
    "Non-missing" = full_data,
    MCAR = mcar_df,
    MAR = mar_df,
    MNAR = mnar_df
  )
  return(output)
}
