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
* Table S17: 
*
********************************************************************************

	global control sex trueage g101 g1021 h3 d1 smoke drink exercise area f1 income  hypertension diabetes heartdisease stroke_cvd asthma tuberculosis cataract glaucoma cancer gastric_ulcer parkinson bedsore arthritis dementia a2 meat fish egg bean veg tea garl a51 vegeta fruit f41 chil 
	

	*regression_income
	
use "$data/main.dta", clear
	
	
	gen group_income=1
	replace group_income=2 if(income>=0.22&income<0.6)
	replace group_income=3 if(income>=0.6&income<1.5)
	replace group_income=4 if(income>=1.5&income<3.8)
	replace group_income=5 if(income>=3.8)
	replace group_income=. if(income==.)

	reghdfe death c.mean_maxhi##i.group_income c.sd_meanhi c.TN95_adthi c.TD95_adthi c.annual_pre_365 $control , absorb(prov#year prov#month) cluster(gbcode)
	outreg2 using $table/TableS17/TableS17.xls, replace se bracket dec(5) keep(death c.mean_maxhi##i.group_income c.sd_meanhi c.TN95_adthi c.TD95_adthi c.annual_pre_365) addtext(Province-by-Year Fixed Effect, "YES", Province-by-Month Fixed Effect, "YES", Control variables, "YES") addstat(Obs., e(N), Adjusted R-Square, e(r2_a)) nocon nor2 noobs label 
	
	*regression_area
	
	
	reghdfe death c.mean_maxhi##i.area c.sd_meanhi c.TN95_adthi c.TD95_adthi c.annual_pre_365 $control , absorb(prov#year prov#month) cluster(gbcode)
	outreg2 using $table/TableS17/TableS17.xls, append se bracket dec(5) keep(death c.mean_maxhi##i.area c.sd_meanhi c.TN95_adthi c.TD95_adthi c.annual_pre_365) addtext(Province-by-Year Fixed Effect, "YES", Province-by-Month Fixed Effect, "YES", Control variables, "YES") addstat(Obs., e(N), Adjusted R-Square, e(r2_a)) nocon nor2 noobs label 

	gen inn=area*5+group_income
	


	reghdfe death c.mean_maxhi##i.inn c.sd_meanhi c.TN95_adthi c.TD95_adthi c.annual_pre_365 $control , absorb(prov#year prov#month) cluster(gbcode)
	outreg2 using $table/TableS17/TableS17.xls, append se bracket dec(5) keep(death c.mean_maxhi##i.inn c.sd_meanhi c.TN95_adthi c.TD95_adthi c.annual_pre_365) addtext(Province-by-Year Fixed Effect, "YES", Province-by-Month Fixed Effect, "YES", Control variables, "YES") addstat(Obs., e(N), Adjusted R-Square, e(r2_a)) nocon nor2 noobs label 