#plot for IAS abstract

.libPaths("C:/Rlibrary")

installPackage <- function(x) {
  x <- as.character(match.call()[[2]])
  if (!require(x, character.only = TRUE)) {
    install.packages(pkgs = x, repos = "http://cran.r-project.org")
    require(x, character.only = TRUE)
  }
}
# installPackage(dplyr)
# installPackage(tidyr)
# installPackage(ggplot2)
# installPackage(forcats)
library(forcats)
library(dplyr)
library(tidyr)
library(ggplot2)
library(xlsx)
df <- read.xlsx("C:/Users/wau4/OneDrive - CDC/Kenya/SurveillanceAndEpidemiologyBranch/NationalRecency/IAS2023/Table_test.xlsx", sheetName = "Sheet1")

level_order <- c('Age', 'Sex', 'Pregnancy status', 'Pregnant', 'Non-pregnant', 'Testing history', 'Time since last test', 'Testing modality', 'Identified through PNS')
df %>% 
  #filter(Group=="Total") 
  mutate(
  Characteristics = fct_relevel(Characteristics, "Age", "Sex", "Pregnancy status", "Pregnant", "Non-pregnant", "Testing history", "Time since last test", "Testing modality", "Identified through PNS"),
  strata = fct_reorder(strata, cPR)
) %>%
  ggplot(aes(x = factor(strata), y = cPR, group = factor(Characteristics, levels = level_order))) +
  geom_point(aes(colour = factor(Characteristics, levels = level_order)), position = position_dodge(width = 0.5), size = 3) +
  geom_errorbar(aes(colour = factor(Characteristics, levels = level_order), ymin = lcl, ymax = ucl), position = position_dodge(width = 0.5)) +
  geom_hline(yintercept = 1) +
  scale_y_continuous(expand = c(0, 0), limit = c(0,10,1)) +
  coord_flip() +
  facet_grid(rows = vars(Characteristics), scales = "free_y", switch = "y", space = "free_y") +
  theme(
    plot.margin = margin(0.5, 0.5, 0.5, 0.5, unit = "cm"),
    plot.title = element_text(size = 15, face = "bold"),
    strip.text.y = element_text(angle = 270),
    strip.placement = "outside",
    axis.title.x = element_text(margin = margin(t = 0.5, b = 0.5, unit = "cm")),
    axis.title.y = element_blank(),
    axis.text = element_text(size = 10),
    legend.position = "none",
    panel.grid.major.y = element_blank(),
  ) + labs(xlab = "Prevalence ratio")
