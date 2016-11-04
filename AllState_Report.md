---
title: "AllState"
author: "Ish Gupta"
date: "November 4, 2016"
output: 
  md document:
    variant: markdown_github


---

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
```

### Background about AllState:
The Allstate Corporation is the second largest personal lines insurer in the United States (behind State Farm) and the largest that is publicly held. The company also has personal lines insurance operations in Canada. 

### Agenda of the Analysis:

Allstate is currently developing automated methods of predicting the cost, and hence
severity, of claims. With this analysis, Allstate needs  an algorithm which accurately predicts **claims Severity**. 

```{r, message=FALSE, echo=FALSE, background=TRUE}
setwd("D:/Upswing Quest/Projects/Kaggle/Springboard/AllState")
```


```{r, message=FALSE, echo= FALSE}
library(readr)
library(dplyr)
library(Amelia)
library(dummies)
library(ranger)
library(data.table)

train <- read_csv("Data/train.csv")


tmp <- train[, -1]
trainModel <- ranger(loss ~ ., data = tmp, importance = "permutation")

test <- read_csv("Data/test.csv")
test = test[,-1]
pred <- predict(trainModel, data = test)

test <- read_csv("Data/test.csv")
test$pred_loss <- pred$predictions
submission <- data.table(test$id)
submission$loss <- pred$predictions

names(submission) <- c("id", "loss")

glimpse(submission)

write_csv(submission, "D:/Upswing Quest/Projects/Kaggle/Springboard/AllState/submission_1.csv")

```
