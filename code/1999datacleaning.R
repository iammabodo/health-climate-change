library(tidyverse)
library(haven)


zdhs1999 <- read_dta("~/AERC Projects/Health Investiments and Underntrition/data/1999/1999kr.DTA") %>% 
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
    fam.wealth = wlthindf,
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
    child.height.agestd.newho = hc70,
    child.weight.agestd.newho = hc71,
    child.weight.heightstd.newho = hc72,
    bmi.std.newho = hc73, 
    antenatal.visits = m14
  ) %>% 
  mutate(fam.wealth = fam.wealth * 10000) %>% 
  # Converting some variables into factors
  mutate_at(.vars = c("rural.urban", "hhold.heard.sex", "child.gender", "province", "country.code.phase", "child.size.birth", "maternal.education.lvl", "maternal.employment", "child.twin"), 
            .funs = as_factor) |> 
  # Converting some variables into numeric 
  mutate_at(.vars = c("hhold.heard.age", "child.birth.weight", "child.weight.kgs", "child.height.cm", "child.height.agestd.newho", "child.weight.agestd.newho", "child.weight.heightstd.newho", "bmi.std.newho"), .funs = as.double)


#Assigning NAs to specific numbers in specific variables
#_______________________________________________________

zdhs1999$child.weight.kgs <- ifelse(zdhs1999$child.weight.kgs > 341, NA, zdhs1999$child.weight.kgs) # Child Weight
zdhs1999$maternal.education.yrs <- ifelse(zdhs1999$maternal.education.yrs > 18, NA, zdhs1999$maternal.education.yrs) #Maternal Education in Years
zdhs1999$maternal.weight <- ifelse(zdhs1999$maternal.weight > 9000, NA, zdhs1999$maternal.weight) # Maternal Weight
zdhs1999$maternal.height <- ifelse(zdhs1999$maternal.height > 9000, NA, zdhs1999$maternal.height) # Maternal Height
zdhs1999$maternal.bmi <- ifelse(zdhs1999$maternal.bmi == 9000, NA, zdhs1999$maternal.bmi) # Maternal BMI
zdhs1999$child.birth.weight <- ifelse(zdhs1999$child.birth.weight > 5500, NA, zdhs1999$child.birth.weight) # Child Birth Weight
zdhs1999$child.weight.kgs <- ifelse(zdhs1999$child.weight.kgs > 900, NA, zdhs1999$child.weight.kgs) # Child Weight KGs
zdhs1999$child.height.cm <- ifelse(zdhs1999$child.height.cm > 1310, NA, zdhs1999$child.height.cm) # Child Height cms
zdhs1999$child.height.agestd.newho <- ifelse(zdhs1999$child.height.agestd.newho > 599, NA, zdhs1999$child.height.agestd.newho) # Child Height New WHO Standards
zdhs1999$child.weight.agestd.newho <- ifelse(zdhs1999$child.weight.agestd.newho > 440, NA, zdhs1999$child.weight.agestd.newho) # Child Weight New WHO Standards
zdhs1999$child.weight.heightstd.newho <- ifelse(zdhs1999$child.weight.heightstd.newho > 497, NA, zdhs1999$child.weight.heightstd.newho) # Child Weight Height New WHO Standards
zdhs1999$bmi.std.newho <- ifelse(zdhs1999$bmi.std.newho > 499, NA, zdhs1999$bmi.std.newho) # New BMI
zdhs1999$antenatal.visits <- ifelse(zdhs1999$antenatal.visits > 20, NA, zdhs1999$antenatal.visits) #Antenatal Care visits


# Creating the nutrition status of children

zdhs1999 <-  zdhs1999 %>% 
  mutate(undernutrition  = case_when(
  child.weight.agestd.newho <= -200 ~ "undernourished",
  TRUE ~ "no undernutrition"
))


# Creating Pseudo Panels

pseudo.panel1999 <- zdhs1999 %>% 
  group_by(province, child.gender) %>% 
  summarise_at(.vars = c("sample.weight", "child.age.months", "antenatal.visits", "maternal.age","under5.fam.size", "fam.size", "maternal.education.yrs", "hhold.heard.age", "fam.wealth", "child.birth.weight", "child.weight.kgs", "child.height.cm", "child.height.agestd.newho", "child.weight.agestd.newho", "child.weight.heightstd.newho", "bmi.std.newho"),
               .funs = c(mean, na.rm = T, n)) %>% 
  mutate(year = 1999) %>% 
  arrange(province)
