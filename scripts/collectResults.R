#===============================================================================
#                          Collect the results
#===============================================================================

TotalCells <- nrow(Design)
Row <- 1
load(file.path("results",paste("MyResult", "Row", Row,".Rdata" , sep = "")))
K <- nrow(MyResult)

## Matrix with number of rows = K * TotalCells
Results_sim <- matrix(NA, ncol = ncol(MyResult), nrow = K*TotalCells)

## Fill in the matrix with the results obtained for each cell of the design.
for (i in 1:TotalCells){
  Row <- i
  load(file.path("results",paste("MyResult", "Row", Row,".Rdata" , sep = "")))
  Results_sim[(K*(i - 1) + 1):(i*K), ] <- MyResult
}
Results_des <- Design[rep(1:nrow(Design),each = K),]
rownames(Results_des) <- 1:nrow(Results_des)
Results_K <- do.call(what = rbind, args = replicate(TotalCells, matrix(c(1:K), ncol = 1), simplify = F))

## Creation of the final results matrix
ResultsSimAll <- as.data.frame(cbind(Results_des, K = Results_K, Results_sim))

## Change to the right name of columns
names(ResultsSimAll) <- c(names(Design), "K", "Type", "Intercept", "timepoint", "Prev_resp_1", "mother_smoke")
head(ResultsSimAll)
save(ResultsSimAll, file = "AllResultsSim.Rdata")