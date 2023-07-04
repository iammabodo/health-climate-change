/*	Name	: Eltone Mabodo
	
	Project	: AERC Paper
	
	Task	: Cohort Creation and basic statistical analysis
	
*/

clear

**# Calling in the recoding and variable labeling Do file

**_____________________________________________________________________________________________________________
cd "C:\Users\hp360x\Documents\Eltone Mabodo Projects\2023\AERC Paper\health-climate-change\Stata code\do files"

do Recoding&LabelingVariables

**_____________________________________________________________________________________________________________

**# Declaring survey data

gen wgt = sweight/1000000

svyset [pw = wgt], psu(psu) strata(strata2)


**# Cohorts definition

recode kidyob 	(1994/1996 = 1) ///
				(1997/1999 = 2) ///
				(2000/2002 = 3) ///
				(2003/2005 = 4) ///
				(2006/2008 = 5) ///
				(2009/2011 = 6) ///
				(2012/2014 = 7) ///
				(else = .), gen(threeyrcohort)

recode kidyob 	(1994/1997 = 1) ///
				(1998/2001 = 2) ///
				(2002/2005 = 3) ///
				(2006/2009 = 4) ///
				(2010/2013 = 5) ///
				(2014/2015 = 6), gen(fouryrcohort)


**# Creating pseudo-panels

// Cleaning maternal education years variable
replace momeducyrs1 = . if momeducyrs1 == 99

// Creating Macros

local vars 	momage momeducyrs1 u5pop headage famwealth ///
			kidage1 urban momeducdummy christian headgender ///
			famwealthdummy smoke union dadeduc momemploy ///
			single boy birthsize haz waz whz 


foreach var of varlist `vars' {
	egen float mean_`var' = mean(`var')
}



