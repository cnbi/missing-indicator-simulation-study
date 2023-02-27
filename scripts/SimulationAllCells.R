#===================================================================
#              Simulation of all the cells
#====================================================================
#Design: Design matrix

#Total number of cells
TotalCells <- nrow(Design) #TODO change the name of object to design
for (i in 1:TotalCells) {
  Row <- i #TODO change to low caps
  MyResult <- MySimulationCell(Design = Design, RowOfDesign = Row, K = 100) #TODO change to low caps
  # Save results
  save(MyResult, file = paste("MyResult", "Row", Row, ".Rdata", sep = ""))
}
