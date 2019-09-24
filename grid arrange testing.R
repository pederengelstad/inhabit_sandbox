.libPaths( c( "C:/LocalData/Source/RPackages",.libPaths()))

library(png)
library(grid)
library(gridExtra)

plot1 <- readPNG('J:/Projects/NPS/GitHub_Repositories/inhabit_sandbox/test2.png')
plot2 <- readPNG('J:/Projects/NPS/GitHub_Repositories/inhabit_sandbox/test2.png')
plot3 <- readPNG('J:/Projects/NPS/GitHub_Repositories/inhabit_sandbox/test2.png')
plot4 <- readPNG('J:/Projects/NPS/GitHub_Repositories/inhabit_sandbox/test2.png')
blank <- grid.rect(width = 1, gp=gpar(col="white"))


grid.arrange(arrangeGrob(rasterGrob(plot1, hjust = 0.55),top=textGrob("1st Percentile",vjust = 5, gp=gpar(fontsize=10,font=2))),
             arrangeGrob(rasterGrob(plot2, hjust = 0.5),top=textGrob("10th Percentile",vjust = 5, gp=gpar(fontsize=10,font=2))),
             arrangeGrob(rasterGrob(plot3, hjust = 0.55),top=textGrob("MPP",vjust = 5, gp=gpar(fontsize=10,font=2))),
             arrangeGrob(rasterGrob(plot4, hjust = 0.5),top=textGrob("MaxSSS",vjust = 5, gp=gpar(fontsize=10,font=2))),
             ncol=2,top=textGrob("Static Map Outputs", gp=gpar(fontsize=20,font=2)) 
             )


csv = read.csv(header = T, stringsAsFactors = F, 
               file = "J:/Projects/NPS/New folder/cogonGrass/brt_targetTwo_1/CovariateCorrelationOutputMDS_targetTwo_initial.csv")
unique(csv$responseBinary)
sample(csv$bareground.stdev_2May_integer)
