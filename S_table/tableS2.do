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
* Table S2: 
*
********************************************************************************

use "$data/main.dta", clear
	
	
	global control sex trueage g101 g1021 h3 d1 smoke drink exercise area f1 income  hypertension diabetes heartdisease stroke_cvd asthma tuberculosis cataract glaucoma cancer gastric_ulcer parkinson bedsore arthritis dementia a2 meat fish egg bean veg tea garl a51 vegeta fruit f41 chil 
	

	*regression
	reghdfe death  c.mean_mean  c.sd_mean c.TN95_mean  c.TD95_mean  c.annual_pre_365 $control , absorb(prov#year prov#month) cluster(gbcode)
	outreg2 using $table/TableS2/TableS2.xls, replace se bracket dec(5) keep(death  c.mean_mean  c.sd_mean c.TN95_mean  c.TD95_mean  c.annual_pre_365) addtext(Province-by-Year Fixed Effect, "YES", Rrovince-by-Month Fixed Effect, "YES", Control variables, "YES") addstat(Obs., e(N), Adjusted R-Square, e(r2_a)) nocon nor2 noobs label 
	
	reghdfe death  c.mean_max  c.sd_max c.TN95_max  c.TD95_max  c.annual_pre_365 $control , absorb(prov#year prov#month) cluster(gbcode)
	outreg2 using $table/TableS2/TableS2.xls, append se bracket dec(5) keep(death  c.mean_max  c.sd_max c.TN95_max  c.TD95_max  c.annual_pre_365) addtext(Province-by-Year Fixed Effect, "YES", Rrovince-by-Month Fixed Effect, "YES", Control variables, "YES") addstat(Obs., e(N), Adjusted R-Square, e(r2_a)) nocon nor2 noobs label 
	
	reghdfe death  c.mean_min  c.sd_min c.TN95_min  c.TD95_min  c.annual_pre_365 $control , absorb(prov#year prov#month) cluster(gbcode)
	outreg2 using $table/TableS2/TableS2.xls, append se bracket dec(5) keep(death  c.mean_min  c.sd_min c.TN95_min  c.TD95_min  c.annual_pre_365) addtext(Province-by-Year Fixed Effect, "YES", Rrovince-by-Month Fixed Effect, "YES", Control variables, "YES") addstat(Obs., e(N), Adjusted R-Square, e(r2_a)) nocon nor2 noobs label 
	
	
	reghdfe death  c.mean_adt  c.sd_adt c.TN95_adt  c.TD95_adt  c.annual_pre_365 $control , absorb(prov#year prov#month) cluster(gbcode)
	outreg2 using $table/TableS2/TableS2.xls, append se bracket dec(5) keep(death  c.mean_adt  c.sd_adt c.TN95_adt  c.TD95_adt  c.annual_pre_365) addtext(Province-by-Year Fixed Effect, "YES", Rrovince-by-Month Fixed Effect, "YES", Control variables, "YES") addstat(Obs., e(N), Adjusted R-Square, e(r2_a)) nocon nor2 noobs label 

	reghdfe death  c.mean_meanhi  c.sd_meanhi c.TN95_meanhi  c.TD95_meanhi  c.annual_pre_365 $control , absorb(prov#year prov#month) cluster(gbcode)
	outreg2 using $table/TableS2/TableS2.xls, append se bracket dec(5) keep(death  c.mean_meanhi  c.sd_meanhi c.TN95_meanhi  c.TD95_meanhi  c.annual_pre_365) addtext(Province-by-Year Fixed Effect, "YES", Rrovince-by-Month Fixed Effect, "YES", Control variables, "YES") addstat(Obs., e(N), Adjusted R-Square, e(r2_a)) nocon nor2 noobs label 
	
	reghdfe death  c.mean_maxhi  c.sd_maxhi c.TN95_maxhi  c.TD95_maxhi  c.annual_pre_365 $control , absorb(prov#year prov#month) cluster(gbcode)
	outreg2 using $table/TableS2/TableS2.xls, append se bracket dec(5) keep(death  c.mean_maxhi  c.sd_maxhi c.TN95_maxhi  c.TD95_maxhi  c.annual_pre_365) addtext(Province-by-Year Fixed Effect, "YES", Rrovince-by-Month Fixed Effect, "YES", Control variables, "YES") addstat(Obs., e(N), Adjusted R-Square, e(r2_a)) nocon nor2 noobs label 
	
	
	reghdfe death  c.mean_minhi  c.sd_minhi c.TN95_minhi  c.TD95_minhi  c.annual_pre_365 $control , absorb(prov#year prov#month) cluster(gbcode)
	outreg2 using $table/TableS2/TableS2.xls, append se bracket dec(5) keep(death  c.mean_minhi  c.sd_minhi c.TN95_minhi  c.TD95_minhi  c.annual_pre_365) addtext(Province-by-Year Fixed Effect, "YES", Rrovince-by-Month Fixed Effect, "YES", Control variables, "YES") addstat(Obs., e(N), Adjusted R-Square, e(r2_a)) nocon nor2 noobs label
	
	
	reghdfe death  c.mean_adthi  c.sd_adthi c.TN95_adthi  c.TD95_adthi  c.annual_pre_365 $control , absorb(prov#year prov#month) cluster(gbcode)
	outreg2 using $table/TableS2/TableS2.xls, append se bracket dec(5) keep(death  c.mean_adthi  c.sd_adthi c.TN95_adthi  c.TD95_adthi  c.annual_pre_365) addtext(Province-by-Year Fixed Effect, "YES", Rrovince-by-Month Fixed Effect, "YES", Control variables, "YES") addstat(Obs., e(N), Adjusted R-Square, e(r2_a)) nocon nor2 noobs label
	