library(readr)
library(dplyr)
library(randomForest)
library(biglm)
library(Amelia)
library(dummies)

train <- read_csv("D:/Upswing Quest/Projects/Kaggle/Springboard/AllState/Data/train.csv")
#bigModel <- biglm(formula = loss ~ ., data = train[2:132])

#missmap(train)

train[2:117] <- lapply(train[2:117], factor)

var_names <- names(train)
var_names <- var_names[contains("cat", vars = names(train))]
var_names <- c(var_names, (names(train)[contains("cont", vars= names(train))]))

rf_formula <- as.formula(paste("loss", paste(var_names, collapse = "+"), sep="~"))

ggplot(train, aes(y = loss, x = cat2)) + geom_jitter(alpha = 0.5)

trans <- model.matrix(rf_formula, train)
glimpse(trans)

var_names_mat <- colnames(trans)
var_names_mat <- var_names_mat[contains("cat", vars = colnames(trans))]
var_names_mat <- c(var_names_mat, (colnames(trans)[contains("cont", vars= colnames(trans))]))

rf_formula_mat <- as.formula(paste("loss", paste(var_names_mat, collapse = "+"), sep="~"))

library(data.table)

train <- data.table(train)
trans <- data.table(trans)

trans$loss <- train$loss

#rf_model <- randomForest(rf_formula_mat, trans, ntree=100, importance = T)

library(ranger)
rf_model <- ranger(rf_formula_mat, trans, num.trees = 100, 
                   write.forest = TRUE,  importance = "permutation")

ranger::importance(rf_model)
class(rf_model)

tmp <- read_csv("D:/Upswing Quest/Projects/Kaggle/Springboard/AllState/Data/train.csv")
tmp <- tmp[, -1]
tmpModel <- ranger(loss ~ ., data = tmp, importance = "permutation")

order(tmpModel$variable.importance)

test <- read_csv("D:/Upswing Quest/Projects/Kaggle/Springboard/AllState/Data/test.csv")
test = test[,-1]
pred <- predict(tmpModel, data = test)

test$pred_loss <- pred$predictions
submission <- data.table(test$id)
submission$loss <- pred$predictions

names(submission) <- c("id", "loss")

glimpse(submission)

write_csv(submission, "D:/Upswing Quest/Projects/Kaggle/Springboard/AllState/submission.csv")

