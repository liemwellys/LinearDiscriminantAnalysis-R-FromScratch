require(matlib)
require(corpcor)
require(ggplot2)
require(caret)

class0 <- read.csv("D:/0.txt", header=FALSE)
class1 <- read.csv("D:/1.txt", header=FALSE)

#give label based on class data
class0$type <- 0
class1$type <- 1

#find the mean of each feature 
c0mean <- colMeans(class0[,1:784])
c1mean <- colMeans(class1[,1:784])

#global mean
mean <- colMeans(rbind(c0mean,c1mean))

#corrected data by subtracting each class data with global mean
class0corrected <- as.matrix(class0[,1:784] - c0mean)
class1corrected <- as.matrix(class1[,1:784] - c1mean)

#create covariance matrix for each class (scatter matrix belongs to each class)
cov0 <- (t(class0corrected) %*% class0corrected)
cov1 <- (t(class1corrected) %*% class1corrected)

#create covariance matrix for all data (within-class scatter matrix)
data0 <- nrow(class0)
data1 <- nrow(class1)
alldata <- data0 + data1
cov <- cov0 + cov1

#check the cov. matrix (within-class scatter matrix) is invertible / not
#use regular inverse for invertible matrix,
#otherwise use pseudoinverse for non-invertible matrix 
if(det(cov)!=0){
  invCov <- inv(cov)
}else{
  invCov <- pseudoinverse(cov)
}

#calculate projection matrix
w <- invCov %*% (c1mean - c0mean)

#calculate the threshold
w0 <- t(w)%*% (0.5*(c1mean+c0mean))

#combine data from 2 classes of data into 1 matrix
mnist <- rbind(as.matrix(class0[,1:784]) , as.matrix(class1[,1:784]))

# project data onto a line parameterized by a unit vector w
tempClassCheck <- mnist %*% w

#assign y as random number variable
y <- rnorm(alldata, mean = 3, sd = 15)

#give label after LDA
ClassLDA <- matrix(0, nrow = alldata, ncol = 1)

for(i in 1:alldata)
{
  if(tempClassCheck[i] <= w0) ClassLDA[i] <- 0
  else ClassLDA[i] <- 1
}

#plot data based on ground Truth and LDA classification
dfGroundTruth <- data.frame(X = tempClassCheck, Y = y,
                            class= rbind(as.matrix(class0$type), as.matrix(class1$type)))

plotGroundTruth <- ggplot(dfGroundTruth, aes(X, Y, color=factor(class))) + 
  geom_point(aes(x = X, y = Y),size=2) + 
  geom_vline(xintercept = w0, linetype = "dotted", color = "blue", size = 1.5)

ggsave(plotGroundTruth, file = "Ground Truth.PNG", width = 20, height = 10, units = "cm")

dfLDA <- data.frame(X = tempClassCheck, Y = y, class=ClassLDA)
plotLDA <- ggplot(dfLDA, aes(X, Y, color=factor(class))) + geom_point(aes(x = X, y = Y),size=2) +
  geom_vline(xintercept = w0, linetype = "dotted", color = "blue", size = 1.5)
ggsave(plotLDA, file = "LDA.PNG", width = 20, height = 10, units = "cm")

#check the accuracy by using confusion matrix
CM <- confusionMatrix(data = ClassLDA, reference = rbind(as.matrix(class0$type), as.matrix(class1$type)))