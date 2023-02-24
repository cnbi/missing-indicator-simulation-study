#===================================================================
#              Simulation of all the cells
#====================================================================
#Design: Design matrix

#Total number of cells
TotalCells <- nrow(Design)
for (i in 1:TotalCells) {
  Row <- i
  MyResult <- MySimulationCell(Design = Design, RowOfDesign = Row, K = 100 )
  # Save results
  save(MyResult, file = paste("MyResult", "Row", Row,".Rdata" , sep = ""))
}

