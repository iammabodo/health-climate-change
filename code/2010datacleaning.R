library(tidyverse)
library(haven)

zdhs2010 <- read_dta("~/AERC Projects/Health Investiments and Underntrition/data/2010-11/2010-11.DTA") %>% 
  select(
    case.id = caseid,
    birth.hist.index = midx,
    child.age.months = hw1,
    sample.weight = v005,
    maternal.dob.cmc =v011,
    maternal.age = v012,
    under5.fam.size = v137,
    fam.size = v136,
    country.code.phase = v000,
    province = v024,
    rural.urban = v025,
    maternal.education.yrs = v133,
    maternal.education.lvl = v106,
    maternal.employment = v717,
    hhold.heard.sex = v151,
    hhold.heard.age = v152,
    fam.wealth = v191,
    maternal.weight = v437,
    maternal.height = v438,
    maternal.bmi = v445,
    child.twin = b0,
    child.mob = b1,
    child.yob = b2,
    child.dob.cmc = b3,
    child.gender = b4,
    child.birth.weight = m19,
    child.size.birth = m18,
    child.weight.kgs = hw2,
    child.height.cm = hw3,
    child.height.agestd.newho = hw70,
    child.weight.agestd.newho = hw71,
    child.weight.heightstd.newho = hw72,
    bmi.std.newho = hw73, 
    antenatal.visits = m14
  ) %>% 
  # Converting some variables into factors
  mutate_at(.vars = c("rural.urban", "hhold.heard.sex", "child.gender", "province", "country.code.phase", "child.size.birth", "maternal.education.lvl", "maternal.employment", "child.twin"), 
            .funs = as_factor) %>% 
  # Converting some variables into numeric 
  mutate_at(.vars = c("hhold.heard.age", "child.birth.weight", "child.weight.kgs", "child.height.cm", "child.height.agestd.newho", "child.weight.agestd.newho", "child.weight.heightstd.newho", "bmi.std.newho"), .funs = as.double)

#Assigning NAs to specific numbers in specific variables
#_______________________________________________________

zdhs2010$child.weight.kgs <- ifelse(zdhs2010$child.weight.kgs > 855, NA, zdhs2010$child.weight.kgs) # Child Weight
zdhs2010$maternal.education.yrs <- ifelse(zdhs2010$maternal.education.yrs > 21, NA, zdhs2010$maternal.education.yrs) #Maternal Education in Years
zdhs2010$maternal.weight <- ifelse(zdhs2010$maternal.weight > 9993, NA, zdhs2010$maternal.weight) # Maternal Weight
zdhs2010$maternal.height <- ifelse(zdhs2010$maternal.height > 9993, NA, zdhs2010$maternal.height) # Maternal Height
zdhs2010$maternal.bmi <- ifelse(zdhs2010$maternal.bmi == 9998, NA, zdhs2010$maternal.bmi) # Maternal BMI
zdhs2010$child.birth.weight <- ifelse(zdhs2010$child.birth.weight > 9995, NA, zdhs2010$child.birth.weight) # Child Birth Weight
zdhs2010$child.weight.kgs <- ifelse(zdhs2010$child.weight.kgs > 9993, NA, zdhs2010$child.weight.kgs) # Child Weight KGs
zdhs2010$child.height.cm <- ifelse(zdhs2010$child.height.cm > 9993, NA, zdhs2010$child.height.cm) # Child Height cms
zdhs2010$child.height.agestd.newho <- ifelse(zdhs2010$child.height.agestd.newho > 9995, NA, zdhs2010$child.height.agestd.newho) # Child Height New WHO Standards
zdhs2010$child.weight.agestd.newho <- ifelse(zdhs2010$child.weight.agestd.newho > 9995, NA, zdhs2010$child.weight.agestd.newho) # Child Weight New WHO Standards
zdhs2010$child.weight.heightstd.newho <- ifelse(zdhs2010$child.weight.heightstd.newho > 9995, NA, zdhs2010$child.weight.heightstd.newho) # Child Weight Height New WHO Standards
zdhs2010$bmi.std.newho <- ifelse(zdhs2010$bmi.std.newho > 9995, NA, zdhs2010$bmi.std.newho) # New BMI
zdhs2010$antenatal.visits <- ifelse(zdhs2010$antenatal.visits == 98, NA, zdhs2010$antenatal.visits) #Antenatal Care visits


zdhs2010 <-  zdhs2010 %>%  mutate(undernutrition  = case_when(
  child.weight.agestd.newho <= -200 ~ "undernourished",
  TRUE ~ "no undernutrition"
))

# Creating Pseudo Panels

pseudo.panel2010 <- zdhs2010 %>%  
  group_by(province, child.gender) %>% 
  summarise_at(.vars = c("sample.weight", "child.age.months", "antenatal.visits", "maternal.age","under5.fam.size", "fam.size", "maternal.education.yrs", "hhold.heard.age", "fam.wealth", "child.birth.weight", "child.weight.kgs", "child.height.cm", "child.height.agestd.newho", "child.weight.agestd.newho", "child.weight.heightstd.newho", "bmi.std.newho"),
               .funs = mean, na.rm = T) %>% 
  mutate(year = 2010)
