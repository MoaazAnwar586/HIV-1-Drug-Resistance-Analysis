#File load krna
hiv <- read.csv("hiv_data.csv")
# Column names change krna
head(hiv)

names(hiv) <- c(
  "Sr_No",
  "Accession",
  "CD4_Count",
  "Viral_Load",
  "ART_Status"
) 
names(hiv)

#Packages install krna then Librarries bhi install krna
install.packages("gtsummary")
install.packages("gt")
install.packages("dplyr")

library(dplyr)
library(gtsummary)
library(gt)

#ART status ko factor yani independent variable me convert krna
hiv$ART_Status <- factor(hiv$ART_Status)

#Table banana for the dependent (continous) variables CD4_Count and Viral_Load by ART_Status
tbl1 <-
  hiv %>%
  select(CD4_Count, Viral_Load, ART_Status) %>%
  tbl_summary(
    by = ART_Status,
    statistic = all_continuous() ~ "{median} ({p25}, {p75})",
    digits = all_continuous() ~ 0
  ) %>%
  add_p(
    test = all_continuous() ~ "wilcox.test"
  ) %>%
  bold_labels()

#Table display krna
tbl1
