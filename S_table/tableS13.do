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
* Table S13: 
*
********************************************************************************

	global control sex trueage g101 g1021 h3 d1 smoke drink exercise area f1 income  hypertension diabetes heartdisease stroke_cvd asthma tuberculosis cataract glaucoma cancer gastric_ulcer parkinson bedsore arthritis dementia a2 meat fish egg bean veg tea garl a51 vegeta fruit f41 chil 


	*regression_sex
	
use "$data/main.dta", clear
	


	reghdfe death c.mean_maxhi##i.sex c.sd_meanhi c.TN95_adthi c.TD95_adthi c.annual_pre_365 $control , absorb(prov#year prov#month) cluster(gbcode)
	
	outreg2 using $table/TableS13/TableS13.xls, replace se bracket dec(5) keep(death c.mean_maxhi##i.sex c.sd_meanhi c.TN95_adthi c.TD95_adthi c.annual_pre_365) addtext(Province-by-Year Fixed Effect, "YES", Province-by-Month Fixed Effect, "YES", Control variables, "YES") addstat(Obs., e(N), Adjusted R-Square, e(r2_a)) nocon nor2 noobs label 
	
	*regression_age
	
use "$data/main.dta", clear
	

	
	gen group_age=1
	replace group_age=2 if(trueage>=75&trueage<85)
	replace group_age=3 if(trueage>=85&trueage<95)
	replace group_age=4 if(trueage>=95)
	replace group_age=. if trueage==.
	replace group_age=. if trueage<65

	reghdfe death c.mean_maxhi##i.group_age c.sd_meanhi c.TN95_adthi c.TD95_adthi c.annual_pre_365 $control , absorb(prov#year prov#month) cluster(gbcode)
	
	outreg2 using $table/TableS13/TableS13.xls, append se bracket dec(5) keep(death c.mean_maxhi##i.group_age c.sd_meanhi c.TN95_adthi c.TD95_adthi c.annual_pre_365) addtext(Province-by-Year Fixed Effect, "YES", Province-by-Month Fixed Effect, "YES", Control variables, "YES") addstat(Obs., e(N), Adjusted R-Square, e(r2_a)) nocon nor2 noobs label 
	
	*regression_BMI
	
use "$data/main.dta", clear
	

	
	gen BMI=g101/((g1021/100)*(g1021/100))
	replace BMI=0 if BMI<24
	replace BMI=2 if BMI>=28
	replace BMI=1 if BMI>=24

    
	reghdfe death c.mean_maxhi##i.BMI c.sd_meanhi c.TN95_adthi c.TD95_adthi c.annual_pre_365 $control , absorb(prov#year prov#month) cluster(gbcode)
	
	outreg2 using $table/TableS13/TableS13.xls, append se bracket dec(5) keep(death c.mean_maxhi##i.BMI c.sd_meanhi c.TN95_adthi c.TD95_adthi c.annual_pre_365) addtext(Province-by-Year Fixed Effect, "YES", Province-by-Month Fixed Effect, "YES", Control variables, "YES") addstat(Obs., e(N), Adjusted R-Square, e(r2_a)) nocon nor2 noobs label 

