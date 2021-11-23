setwd("~/Desktop/r sample files/survey")

library(readxl)
library(dplyr)
library(stringr)

# cleaning for demo
survey <- read_excel("sample.xlsx")

## student submissions
space_lib <- read_excel("Q2.3.xlsx")
survey <- survey %>% left_join(space_lib, by = "ResponseId") 

## no students
survey <- filter(survey, !is.na(survey$Q7.3))

## status
survey$status <- survey$Q7.3
survey$status[survey$status == "Graduate Student / Joint Program" | survey$status == "Study Away"] <- "Other Programs"
survey$status <- factor(survey$status, levels = c("Freshman", "Sophomore", "Junior", "Senior", "Other Programs"))

##country
survey$country <- survey$Q7.2
survey$country[is.na(survey$country)] <- "Undefined"
survey$country <- recode(survey$country, `China` = "China", `United States of America` = "U.S.", `Undefined` = "Undefined", .default = "Other")
survey$country <- factor(survey$country, levels = c("China","U.S.","Other", "Undefined"))

##major
survey$major <- case_when(
  survey$Q7.4 %in% c("Biology", "Chemistry", "Physics", "Neural Science") ~ "Science",
  survey$Q7.4 %in% c("Computer Systems Engineering", "Electrical and Systems Engineering") ~ "CS & Engineering",
  survey$Q7.4 %in% c("Business and Marketing", "Business and Finance", "Economics") ~ "Business, Finance & Economics",
  survey$Q7.4 %in% c("Humanities", "Social Science", "Global China Studies") ~ "Humanities & Social Sciences",
  survey$Q7.4 %in% c("Interactive Media Business", "Data Science") ~ "Data Science & Interactive Media Business",
  survey$Q7.4 %in% "Interactive Media Arts" ~ "Interactive Media Arts",
  survey$Q7.4 %in% "Mathematics" ~ "Mathematics",
  survey$Q7.4 %in% NA ~ "Undefined"
)
survey$major <- factor(survey$major, levels = c("Business, Finance & Economics","Humanities & Social Sciences","Data Science & Interactive Media Business", 
                                                "Interactive Media Arts","Science","CS & Engineering","Mathematics","Undefined"))

## Space Preference: Mid & Final Terms
survey <- survey %>% mutate(
  exams_crowded = ifelse(is.na(Q2.5_1_15_RANK), Q2.5_1_1_RANK, NA),
  exams_crowded = ifelse(is.na(Q2.5_1_1_RANK), Q2.5_1_15_RANK, exams_crowded),
  exams_modpop = ifelse(is.na(Q2.5_1_16_RANK), Q2.5_1_9_RANK, NA),
  exams_modpop = ifelse(is.na(Q2.5_1_9_RANK), Q2.5_1_16_RANK, exams_modpop),
  exams_noisy = ifelse(is.na(Q2.5_1_17_RANK), Q2.5_1_3_RANK, NA),
  exams_noisy = ifelse(is.na(Q2.5_1_3_RANK), Q2.5_1_17_RANK, exams_noisy),
  exams_quiet = ifelse(is.na(Q2.5_1_18_RANK), Q2.5_1_4_RANK, NA),
  exams_quiet = ifelse(is.na(Q2.5_1_4_RANK), Q2.5_1_18_RANK, exams_quiet),
  exams_silent = ifelse(is.na(Q2.5_1_19_RANK), Q2.5_1_5_RANK, NA),
  exams_silent = ifelse(is.na(Q2.5_1_5_RANK), Q2.5_1_19_RANK, exams_silent),
  exams_relaxed = ifelse(is.na(Q2.5_1_20_RANK), Q2.5_1_6_RANK, NA),
  exams_relaxed = ifelse(is.na(Q2.5_1_6_RANK), Q2.5_1_20_RANK, exams_relaxed),
  exams_focused = ifelse(is.na(Q2.5_1_21_RANK), Q2.5_1_7_RANK, NA),
  exams_focused = ifelse(is.na(Q2.5_1_7_RANK), Q2.5_1_21_RANK, exams_focused)
)



## at the end of the day
survey <- 
  survey %>%
  select(status, country, major, Q1.1 = Q1.1_2, Q1.2 = Q1.1_7, Q1.3 = Q1.1_4,
         top_reason = Q2.2, place_options = Q2.5_1_GROUP, space_lib = Q2.3.y,
         rank_crowded = exams_crowded, rank_modpop = exams_modpop, rank_noisy = exams_noisy, rank_quiet = exams_quiet, 
         rank_silent = exams_silent, rank_relaxed = exams_relaxed, rank_focused = exams_focused, workshops = Q4.1)

##
save(survey, file = "survey")


## scale_x_discrete(limits = rev(levels(major))) +
  
  

