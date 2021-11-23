## setwd("~/Desktop/r sample files")

library(readxl)
library(dplyr)
library(stringr)
library(data.table)
library(ggplot2)

load("survey")

palette <- list(purple = c("#351F39", "#351C4D", "#6c1f55", "#765285", "#8a6899" ),
                turquoise = c("#709FB0", "#849974", "#A0C1B8"),
                golden = c("#D1A827", "#f3da4c"))

#summary
##summary table
set <- survey[c("status", "country", "major")]
tb <- replicate(length(set), data.frame(), simplify=FALSE)
for (m in 1:length(set)){
  tb[m] <- list(data.frame(table(set[m])))
  tb[[m]]$`%` <- round(tb[[m]]$Freq/320 *100, 2)
  names(tb[[m]]) <- c("", "#", "%")
  tb[[m]] <- tb[[m]][order(tb[[m]]$`#`,decreasing = T),]
}

for (i in 1:3){
  colnames(tb[[i]])[1] <- c("Student Status", "Country / Region", "Major")[i]
}

## plots
plot1 <- 
  ggplot(tb[[1]], aes(`#`, reorder(tb[[1]][,1], -`#`), label = `#`)) +
  geom_segment(aes(x = 0, y = reorder(tb[[1]][,1], -`#`), xend = `#`, yend = reorder(tb[[1]][,1], -`#`)), 
               size = 0.5, color = "grey50") +
  geom_point(size = 10) +
  geom_text(color = "white", size = 4) +
  coord_flip() +
  theme(axis.text.x = element_text(size = 14, angle = 90, hjust = 1),
        axis.text.y = element_text(size = 14),
        axis.title.y = element_blank(),
        axis.title.x = element_blank(),
        axis.ticks.x = element_line(size = 0),
        plot.margin = unit(c(1,2,2,3), "cm"))

plot2 <- 
  ggplot(tb[[2]], aes(`#`, reorder(tb[[2]][,1], -`#`), label = `#`)) +
  geom_segment(aes(x = 0, y = reorder(tb[[2]][,1], -`#`), xend = `#`, yend = reorder(tb[[2]][,1], -`#`)), 
               size = 0.5, color = "grey50") +
  geom_point(size = 10) +
  geom_text(color = "white", size = 4) +
  coord_flip() +
  theme(axis.text.x = element_text(size = 14, angle = 90, hjust = 1),
        axis.text.y = element_text(size = 14),
        axis.title.y = element_blank(),
        axis.title.x = element_blank(),
        axis.ticks.x = element_line(size = 0),
        plot.margin = unit(c(1,2,2,3), "cm"))

plot3 <- 
  ggplot(tb[[3]], aes(`#`, reorder(tb[[3]][,1], -`#`), label = `#`)) +
  geom_segment(aes(x = 0, y = reorder(tb[[3]][,1], -`#`), xend = `#`, yend = reorder(tb[[3]][,1], -`#`)), 
               size = 0.5, color = "grey50") +
  geom_point(size = 10) +
  geom_text(color = "white", size = 4) +
  coord_flip() +
  theme(axis.text.x = element_text(size = 14, angle = 90, hjust = 1),
        axis.text.y = element_text(size = 14),
        axis.title.y = element_blank(),
        axis.title.x = element_blank(),
        axis.ticks.x = element_line(size = 0),
        plot.margin = unit(c(1,2,2,3), "cm"))
