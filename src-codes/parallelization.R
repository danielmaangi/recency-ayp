# Install packages (if not installed)
install.packages("foreach")
install.packages("doParallel")
install.packages("logbin")

# Load libraries
library(foreach)
library(doParallel)
library(logbin)

# Set up parallel backend
num_cores <- detectCores() - 1
cl <- makeCluster(num_cores)
registerDoParallel(cl)

# Create a function to fit the model
fit_model <- function(data_subset) {
  logbin(recency_result ~ age_group + sex + pregnant + testing_history + since_last_test + prep_use, data = data_subset)
}

# Split the data into chunks
split_data <- split(model_data, seq(nrow(model_data) %% num_cores))

# Fit the model in parallel
results <- foreach(data_subset = split_data, .combine = rbind, .packages = 'logbin') %dopar% {
  fit_model(data_subset)
}

# Stop the cluster after computation
stopCluster(cl)

# Print results
print(results)
