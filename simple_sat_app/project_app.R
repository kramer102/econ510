# setwd("/home/robert/all_Robert_asus/prog_asus/R/Project") 

library(RSQLite)
library(dplyr) #takes a while to install
library(tidyr)
library(ggvis)
library(ggplot2)

db <- dbConnect(dbDriver("SQLite"), 
                "/home/robert/all_Robert_asus/prog_asus/R/Project/Data/output/database.sqlite")

df <- dbGetQuery(db, "
SELECT s11.INSTNM College,
                       s11.md_earn_wne_p10 e50,
                       s11.SAT_AVG_ALL sat
                       s11.COSTT4_A cost
                       FROM Scorecard s11
                       -- We have to do a self-join because the CCBASIC metadata is only attached to 2013 data
                       -- And 2013 data has no 10 year out earnings data
                       INNER JOIN Scorecard s13 ON s11.UNITID=s13.UNITID
                       WHERE s11.Year=2011
                       AND s13.Year=2013
                       AND s11.PREDDEG = 'Predominantly bachelor''s-degree granting'
                       --Filter out medical schools and the like that are mislabeled as predominantly bachelor's-degree granting
  AND s13.CCBASIC NOT LIKE '%Special%'
ORDER BY s11.md_earn_wne_p10 DESC")
