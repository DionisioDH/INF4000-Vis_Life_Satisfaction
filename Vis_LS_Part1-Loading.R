###################################################################################
# 
# Project                     : Characteristics and Patterns of the Top and Bottom 10% of Areas in England by Life Satisfaction
# Author                      : Dionisio V. Del Orbe H.
# Purpose of this file        : To load data and build data frame for analysis
# Output data.frame           : "Indicators_merged"
# Output image                : N/A
# Pre-run another .R file?    : No
#
###################################################################################

################################################
### 0. Loading Packages used in this .R file ###
################################################

# Note: must use "install.packages(name_package)" for packages not installed

library(tidyverse) 
library(readODS) # function: read_ods()     --> to load main dataset (.ods file)
library(janitor) # function: clean_names()  --> to get valid name for loaded frames from datasets
library(readxl)  # function: read_excel()   --> to load Excel files (.xlsx files)


###############################
### 1. Cleaning environment ###
###############################

# Deleting stored variables
rm(list=ls()) 

###########################################################################
### 2. Loading variables from the "ONS_Indicators_dataset.ods" dataset  ###
###########################################################################

year_analysis_num = 2017 # For this entire project, the year is 2017 (it should not be changed)

#2.1 Defining the function to load the indicators:
Get_Indicator <- function(sheet_num, year_chosen = year_analysis_num, original_col_name, given_column_name){
  df <- read_ods(
    "Data/ONS_Indicators_dataset.ods",
    sheet = sheet_num,
    col_names = TRUE,
    col_types = NULL,
    skip = 5)
  df <- as.data.frame(df)
  df <- df |> 
    filter(Period == year_chosen) # selects 2017
  df <- df |> clean_names() # removes non-standard variable names.
  df <- df |>
    select(LAD_codes = area_code, !!given_column_name := !!sym(original_col_name)) # selects and renames columns
  return(df)
}

#2.2 loading the "life satisfaction" indicator
satisfaction <- Get_Indicator(
  sheet_num = "59", 
  year_chosen = "2017-2018",  # changes default value of 2017
  original_col_name = "value_score_out_of_10", 
  given_column_name = "satisfaction")

#2.3 loading the "income" indicator
income <- Get_Indicator(
  sheet_num = "6", 
  original_col_name = "value", 
  given_column_name = "Income_pounds")

#2.4 loading the "anxiety" indicator
anxiety <- Get_Indicator(
  sheet_num = "56", 
  year_chosen = "2017-2018", 
  original_col_name = "value_score_out_of_10", 
  given_column_name = "anxiety")

#2.5 loading the "time to work" indicator
Travel_to_work <- Get_Indicator(
  sheet_num = "65", 
  original_col_name = "value_minutes", 
  given_column_name = "Time_toWork_mins")

#2.6 loading the "employment rate" indicator
Employment <- Get_Indicator(
  sheet_num = "3", 
  year_chosen = "2017-01-01T00:00:00/P1Y", 
  original_col_name = "value_percent", 
  given_column_name = "Emploment_perct")

#2.7 loading the "smokers rate" indicator
smokers <- Get_Indicator(
  sheet_num = "40", 
  original_col_name = "value_percent", 
  given_column_name = "Smokers_perct")

#2.8 loading the "obesity rate" indicator
obesity <- Get_Indicator(
  sheet_num = "49", 
  year_chosen = "2017-11-16T00:00:00/P1Y", 
  original_col_name = "value_percent", 
  given_column_name = "obesity_perct")

###################################################################################################
### 3. Loading population density variable from the "population_density_dataset.xlsx" dataset  ###
###################################################################################################

#3.1 Loading frame
population_density <- read_excel("Data/population_density_dataset.xlsx",
                                 skip = 3, 
                                 sheet = "Mid-2011 to mid-2022 LSOA 2021")

population_density <- population_density |>
  select("LAD 2021 Code", "LSOA 2021 Code",  "Mid-2017: People per Sq Km")

#3.2 computing average population density for each LAD
population_density <- population_density |>
  group_by(`LAD 2021 Code`) |>
  summarise(mean_pop_density = mean(`Mid-2017: People per Sq Km`, na.rm = TRUE))  
# here we find the mean population density in LAD's (which has several LSOA's)

population_density <- population_density |>
  rename( LAD_codes = `LAD 2021 Code`, 
          mean_pop_dens_2017 = mean_pop_density)

# LIMITATION OF STUDY, this data is provided in per LSOA level. LSOA is finer level than LAD, i.e., there are several LSOA codes in the same LAD
# the population within each LSOA is a bit different. Thus, the mean we calculate here is NOT the true mean of the LAD; however, it is assumed to be close to the true LAD value.


##########################################################################################################
### 4. Loading the Rural / Urban Classification variable from the "urban_classification.xlsx" dataset  ###
##########################################################################################################

#4.1 Loading
Rural_Class <- read_excel("Data/urban_classification.xlsx")

Rural_Class  <- Rural_Class |>
  select( LAD_codes = "LAD18CD", Rural_Classification = "RUC11") 
# selected 2018 LAD as closest to 2017. The most recent RUC is from 2011: 
# https://www.gov.uk/government/collections/rural-urban-classification

#4.2 Make the variable a factor:
Rural_Class$Rural_Classification <- factor(Rural_Class$Rural_Classification, ordered = TRUE,
                                           levels = c("Mainly Rural (rural including hub towns >=80%)",
                                                      "Largely Rural (rural including hub towns 50-79%)",
                                                      "Urban with Significant Rural (rural including hub towns 26-49%)",
                                                      "Urban with City and Town",
                                                      "Urban with Minor Conurbation",
                                                      "Urban with Major Conurbation"))
#4.3 Exploratory Data Analysis:
Rural_Class |> group_by(Rural_Classification) |> summarise(n())

###################################################
### 5. Joining the variables into a data frame  ###
###################################################

# some variables have codes for Scotland, Wales, and Northern Ireland, 
# this is resolved by doing inner joins. Some variables only have England codes, 
# thus, the resulting 295 are only from England

Indicators_merged <- satisfaction |>
  inner_join(income, join_by(LAD_codes)) |> 
  inner_join(anxiety, join_by(LAD_codes))|> 
  inner_join(Travel_to_work, join_by(LAD_codes))|> 
  inner_join(Employment, join_by(LAD_codes))|> 
  inner_join(smokers, join_by(LAD_codes))|> 
  inner_join(obesity, join_by(LAD_codes))|> 
  inner_join(population_density, join_by(LAD_codes))|> 
  inner_join(Rural_Class, join_by(LAD_codes)) # 295 observations


# from the 309 LADs*, we get a frame with 295, this means that 14 LADs were dropped
# these were excluded from the analysis as the data would be incomplete without their existance for all variables
# *ref: https://geoportal.statistics.gov.uk/datasets/ons::local-authority-districts-december-2022-names-and-codes-in-the-uk/about

###################################
### 5. Treating Missing Values  ###
###################################

#5.1 Exploratory data analysis:
# here we see a data frame where any row is missing value
View(Indicators_merged |> filter(if_any(everything(),is.na)))
# LADs with missing values: 
# E07000166 (Richmondshire) was estimated (inputed) as the average from 2016 and 2018 for satisfaction and anxiety (shown below)
# E09000001 (City of London) and E06000053(Isles of Scilly) --> dropped (did not have satisfaction values for any year)

#5.2 dropping missing rows:
Indicators_merged <- Indicators_merged |> 
  drop_na() # two rows dropped (E09000001 (City of London) and E06000053(Isles of Scilly)) # 292 rows

################################
### 9. Clearing environment  ###
################################

# clears environment (deletes intermediate variables used in this .R file)
rm(list = setdiff(ls(), c("Indicators_merged")))