library(tidyverse)
library(haven)


zdhs2005 <- read_dta("~/AERC Projects/Health Investiments and Underntrition/data/2005-06/2005-06kr.DTA") %>% 
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
  )%>% 
  # Converting some variables into factors
  mutate_at(.vars = c("rural.urban", "hhold.heard.sex", "child.gender", "province", "country.code.phase", "child.size.birth", "maternal.education.lvl", "maternal.employment", "child.twin"), 
            .funs = as_factor) %>% 
  # Converting some variables into numeric 
  mutate_at(.vars = c("hhold.heard.age", "child.birth.weight", "child.weight.kgs", "child.height.cm", "child.height.agestd.newho", "child.weight.agestd.newho", "child.weight.heightstd.newho", "bmi.std.newho"), .funs = as.double)


#Assigning NAs to specific numbers in specific variables
#_______________________________________________________

zdhs2005$child.weight.kgs <- ifelse(zdhs2005$child.weight.kgs >= 999, NA, zdhs2005$child.weight.kgs) # Child Weight
zdhs2005$maternal.education.yrs <- ifelse(zdhs2005$maternal.education.yrs >= 90, NA, zdhs2005$maternal.education.yrs) #Maternal Education in Years
zdhs2005$maternal.weight <- ifelse(zdhs2005$maternal.weight >= 9999, NA, zdhs2005$maternal.weight) # Maternal Weight
zdhs2005$maternal.height <- ifelse(zdhs2005$maternal.height >= 9999, NA, zdhs2005$maternal.height) # Maternal Height
zdhs2005$maternal.bmi <- ifelse(zdhs2005$maternal.bmi == 9998, NA, zdhs2005$maternal.bmi) # Maternal BMI
zdhs2005$child.birth.weight <- ifelse(zdhs2005$child.birth.weight > 9995, NA, zdhs2005$child.birth.weight) # Child Birth Weight
zdhs2005$child.weight.kgs <- ifelse(zdhs2005$child.weight.kgs >= 999, NA, zdhs2005$child.weight.kgs) # Child Weight KGs
zdhs2005$child.height.cm <- ifelse(zdhs2005$child.height.cm >= 9999, NA, zdhs2005$child.height.cm) # Child Height cms
zdhs2005$child.height.agestd.newho <- ifelse(zdhs2005$child.height.agestd.newho > 9995, NA, zdhs2005$child.height.agestd.newho) # Child Height New WHO Standards
zdhs2005$child.weight.agestd.newho <- ifelse(zdhs2005$child.weight.agestd.newho > 9995, NA, zdhs2005$child.weight.agestd.newho) # Child Weight New WHO Standards
zdhs2005$child.weight.heightstd.newho <- ifelse(zdhs2005$child.weight.heightstd.newho > 9995, NA, zdhs2005$child.weight.heightstd.newho) # Child Weight Height New WHO Standards
zdhs2005$bmi.std.newho <- ifelse(zdhs2005$bmi.std.newho > 9995, NA, zdhs2005$bmi.std.newho) # New BMI
zdhs2005$antenatal.visits <- ifelse(zdhs2005$antenatal.visits == 98, NA, zdhs2005$antenatal.visits) #Antenatal Care visits

zdhs2005 <-  zdhs2005 %>%  mutate(undernutrition  = case_when(
  child.weight.agestd.newho <= -200 ~ "undernourished",
  TRUE ~ "no undernutrition"
))

# Creating Pseudo Panels

pseudo.panel2005 <- zdhs2005 %>%  
  group_by(province, child.gender) %>% 
  summarise_at(.vars = c("sample.weight", "child.age.months", "antenatal.visits", "maternal.age","under5.fam.size", "fam.size", "maternal.education.yrs", "hhold.heard.age", "fam.wealth", "child.birth.weight", "child.weight.kgs", "child.height.cm", "child.height.agestd.newho", "child.weight.agestd.newho", "child.weight.heightstd.newho", "bmi.std.newho"),
               .funs = mean, na.rm = T) %>% 
  mutate(year = 2005)
