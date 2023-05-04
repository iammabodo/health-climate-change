library(tidyverse)

#Maximum Temperature
maximum_temperature <- read_csv("~/AERC Projects/Health Investiments and Underntrition/data/climate data/maximum-temperature.csv") %>% 
  pivot_longer(2:12,
               names_to = "province",
               values_to = "max-temperature") %>% 
  filter(Year >= 1980)


#Minimum Temperature
minimum_temperature <- read_csv("~/AERC Projects/Health Investiments and Underntrition/data/climate data/minimum-temperature.csv") %>% 
  pivot_longer(2:12,
               names_to = "province",
               values_to = "min-temperature") %>% 
  filter(Year >= 1980)

#Average Temperature
mean_temperature <- read_csv("~/AERC Projects/Health Investiments and Underntrition/data/climate data/mean-temperature.csv") %>% 
  pivot_longer(2:12,
               names_to = "province",
               values_to = "mean-temperature") %>% 
  filter(Year >= 1980)


#Precipitation Temperature
precipitation <- read_csv("~/AERC Projects/Health Investiments and Underntrition/data/climate data/precipitation.csv") %>% 
  pivot_longer(2:12,
               names_to = "province",
               values_to = "precipitation") %>% 
  filter(Year >= 1980)

#Joining Climate Data
climate_data <- minimum_temperature %>% 
  left_join(mean_temperature) %>% 
  left_join(maximum_temperature) %>% 
  left_join(precipitation) %>% 
  filter(province != "National") %>% 
  mutate(province = tolower(province)) %>%
  #Converting Character province to factor variable
  mutate_at(.vars = "province",
            .funs = as_factor)

#Summaries for 2000 to 2005

cohort0 <- climate_data %>% 
  filter(Year>=1994 & Year <=1999) %>% 
  group_by(province) %>% 
  summarise_at(.vars = c("min-temperature", "mean-temperature", "max-temperature", "precipitation"),
               .funs = c(mean, sd)) %>% 
  mutate(year = 1999)


#Summaries for 2000 to 2005

cohort1 <- climate_data %>% 
  filter(Year>=2000 & Year <=2005) %>% 
  group_by(province) %>% 
  summarise_at(.vars = c("min-temperature", "mean-temperature", "max-temperature", "precipitation"),
               .funs = c(mean, sd)) %>% 
  mutate(year = 2005)


#Summaries for 2006 to 2010

cohort2 <- climate_data %>% 
  filter(Year>=2006 & Year <=2010) %>% 
  group_by(province) %>% 
  summarise_at(.vars = c("min-temperature", "mean-temperature", "max-temperature", "precipitation"),
               .funs = c(mean, sd)) %>% 
  mutate(year = 2010)

#Summaries for 2011 to 2015

cohort3 <- climate_data %>% 
  filter(Year>=2011 & Year <=2015) %>% 
  group_by(province) %>% 
  summarise_at(.vars = c("min-temperature", "mean-temperature", "max-temperature", "precipitation"),
               .funs = c(mean, sd)) %>% 
  mutate(year = 2015)

#Binding the climate cohorts
climate_cohort <- rbind(cohort0, cohort1, cohort2, cohort3) %>% 
  rename_with(~tolower(gsub("-", "_", .x, fixed = TRUE))) %>% 
  rename(mintemp_mean = min_temperature_fn1) %>% 
  rename(meantemp_mean = mean_temperature_fn1) %>% 
  rename(maxtemp_mean = max_temperature_fn1) %>% 
  rename(precipitation_mean = precipitation_fn1) %>% 
  rename(mintemp_sd = min_temperature_fn2) %>% 
  rename(meantemp_sd = mean_temperature_fn2) %>%
  rename(maxtemp_sd = max_temperature_fn2) %>%
  rename(precipitation_sd = precipitation_fn2)



climate_cohort$province <- as.character(climate_cohort$province)
climate_cohort$province <- ifelse(climate_cohort$province == "matabeleland north", "matebeleland north", climate_cohort$province)
climate_cohort$province <- ifelse(climate_cohort$province == "matabeleland south", "matebeleland south", climate_cohort$province)
climate_cohort$province<- as.factor(climate_cohort$province)







