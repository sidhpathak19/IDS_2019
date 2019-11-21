colNames = c ("age", "workclass", "fnlwgt", "education", 
              "educationnum", "maritalstatus", "occupation",
              "relationship", "race", "sex", "capitalgain",
              "capitalloss", "hoursperweek", "nativecountry",
              "incomelevel")

data = read.table ("adult.data", header = FALSE, sep = ",",
                    strip.white = TRUE, col.names = colNames,
                    na.strings = "?", stringsAsFactors = TRUE)
sum(is.na(data))
data<-na.omit(data)
sum(is.null(data))
summary(data$age)
summary(data$capitalloss)
#age graphs
library(ggplot2)
library(gridExtra)
library(caret)
incomeBelow50K = (data$incomelevel == "<=50K")
xlimit = c (min (data$age), max (data$age))
ylimit = c (0, 1600)

hist1 = qplot (age, data = data[incomeBelow50K,], margins = TRUE, 
               binwidth = 2, xlim = xlimit, ylim = ylimit, colour = incomelevel)

hist2 = qplot (age, data =data[!incomeBelow50K,], margins = TRUE, 
               binwidth = 2, xlim = xlimit, ylim = ylimit, colour = incomelevel)

grid.arrange (hist1, hist2, nrow = 2)
#boxplot (age ~ incomelevel, data = data, main = "Age distribution for different income levels",xlab = "Income Levels", ylab = "Age",col="salmon")

summary(data$age)
data$age<-scale(data$age)
data$fnlwgt<-scale(data$fnlwgt)
data$educationnum<-scale(data$educationnum)
data$capitalgain<-scale(data$capitalgain)
data$capitalloss<-scale(data$capitalloss)
data$hoursperweek<-scale(data$hoursperweek)
summary(data$age)
summary(data$capitalloss)
boxplot (age ~ incomelevel, data = data, main = "Age distribution for different income levels",xlab = "Income Levels", ylab = "Age",col="salmon")


summary(data$educationnum)

#incomelevel
#boxplot (educationnum ~ incomelevel, data = data,main = "Years of Education distribution for different income levels",xlab = "Income Levels", ylab = "Years of Education", col = "blue")


#capital gain,capital loss
nearZeroVar (data[, c("capitalgain", "capitalloss")], saveMetrics = TRUE)

summary (myCleanTrain[ data$incomelevel == "<=50K", c("capitalgain", "capitalloss")])


#hoursperweek
summary (data$hoursperweek)

boxplot (hoursperweek ~ incomelevel, data = data, 
         main = "Hours Per Week distribution for different income levels",
         xlab = "Income Levels", ylab = "Hours Per Week", col = "salmon")

nearZeroVar (data[, "hoursperweek"], saveMetrics = TRUE)

#workclass
  qplot (incomelevel, data =data, fill = workclass) + facet_grid (. ~ workclass)
#occupation
qplot (incomelevel, data = data, fill = occupation) + facet_grid (. ~ occupation)
#marital status
qplot (incomelevel, data = data, fill = maritalstatus) + facet_grid (. ~ maritalstatus)

corMat = cor (data[, c("age", "educationnum", "capitalgain", "capitalloss", "hoursperweek")])
diag (corMat) = 0 #Remove self correlati  ons
corMat

library(gmodels)
CrossTable(data$workclass, data$incomelevel, 
           prop.chisq = TRUE,
           chisq = TRUE)
chisq.test(data$race, data$incomelevel)-
  