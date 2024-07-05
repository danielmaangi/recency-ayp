# 
#  **Create a Data Frame:**
#    Create or load a data frame containing the data you want to analyze. Here’s an example dataset:
# 
#   
   data <- data.frame(
     exposure = c("Yes", "Yes", "No", "No"),
     outcome = c("Disease", "No Disease", "Disease", "No Disease"),
     count = c(20, 80, 10, 90)
   )
#    
# 
# 3. **Calculate Risk Ratios:**
#    Use the `epitools` package to calculate the risk ratios. The `riskratio` function can be used for this:
# 
#   
#    # Create a 2x2 table
   table <- matrix(data$count, nrow = 2, byrow = TRUE,
                   dimnames = list("Exposure" = c("Yes", "No"),
                                   "Outcome" = c("Disease", "No Disease")))
# 
#    # Calculate risk ratios
   rr <- riskratio(table) |> unlist()
#    
# 
# 4. **Convert Results to a Data Frame:**
#    Convert the risk ratio results into a data frame:
# 
#   
   rr_df <- broom::tidy(rr)
#    
# 
# 5. **Create a gtsummary Table:**
#    Use the `tbl_summary` function from `gtsummary` to create a summary table and `modify_header` to format it properly:
# 
#   
#    gt_table <- rr_df %>%
#      select(term, estimate, conf.low, conf.high) %>%
#      rename(
#        "Term" = term,
#        "Risk Ratio" = estimate,
#        "Conf. Low" = conf.low,
#        "Conf. High" = conf.high
#      ) %>%
#      tbl_summary(
#        by = "Term",
#        statistic = list(all_continuous() ~ "{estimate} ({conf.low}, {conf.high})")
#      ) %>%
#      modify_header(label = "Risk Ratio Summary")
#    
# 
# 6. **Print the Table:**
#    Print the `gtsummary` table:
# 
#   
#    print(gt_table)
#    
# 
# This example demonstrates how to calculate risk ratios from a 2x2 table and present the results in a summary table using `gtsummary`. Adjust the example according to your specific data and requirements.