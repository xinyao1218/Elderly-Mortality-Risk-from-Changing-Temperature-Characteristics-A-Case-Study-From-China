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
* Table S3: 
*
********************************************************************************

use "$data/main.dta", clear
	

	corr mean_mean mean_max mean_min mean_adt mean_meanhi mean_maxhi mean_minhi mean_adthi
	corr sd_mean sd_max sd_min sd_adt sd_meanhi sd_maxhi sd_minhi sd_adthi
	corr TN95_mean TN95_max TN95_min TN95_adt TN95_meanhi TN95_maxhi TN95_minhi TN95_adthi
	corr TD95_mean TD95_max TD95_min TD95_adt TD95_meanhi TD95_maxhi TD95_minhi TD95_adthi
