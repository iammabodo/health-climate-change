library(tidyverse)
library(plm)
library(foreign)

#Joining Panels
completedata <- rbind(pseudo.panel1999, pseudo.panel2005, pseudo.panel2010, pseudo.panel2015) 
data <- rbind(zdhs1999, zdhs2005, zdhs2010, zdhs_2015) %>% 
  group_by(child.gender, province) %>% 
  summarise(mean.haz = mean(child.height.agestd.newho,na.rm = T), n = n())
  

completedata$province <- as.character(completedata$province)
completedata$province <- ifelse(completedata$province == "matabeleland north", "matebeleland north", completedata$province)
completedata$province <- ifelse(completedata$province == "matabeleland south", "matebeleland south", completedata$province)
completedata$province <- as.factor(completedata$province)


finaldata <- completedata %>% 
  left_join(climate_cohort,
            by = c("province", "year")) 

pdata <- pdata.frame(finaldata, index = c("province", "year"))

fixed <- plm(child.height.agestd.newho ~ maternal.education.yrs + child.age.months + antenatal.visits + maternal.age + under5.fam.size + fam.size + 
               child.gender + fam.wealth + bmi.std.newho + hhold.heard.age + meantemp_mean, 
             data=finaldata, index = "province",effect = "time", model = "within")

summary(fixed)

random <- plm(child.height.agestd.newho ~  province + maternal.education.yrs + child.age.months + antenatal.visits + maternal.age + under5.fam.size + fam.size + 
               child.gender + fam.wealth + hhold.heard.age + bmi.std.newho + precipitation_sd + (precipitation_sd*province),
             data=finaldata, index = c("province", "year"),  model = "random", random.method = "nerlove")
summary(random)

gmm <- pgmm(child.height.agestd.newho ~ lag(child.height.agestd.newho) + province + maternal.education.yrs + child.age.months + antenatal.visits + maternal.age + under5.fam.size + fam.size + 
              child.gender + fam.wealth + hhold.heard.age + bmi.std.newho + precipitation_sd + year-1 | lag(child.height.agestd.newho, 2), data=pdata,  model = "twosteps", effect = "twoways")


completedata %>% 
  ggplot(aes(year, 
             child.height.agestd.newho,
             color = province)) +
  geom_line()
unique(completedata$province)


