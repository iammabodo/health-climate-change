/*	Name of Author	: Eltone Mabodo
	
	Project			: DHS Data Cleaning for the AERC Project.
	
	Task 			: Importing, Renaming and pleriminary data cleaning
	
*/
	
clear

	
**#Changing working directory

cd "C:\Users\hp360x\Documents\Eltone Mabodo Projects\2023\AERC Paper\health-climate-change\Stata code\data"

**#Loading the master dataset (2015 ZDHS)

use 2015kr

**#Appending all the versions of ZDHSs to be used in the study

append using "C:\Users\hp360x\Documents\Eltone Mabodo Projects\2023\AERC Paper\health-climate-change\Stata code\data\1999kr.DTA" ///
	"C:\Users\hp360x\Documents\Eltone Mabodo Projects\2023\AERC Paper\health-climate-change\Stata code\data\2005-06kr.DTA" ///
	"C:\Users\hp360x\Documents\Eltone Mabodo Projects\2023\AERC Paper\health-climate-change\Stata code\data\2010-11.DTA"
			
**#Keep all the necessary variables / delete unnecessary variables

keep ///
	v010 v012 v106 v107 v133 v149 v447a v013 v501 v716 v717 v437 v438 v445 v463a v463z ///
	v730 v701 v702 v715 v729 v704 v705 ///
	v151 v024 v025 v130 v152 v137 v190 v191 v190a v191a wlthindf wlthind5 ///
	caseid midx b19 hw1 b4 m18 m19 b5 b0 hw2 hw1 b2 ///
	hw7 hw8 hw9 hw10 hw11 hw12 hw13 hw71 hw72 hw4 hw5 hw6 hw10 hw11 hw12 hw13 hw15 hw70 hw72 ///
	hc70 hc71 hc72 hc73 ///
	v021 v022 v023 v005 v000

**# Renaming Variables

// Renaming Maternal Characteristics variables

rename ///
	(v010 v012 v106 v107 v133 v149 v447a v013 v501 v716 v717 v437 v438 v445 v463a v463z) ///
	(momyob momage momeduclvl momeducyrs momeducyrs1 momeduclvl1 momage1 momagegrp marriage momemploy1 ///
	momemploy2 momweight momheight mombmi smokes1 smokes2)
	

// Renaming Parternal Characteristics variables

rename ///
	(v730 v701 v702 v715 v729 v704 v705) ///
	(dadage dadeduc1 dadeduc2 dadeduc3 dadeduc4 dadjob1 dadjob2)
	
	
// Renaming Household Characteristics variables

rename ///
	(v151 v024 v025 v130 v152 v137 v190 v191 v190a v191a wlthindf wlthind5) ///
	(headsex province rural religion headage u5pop wealth1 wealth2 wealth3 wealth4 ///
	wealth5 wealth6)
	
	
//Renaming Child Characteristics variables

rename ///
	(b19 hw1 b4 m18 m19 b5 b0 hw2 b2) ///
	(kidage kidage1 kidsex birthweight1 birthweight2 alive twin kidweight kidyob)
	
	
// Renaming Survey Characteristics variables

rename ///
	(v021 v022 v023 v005 v000) ///
	(psu strata1 strata2 sweight dhsphase)


// Renaming Child Health Variables

rename ///
	(hw8 hw9 hw11 hw12 hw71 hw72 hw5 hw6 hw15 hw70 hc70 hc71 hc72 hc73) ///
	(waz1 waz2 whz1 whz2 waz11 whz11 haz1 haz2 kidheight haz11 haz12 waz12 whz21 bmi)
	

	
**#Cleaning the family wealth variables

// Standardising the family wealth variable

gen famwealth1999 = wealth5 * 100000

// Bringing the family wealth figures for the 1999 DHS together with other DHS phases

replace wealth2 = famwealth1999 if wealth2 == .

//Renaming the new wealth variable

rename wealth2 famwealth 

// Family Wealth Categories

recode wealth6 (1 = 1 "poorest") (2 = 2 "poorer") (3 = 3 "middle") (4 = 4 "richer") (5 = 5 "richest"), gen(new_wealth6)

replace wealth1 = new_wealth6 if wealth1 == .

// Renaming the new wealth variable

rename wealth1 famwealthcat

// Drop unnecessary wealth variables
drop wealth3 wealth4 wealth5 wealth6 famwealth1999 new_wealth6

**#Saving Version of the dataset

save "C:\Users\hp360x\Documents\Eltone Mabodo Projects\2023\AERC Paper\health-climate-change\Stata code\processed data\Clean Data Version 1.dta", replace

