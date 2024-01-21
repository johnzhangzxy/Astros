library(clock)
library(lubridate)
library(zoo)
library(writexl)
processed_data <- read.csv("baseball.csv")[,-1]
# Data Processing
processed_data$game_date <- ymd(processed_data$game_date)
processed_data$is_day_game <- as.numeric(processed_data$is_day_game)

## Run differential
processed_data$run_diff <- processed_data$home_score - processed_data$away_score

## Hit diff (single, double, triple, home run)
processed_data$single_diff <- processed_data$home_1b - processed_data$away_1b
processed_data$double_diff <- processed_data$home_2b - processed_data$away_2b
processed_data$triple_diff <- processed_data$home_3b - processed_data$away_3b
processed_data$hr_diff <- processed_data$home_hr - processed_data$away_hr

## Plate Appearance differential 
processed_data$pa_diff <- processed_data$home_pa - processed_data$away_pa
## Free plate appearances differential for home/away (walk + hit by ball)
free_base_home <- processed_data$away_hbp + processed_data$away_bb
free_base_away <- processed_data$home_hbp + processed_data$home_bb
processed_data$free_base_diff <- free_base_home - free_base_away


# Pitching metrics -- k% and bb%
processed_data$home_k <- processed_data$away_so/processed_data$home_pa
processed_data$home_bb <- processed_data$away_bb/processed_data$home_pa

processed_data$away_k <- processed_data$home_so/processed_data$away_pa
processed_data$away_bb <- processed_data$home_bb/processed_data$away_pa

## Defense metrics
processed_data$field_diff <- processed_data$home_fo/processed_data$home_pa - 
  processed_data$away_fo/processed_data$away_pa

## Drop home score/away score
processed_data <- subset(processed_data, select = -c(home_score, away_score))
## Drop hit variables
processed_data <- subset(processed_data, select = -c(home_1b, home_2b, home_3b, home_hr
                                                       ,away_1b, away_2b, away_3b, away_hr))
## Drop plate appearance
processed_data <- subset(processed_data, select = -c(home_pa, away_pa))
## Drop walks/hbp variables
processed_data <- subset(processed_data, select = -c(away_hbp, home_hbp))

# Drop defense variables
processed_data <- subset(processed_data, select = -c(away_fo, away_so, home_fo, home_so))
# Drop venue variable
processed_data <- subset(processed_data, select = -c(venue, venue_name))

write.csv(processed_data, "/Users/anthonyhu/Desktop/data_anthony.csv", row.names=FALSE)
