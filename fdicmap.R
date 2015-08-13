setwd("C:/Users/gent7553/Documents/R")
data <- read.csv("fdicdata.csv")

### Please download and install Rtools 3.3 from http://cran.r-project.org/bin/windows/Rtools/ 
### and then run find_rtools().
### https://www.rstudio.com/products/rpackages/devtools/

library(reshape2)
library(RColorBrewer)
library(plyr)
install.packages('rMaps')
find_rtools()
install_github('rCharts', 'ramnathv')
install_github('rMaps', 'ramnathv')
library(rCharts)
install.packages('devtools')
library(rMaps)


data2 <- transform(data,
                   State = state.abb[match(as.character(State), state.abb)],
                   fillKey = cut(ccusemo, quantile(ccusemo, seq(0, 1, 1/8)), labels = LETTERS[1:8]),
                   Year = as.numeric(substr(Year, 1, 4))
                   )

kable(head(data2), format = 'html', table.attr = 'class=nofluid')

fills = setNames(
  c(RColorBrewer::brewer.pal(8, "YlOrRd"), "white"),
  c(LETTERS[1:8], 'defaultFill')
)

data3 <- dlply(na.omit(data2), "Year", function(x) {
  y = toJSONArray2(x, json = F)
  names(y) = lapply(y, '[[', "State")
  return(y)
})

options(rcharts.cdn = TRUE)
map <- Datamaps$new()
map$set(
  dom = 'chart_1',
  scope = 'usa',
  fills = fills,
  data = data3[[1]],
  legend = TRUE,
  labels = TRUE
)
map
