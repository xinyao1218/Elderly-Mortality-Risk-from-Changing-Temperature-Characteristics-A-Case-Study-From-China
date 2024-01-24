*==============================================================================* 
* Project: Temperature and China Elderly Death          					   *
* Version:    									    				           *   
* Date:  				                                                       *
* Author: Xin Yao  					                                           *    
*==============================================================================* 

* set directories 
clear all
set maxvar  30000
set matsize 11000 
set more off
cap log close

global dir "C:\Users\yaoxin\Desktop\Death_elderly_Temperature_China"
global data "$dir/data"
global table "$dir/table"
global figure "$dir/figure"

********************************************************************************
*
* Table S12: Robustness CHeck
*
********************************************************************************

	
	
	
	global control sex trueage g101 g1021 h3 d1 smoke drink exercise area f1 income  hypertension diabetes heartdisease stroke_cvd asthma tuberculosis cataract glaucoma cancer gastric_ulcer parkinson bedsore arthritis dementia a2 meat fish egg bean veg tea garl a51 vegeta fruit f41 chil 

	*regression
	use "$data/main.dta", clear
	reghdfe death c.mean_maxhi c.sd_meanhi c.TN95_adthi c.TD95_adthi c.annual_pre_365 $control , absorb(prov#year prov#month) cluster(gbcode)
	outreg2 using $table/TableS12/TableS12.xls, replace se bracket dec(5) keep(death c.mean_maxhi c.sd_meanhi c.TN95_adthi c.TD95_adthi c.annual_pre_365) addtext(Province-by-Year Fixed Effect, "YES", Province-by-Month Fixed Effect, "YES", Control variables, "YES",Data,"ERA5") addstat(Obs., e(N), Adjusted R-Square, e(r2_a)) nocon nor2 noobs label 
	
	*Robustness_checks1
	use "$data/main.dta", clear
	gen pro=floor(gbcode/10000)
	bys death:tab pro
	drop if pro==51
	
	reghdfe death c.mean_maxhi c.sd_meanhi c.TN95_adthi c.TD95_adthi c.annual_pre_365 $control , absorb(prov#year prov#month) cluster(gbcode)
	
	outreg2 using $table/TableS12/TableS12.xls, append se bracket dec(5) keep(death c.mean_maxhi c.sd_meanhi c.TN95_adthi c.TD95_adthi c.annual_pre_365) addtext(Province-by-Year Fixed Effect, "YES", Province-by-Month Fixed Effect, "YES", Control variables, "YES",Data,"ERA5") addstat(Obs., e(N), Adjusted R-Square, e(r2_a)) nocon nor2 noobs label 
	
	*Robustness_checks2
	use "$data/main.dta", clear
	bys death:tab year
	drop if year==2006
	reghdfe death c.mean_maxhi c.sd_meanhi c.TN95_adthi c.TD95_adthi c.annual_pre_365 $control , absorb(prov#year prov#month) cluster(gbcode)
	
	outreg2 using $table/TableS12/TableS12.xls, append se bracket dec(5) keep(death c.mean_maxhi c.sd_meanhi c.TN95_adthi c.TD95_adthi c.annual_pre_365) addtext(Province-by-Year Fixed Effect, "YES", Province-by-Month Fixed Effect, "YES", Control variables, "YES",Data,"ERA5") addstat(Obs., e(N), Adjusted R-Square, e(r2_a)) nocon nor2 noobs label 
	
	*Robustness_checks3
	use "$data/main.dta", clear
	reghdfe death c.mean_maxhi c.sd_meanhi c.TN95_adthi c.TD95_adthi c.annual_pre_365 $control , absorb(prov#year prov#month prov#day) cluster(gbcode)
	
	outreg2 using $table/TableS12/TableS12.xls, append se bracket dec(5) keep(death c.mean_maxhi c.sd_meanhi c.TN95_adthi c.TD95_adthi c.annual_pre_365) addtext(Province-by-Year Fixed Effect, "YES", Province-by-Month Fixed Effect, "YES", Control variables, "YES",Data,"ERA5") addstat(Obs., e(N), Adjusted R-Square, e(r2_a)) nocon nor2 noobs label 
	
	*Robustness_checks4
	use "$data/main.dta", clear
	reghdfe death c.mean_maxhi c.sd_meanhi c.TN95_adthi c.TD95_adthi c.annual_pre_365 $control , absorb(prov year month) cluster(gbcode)
	
	outreg2 using $table/TableS12/TableS12.xls, append se bracket dec(5) keep(death c.mean_maxhi c.sd_meanhi c.TN95_adthi c.TD95_adthi c.annual_pre_365) addtext(Province-by-Year Fixed Effect, "YES", Province-by-Month Fixed Effect, "YES", Control variables, "YES",Data,"ERA5") addstat(Obs., e(N), Adjusted R-Square, e(r2_a)) nocon nor2 noobs label 
	
	
	*Robustness_checks5
	use "$data/main.dta", clear
	replace b11=. if b11>6
	replace b12=. if b12>6
	global control sex b11 b12 trueage g101 g1021 h3 d1 smoke drink exercise area f1 income  hypertension diabetes heartdisease stroke_cvd asthma tuberculosis cataract glaucoma cancer gastric_ulcer parkinson bedsore arthritis dementia a2 meat fish egg bean veg tea garl a51 vegeta fruit f41 chil
	reghdfe death c.mean_maxhi c.sd_meanhi c.TN95_adthi c.TD95_adthi c.annual_pre_365 $control , absorb(prov#year prov#month) cluster(gbcode)
	
	outreg2 using $table/TableS12/TableS12.xls, append se bracket dec(5) keep(death c.mean_maxhi c.sd_meanhi c.TN95_adthi c.TD95_adthi c.annual_pre_365) addtext(Province-by-Year Fixed Effect, "YES", Province-by-Month Fixed Effect, "YES", Control variables, "YES",Data,"ERA5") addstat(Obs., e(N), Adjusted R-Square, e(r2_a)) nocon nor2 noobs label 

	
	*Robustness_checks6
	global control sex trueage g101 g1021 h3 d1 smoke drink exercise area f1 income  hypertension diabetes heartdisease stroke_cvd asthma tuberculosis cataract glaucoma cancer gastric_ulcer parkinson bedsore arthritis dementia a2 meat fish egg bean veg tea garl a51 vegeta fruit f41 chil 
	
	
	use "$data/Robustness_test_ewembi.dta", clear
	reghdfe death c.mean_maxhi c.sd_meanhi c.TN95_adthi c.TD95_adthi c.annual_pre_365 $control , absorb(prov#year prov#month) cluster(gbcode)
	
	outreg2 using $table/TableS12/TableS12.xls, append se bracket dec(5) keep(death c.mean_maxhi c.sd_meanhi c.TN95_adthi c.TD95_adthi c.annual_pre_365) addtext(Province-by-Year Fixed Effect, "YES", Province-by-Month Fixed Effect, "YES", Control variables, "YES",Data,"EWEMBI") addstat(Obs., e(N), Adjusted R-Square, e(r2_a)) nocon nor2 noobs label 