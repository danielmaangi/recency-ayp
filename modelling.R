### Method 1: Log-binomial Regression

#This method directly models the risk ratios but can have convergence issues. Here is an example:
  

# Install necessary package if not already installed
if (!requireNamespace("MASS", quietly = TRUE)) {
  install.packages("MASS")
}
library(MASS)

# Sample data
data <- data.frame(
  outcome = c(1, 0, 1, 1, 0, 1, 0, 0, 1, 0),
  exposure = c(1, 1, 0, 1, 0, 1, 0, 0, 1, 0),
  covariate = c(23, 45, 34, 25, 35, 47, 29, 38, 30, 40)
)

# Fit log-binomial model
fit <- glm(outcome ~ exposure + covariate, family = binomial(link = "log"), data = data)

# Extract coefficients and calculate risk ratios
coef <- summary(fit)$coefficients
exp(coef)


### Method 2: Poisson Regression with Robust Error Variance

# This method is often preferred because it avoids convergence issues that can occur with log-binomial regression. Here's how to do it:


# Install necessary packages if not already installed

if (!requireNamespace("sandwich", quietly = TRUE)) {
  install.packages("sandwich")
}

if (!requireNamespace("lmtest", quietly = TRUE)) {
  install.packages("lmtest")
}
library(sandwich)
library(lmtest)

# Fit Poisson model
fit <- glm(outcome ~ exposure + covariate, 
           family = poisson(link = "log"), 
           data = data)

# Calculate robust standard errors
robust_se <- sqrt(diag(vcovHC(fit, type = "HC0")))

# Extract coefficients and calculate risk ratios
coef <- summary(fit)$coefficients
risk_ratios <- exp(coef[, 1])

# Create a data frame with risk ratios and robust standard errors
result <- data.frame(
  Estimate = coef[, 1],
  "Robust SE" = robust_se,
  "Risk Ratio" = risk_ratios
)
print(result)

