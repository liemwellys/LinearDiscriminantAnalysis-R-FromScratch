# Linear Discriminant Analysis Dimensionality Reduction Code From Scratch using R programming language
Linear Discriminant Analysis code from scratch using R programming language. This code is written for dimensionality reduction on binary class data.

## Required Packages
`matlib`<br>
`corpcor`<br>
`ggplot2`<br>
`caret`<br>

## Dataset
The dataset in this project are ["0 class"](https://github.com/liemwellys/LinearDiscriminantAnalysis-R-FromScratch/blob/master/0.txt) and ["1 class"](https://github.com/liemwellys/LinearDiscriminantAnalysis-R-FromScratch/blob/master/1.txt) from MNIST dataset. There are no header in those files.

## Running the program
Before running the program, makse sure the dataset can be loaded properly from the right filename path. Otherwise, change the following [code](https://github.com/liemwellys/LinearDiscriminantAnalysis-R-FromScratch/blob/master/LDA.R) in line 6-7 into desired filename path.

```R
class0 <- read.csv("D:/0.txt", header=FALSE)
class1 <- read.csv("D:/1.txt", header=FALSE)
```
