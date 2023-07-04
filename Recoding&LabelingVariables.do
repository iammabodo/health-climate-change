/*	Name		:	Eltone Mabodo

	Assignment	:	AERC Project 
	
	Task		: 	Recoding and Labeling VAriables
	
*/


clear

// Calling in the import and pleriminary data cleaning do file
cd "C:\Users\hp360x\Documents\Eltone Mabodo Projects\2023\AERC Paper\health-climate-change\Stata code\do files"

do ImportingData&RenamingVariables

**# Recoding Variables

// 1. Rural to urban variable

recode rural (1 = 1 "urban residents") (2 = 0 "rural residents"), gen(urban)

label variable urba "1 = urban residents, 0 = rural residents"

drop rural

// 2. Maternal education dummy

recode momeduclvl (min/2 = 0 "secondary or lower") (max = 1 "tertiary or higher"), gen(momeducdummy)

label variable momeducdummy "1 = tertiary level, 0 = secondary level or lower"

drop momeduclvl momeduclvl1

// 3. Religion dummy

replace religion = . if religion == 9 | religion == 96

recode religion (2/7 = 1 "christian") (1 max = 0 "traditional"), gen(christian)

label variable christian "1 = christian and muslim, 0 = traditional"

drop religion

// 4. Household head gender

recode headsex (1 = 1 "male") (2 = 0 "female"), gen(headgender)

label variable headgender "1 = male, 0 = female"

drop headsex

// 5. Family Wealth Variable

recode famwealthcat (1/2 = 1 "poor") (3/max = 0 "middle and rich"), gen(famwealthdummy)

label variable famwealthdummy "1 = poor, 0 = middle or rich"

drop famwealthcat

// 6. Maternal Smoking

recode smokes2 (0 9 = 1 "smokes") (1 = 0 "do not smoke"), gen(smoke)

label variable smoke "1 if mother smokes, 0 otherwise"

drop smokes1 smokes2

// 7. Marital Status

recode marriage (1 2 = 1 "union") (0 3 4 5 = 0 "single"), gen(union)

label variable union "1 if mother is in marriage/union, 0 if single"

drop marriage


// 8. Paternal Education

recode dadeduc1 (0/2 = 0 "secondary or lower") (3 = 1 "tertiary/higher") (else = .), gen(dadeduc)

label variable dadeduc "1 if father has tertiary/higher education, 0 otherwise"

drop dadeduc1 dadeduc2 dadeduc3 dadeduc4


// 9. Maternal Employment

recode momemploy2 (0 = 1 "unemployed") (1/10 = 0 "employed") (else = .), gen(momemploy)

label variable momemploy "1 if mom employed, 0 otherwise"

drop momemploy1 momemploy2

// 10. Twin Variable 

recode twin (0 = 1 "single birth") (1/3 = 0 "multiple births"), gen(single)

label variable single "1 if child was born alone, 0 if the child was part of multiple births"

drop twin

// 11. Child Gender

recode kidsex (1 = 1 "boy") (2 = 0 "girl"), gen(boy)

label variable boy "1 if the child is a boy, 0 if girl"

// 12. Birthweight

recode birthweight1 (1/3 = 1 "average + above") (4/5 = 0 "less than average") (else = .), gen(birthsize)

label variable birthsize "1 if the child birthsize was average or above, 0 otherwise"

drop birthweight1

**# Cleaning Health Indicator Variables

// 1. Height for Age Z score

replace haz1 = . if haz1 > 598

gen haz = haz1/100

label variable haz "Height for Age Z score"

// 2. Weight for Age Z score

replace waz1 = . if waz1 > 596

gen waz = waz1/100

label variable waz "Weight for Age z score"


// 3. Weight for Height Z Score

replace whz1 = . if whz1 > 599

gen whz = whz1/100

label variable whz "Weight for Height Z score"


// 4. Dropping all the unnecessary health indicator variables

drop hw4 haz1 haz2 hw7 waz1 waz2 hw10 whz1 whz2 hw13 haz11 waz11 whz11 haz12 waz12 whz21


**# Saving the second version of the cleaned data
save "C:\Users\hp360x\Documents\Eltone Mabodo Projects\2023\AERC Paper\health-climate-change\Stata code\processed data\Clean Data Version 2.dta", replace








