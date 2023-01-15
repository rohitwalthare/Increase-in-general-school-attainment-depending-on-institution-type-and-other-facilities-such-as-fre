# setting the the working directory
setwd("D:/7550/project/data/clean")

# install the required packages 
#install.packages("DoubleML", dependencies = T)

# using the required libraries 
library(dplyr)
library(leaps)
library(boot)
library(Matrix)
library(glmnet)
library(pls)
library(DoubleML) 
library(car)
library(sandwich)
library(lmtest)
library(Matrix)
library(mlr3)
# reading the data 
data <- read.csv("finaldata.csv")
#data <- read.csv("finaldata.csv", stringsAsFactors = TRUE)
#data <- read.csv("finaldata.csv",header = T, sep = ",", colClasses=c('numeric','numeric'))

# Viewing the data and dimensions while removing the NA's
fix(data)
names(data)
dim(data)
# dropping few more variables due to less numbwer of observations
data = select(data, -amt_wav, -Scholarship_type, -Transport_concession, -HH_ID) 

# omitting the NA's
data <- na.omit(data)

# Rearranging the data based on results
# Get column names
colnames(data)

data <- data[, c(1,5,11,4,18,12,15,16,20,13,14,17,27,19,21,22,23,24,31,32,33,25,26,27,28,29,30,3,2,6,7,8,9,10,34,35)]

# alternative 
#col_order <- c("IID", "Round","psrl_no", "gen_edu", "age"+
#                ,"age_entry", )
#data <- data[,col_order]

set.seed(1)
# to check the levels of the variables and setting the default as a reference for regression
# levels(data$Institution_type)
# data <- within(data, Institution_type <- relevel(Institution_type, ref = 4))
# 
# levels(data$Medium_instruction)
# data <- within(data, Medium_instruction <- relevel(Medium_instruction, ref = 1))
# 
# levels(data$Round )
# data <- within(data, Round <- relevel(Round, ref = 1))
# 
# levels(data$Gender )
# data <- within(data, Gender <- relevel(Gender, ref = 2))
# 
# levels(data$Sector )
# data <- within(data, Sector <- relevel(Sector, ref = 2))
# 
# levels(data$Free_education )
# data <- within(data, Free_education <- relevel(Free_education, ref = 1))
# 
# levels(data$Textbooks )
# data <- within(data, Textbooks <- relevel(Textbooks, ref = 4))
# 
# levels(data$Stationary )
# data <- within(data, Stationary <- relevel(Stationary, ref = 4))
# 
# levels(data$Midday_meal )
# data <- within(data, Midday_meal <- relevel(Midday_meal, ref = 1))
# 
# levels(data$HH_Computer )
# data <- within(data, HH_Computer <- relevel(HH_Computer, ref = 1))
# 
# #levels(data$Internet )
# #data <- within(data, Internet <- relevel(Internet, ref = 4))
# 
# levels(data$Tution_fee_wav )
# data <- within(data, Tution_fee_wav <- relevel(Tution_fee_wav, ref = 1))
# 
# levels(data$Scholarship )
# data <- within(data, Scholarship <- relevel(Scholarship, ref = 1))
# 
# levels(data$Religion )
# data <- within(data, Religion <- relevel(Religion, ref = 3))
# 
# levels(data$Social_group )
# data <- within(data, Social_group <- relevel(Social_group, ref = 2))
# 
# levels(data$Private_coaching )
# data <- within(data, Private_coaching <- relevel(Private_coaching, ref = 1))
# 
# levels(data$Distance_primary )
# data <- within(data, Distance_primary <- relevel(Distance_primary, ref = 5))
# 
# levels(data$Distance_upper )
# data <- within(data, Distance_upper <- relevel(Distance_upper, ref = 5))
# 
# levels(data$Distance_secondary )
# data <- within(data, Distance_secondary <- relevel(Distance_secondary, ref = 5))
# 
# levels(data$Marital_status )
# data <- within(data, Marital_status <- relevel(Marital_status, ref = 4))

# attach the data 
attach(data)

# running the basic regressions
LR = lm(gen_edu ~Institution_type, data = data)
summary(LR)

# adding rest of the covariates
MLR = lm(gen_edu ~. -IID, data = data)
summary(MLR)

# Adding an interaction term between gen edu and institution type
MLR1 = lm(gen_edu ~. -IID + gen_edu*Institution_type, data = data)
summary(MLR1)

## Running the DID 
MLR2 = lm(gen_edu ~.-IID + Round*Institution_type, data = data )
summary(MLR2)


## Following codes will return the clustered standard errors for the above MLR
coeff_std_err <- data.frame(summary(MLR)$coefficients)
coi_indices <- which(!startsWith(row.names(coeff_std_err), 'Round'))
coeff_std_err[coi_indices,]

mlcoeffcl <- coeftest(MLR, vcov = vcovCL, cluster = ~Round)
mlcoeffcl[coi_indices,]

# using the best subset selection method
#SubsetSelection = regsubsets( gen_edu ~. -IID, data=data, really.big = T)
#summary(SubsetSelection)


# Running the Lasso
# Extract y
y = data$gen_edu

# Extract x but excludng the intercept because the glmnet will add the intercept later
x = model.matrix(gen_edu ~. -IID , data=data)[,-1]

Lasso = glmnet(x,y, alpha=1, lambda=1)
Lasso 
# Make a grid of the values 
grid = 10^seq(2,-2, length=100)

# Run Lasso on this grid of lambda values 
Lasso  = glmnet (x,y, alpha=1, lambda=grid)
dim(coef(Lasso))

# display the estimates 
rbind(grid[c(1,25,50,75,99)],coef(Lasso)[,c(1,25,50,75,99)])

# plot the coefficient 
plot(grid, coef(Lasso)[5,], type="l", col=5, ylim=c(-1,1),
     xlab=expression(lambda), ylab="coefficient") 

for (index in 3:35){
  par(new=T)
  plot(grid, coef(Lasso)[index,], type="l", col=index, ylim=c(-1,1), 
       xlab="", ylab="" )}

# CV for Lasso
Lasso_CV = cv.glmnet(x,y, alpha=1) #use it's own grid to calculate the lambda and then we are using this to calculate the best lamda 
plot(Lasso_CV)

# To get the optimal lambda 
best_lambda = Lasso_CV$lambda.min
best_lambda 

# The Lasso estimate under the best lambda is 
Lasso = glmnet(x,y, alpha=1)
predict(Lasso, type="coefficients", s=best_lambda)

## Running the DML 

# to add only selected x_col or covariates
DoubleMLData$new( data, y_col="gen_edu", d_col="Institution_type", x_col=c("Round","Gender", "Sector", "Free_education", "Textbooks", "Stationary", "Midday_meal", "HH_Computer", "Internet", "Tution_fee_wav", "Scholarship", "Religion", "Social_group", "Transport_mode", "Dist_inst", "Private_coaching", "Distance_primary", "Distance_upper", "Distance_secondary", "state_district", "age", "psrl_no", "other_exp", "tot_exp", "age_entry", "acad_session", "hh_cons_exp", "Course_type", "Present_class", "Change_insttn_365days", "Marital_status")) 

# assigning the above value to new variable 
DML_data = DoubleMLData$new( data, y_col="gen_edu", d_col="Institution_type", x_col=c("Round","Gender", "Sector", "Free_education", "Textbooks", "Stationary", "Midday_meal", "HH_Computer", "Internet", "Tution_fee_wav", "Scholarship", "Religion", "Social_group", "Transport_mode", "Dist_inst", "Private_coaching", "Distance_primary", "Distance_upper", "Distance_secondary", "state_district", "age", "psrl_no", "other_exp", "tot_exp", "age_entry", "acad_session", "hh_cons_exp", "Course_type", "Present_class", "Change_insttn_365days", "Marital_status"))

# to include other treatment varible and you can specify the covariates as well by mentioning the x_col  
DML_data = DoubleMLData$new( data, y_col="gen_edu", d_col=c("Institution_type"))	
print(DML_data)

# Use the machine learner to use in the regression  
# specifying default for the 10 fold 
learner = lrn("regr.cv_glmnet", s="lambda.min")

# Run the DML ie. we are specifying the model now to use the data that we created earlier specifying the variable
# using the lasso for both steps 
DML = DoubleMLPLR$new( DML_data, ml_l=learner, ml_m=learner)  
DML$fit()
print(DML) # it will return the estimated coefficient along  with the std.error

