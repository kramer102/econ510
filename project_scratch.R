setwd("/home/robert/all_Robert_asus/prog_asus/R/Project") 
## libraries used
#library(readr)
library(RSQLite)
library(dplyr) #takes a while to install
library(tidyr)
library(ggvis)

## just going to add the first bit

#first-look <- read_csv("./Data/output/Scorecard.csv") #crashes computer --> using DB

# using this as reference 
# https://www.kaggle.com/benhamner/us-dept-of-education-college-scorecard/exploring-the-us-college-scorecard-data

db <- dbConnect(dbDriver("SQLite"), "/home/robert/all_Robert_asus/prog_asus/R/Project/Data/output/database.sqlite")
#dbGetQuery(db, "PRAGMA temp_store=2;") #keeps temp in memory; I'm skeptical this is what I want

# query to see whats there
tables <- dbGetQuery(db, "SELECT Name FROM sqlite_master WHERE type='table'")
colnames(tables) <- c("Name")
tables <- tables %>%
  rowwise() %>%
  mutate(RowCount=dbGetQuery(db, paste0("SELECT COUNT(Id) RowCount FROM ", Name))$RowCount[1])

## going to try to get the var names by changing this

print.table(tables)

dbGetQuery(db, "SELECT Year, COUNT(Id) NumSchools FROM Scorecard GROUP BY Year") %>%
  ggvis(~Year, ~NumSchools) %>%
  layer_bars()

## starting from the example and just muddling through partwise
# earnings <- dbGetQuery(db, "
#                        SELECT s11.INSTNM College,
#                               s11.CONTROL CollegeType")

## example
earnings <- dbGetQuery(db, "
SELECT s11.INSTNM College,
                       s11.CONTROL CollegeType,
                       s11.md_earn_wne_p10 e50,
                       s11.pct10_earn_wne_p10 e10,
                       s11.pct25_earn_wne_p10 e25,
                       s11.pct75_earn_wne_p10 e75,
                       s11.pct90_earn_wne_p10 e90
                       FROM Scorecard s11
                       -- We have to do a self-join because the CCBASIC metadata is only attached to 2013 data
                       -- And 2013 data has no 10 year out earnings data
                       INNER JOIN Scorecard s13 ON s11.UNITID=s13.UNITID
                       WHERE s11.Year=2011
                       AND s13.Year=2013
                       AND s11.pct75_earn_wne_p10 IS NOT NULL
                       AND s11.pct75_earn_wne_p10 != 'PrivacySuppressed'
                       AND s11.PREDDEG = 'Predominantly bachelor''s-degree granting'
                       --Filter out medical schools and the like that are mislabeled as predominantly bachelor's-degree granting
  AND s13.CCBASIC NOT LIKE '%Special%'
ORDER BY s11.pct75_earn_wne_p10 DESC")
earnings <- cbind(Rank=1:nrow(earnings), earnings)
earnings$College <- paste(earnings$Rank, earnings$College, sep=". ")
earnings$College <- factor(earnings$College, levels=rev(earnings$College))

### End Example

### basic sqlite from r-bloggers example
alltables <- dbListTables(db) # one table named scorecard
cName <- dbGetQuery(db, PRAGMA table_info("/home/robert/all_Robert_asus/prog_asus/R/Project/Data/output/database.sqlite"))
  