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
* Table S26: 
*
********************************************************************************



	*regression_income
	
use "$data/main.dta", clear
	
	global control sex trueage g101 g1021 h3 d1 smoke drink exercise area f1 income  hypertension diabetes heartdisease stroke_cvd asthma tuberculosis cataract glaucoma cancer gastric_ulcer parkinson bedsore arthritis dementia a2 meat fish egg bean veg tea garl a51 vegeta fruit f41 chil  
	
	gen corn=d1
	replace corn=0 if corn==1|corn==3|corn==4|corn==5
	replace corn=1 if corn==2
	

	reghdfe death c.mean_maxhi c.sd_meanhi c.TN95_adthi##i.veg c.TD95_adthi c.annual_pre_365 $control , absorb(prov#year prov#month) cluster(gbcode)
	outreg2 using $table/TableS26/TableS26.xls, replace se bracket dec(5) keep(death c.mean_maxhi c.sd_meanhi c.TN95_adthi##i.veg c.TD95_adthi c.annual_pre_365) addtext(Province-by-Year Fixed Effect, "YES", Province-by-Month Fixed Effect, "YES", Control variables, "YES") addstat(Obs., e(N), Adjusted R-Square, e(r2_a)) nocon nor2 noobs label 
	
	reghdfe death c.mean_maxhi c.sd_meanhi c.TN95_adthi##i.tea c.TD95_adthi c.annual_pre_365 $control , absorb(prov#year prov#month) cluster(gbcode)
	outreg2 using $table/TableS26/TableS26.xls, append se bracket dec(5) keep(death c.mean_maxhi c.sd_meanhi c.TN95_adthi##i.tea c.TD95_adthi c.annual_pre_365) addtext(Province-by-Year Fixed Effect, "YES", Province-by-Month Fixed Effect, "YES", Control variables, "YES") addstat(Obs., e(N), Adjusted R-Square, e(r2_a)) nocon nor2 noobs label 
	
	
	reghdfe death c.mean_maxhi c.sd_meanhi c.TN95_adthi##i.garl c.TD95_adthi c.annual_pre_365 $control , absorb(prov#year prov#month) cluster(gbcode)
	outreg2 using $table/TableS26/TableS26.xls, append se bracket dec(5) keep(death c.mean_maxhi c.sd_meanhi c.TN95_adthi##i.garl c.TD95_adthi c.annual_pre_365) addtext(Province-by-Year Fixed Effect, "YES", Province-by-Month Fixed Effect, "YES", Control variables, "YES") addstat(Obs., e(N), Adjusted R-Square, e(r2_a)) nocon nor2 noobs label 
	
	reghdfe death c.mean_maxhi c.sd_meanhi c.TN95_adthi##i.vegeta c.TD95_adthi c.annual_pre_365 $control , absorb(prov#year prov#month) cluster(gbcode)
	outreg2 using $table/TableS26/TableS26.xls, append se bracket dec(5) keep(death c.mean_maxhi c.sd_meanhi c.TN95_adthi##i.vegeta c.TD95_adthi c.annual_pre_365) addtext(Province-by-Year Fixed Effect, "YES", Province-by-Month Fixed Effect, "YES", Control variables, "YES") addstat(Obs., e(N), Adjusted R-Square, e(r2_a)) nocon nor2 noobs label 
	
	reghdfe death c.mean_maxhi c.sd_meanhi c.TN95_adthi##i.fruit c.TD95_adthi c.annual_pre_365 $control , absorb(prov#year prov#month) cluster(gbcode)
	outreg2 using $table/TableS26/TableS26.xls, append se bracket dec(5) keep(death c.mean_maxhi c.sd_meanhi c.TN95_adthi##i.fruit c.TD95_adthi c.annual_pre_365 ) addtext(Province-by-Year Fixed Effect, "YES", Province-by-Month Fixed Effect, "YES", Control variables, "YES") addstat(Obs., e(N), Adjusted R-Square, e(r2_a)) nocon nor2 noobs label 
