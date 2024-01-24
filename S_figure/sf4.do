*==============================================================================* 
* Project: Temperature and China Elderly Death          					   *
* Version:    									    				           *   
* Date:  				                                                       *
* Author: Xin Yao  					                                           *    
*==============================================================================*


* set directories 
clear all
set maxvar  30000
set more off



global dir "C:\Users\yaoxin\Desktop\Death_elderly_Temperature_China"
global data "$dir/data"
global table "$dir/table"
global figure "$dir/figure"

********************************************************************************
*
* SF4:
*
********************************************************************************

use "$data/main.dta", clear
	
	global control sex trueage g101 g1021 h3 d1 smoke drink exercise area f1 income  hypertension diabetes heartdisease stroke_cvd asthma tuberculosis cataract glaucoma cancer gastric_ulcer parkinson bedsore arthritis dementia a2 meat fish egg bean veg tea garl a51 vegeta fruit f41 chil
	

	*regression
	reghdfe death  c.mean_mean  c.sd_mean c.TN95_mean  c.TD95_mean  c.annual_pre_365 $control , absorb(prov#year prov#month) cluster(gbcode)
	parmest , saving($figure/sf4/sf4_mean.dta, replace)
	
	reghdfe death  c.mean_max  c.sd_max c.TN95_max  c.TD95_max  c.annual_pre_365 $control , absorb(prov#year prov#month) cluster(gbcode)
	parmest , saving($figure/sf4/sf4_max.dta, replace)
	
	reghdfe death  c.mean_min  c.sd_min c.TN95_min  c.TD95_min  c.annual_pre_365 $control , absorb(prov#year prov#month) cluster(gbcode)
	parmest , saving($figure/sf4/sf4_min.dta, replace)	
	
	reghdfe death  c.mean_adt  c.sd_adt c.TN95_adt  c.TD95_adt  c.annual_pre_365 $control , absorb(prov#year prov#month) cluster(gbcode)
	parmest , saving($figure/sf4/sf4_adt.dta, replace)	
	
	reghdfe death  c.mean_meanhi  c.sd_meanhi c.TN95_meanhi  c.TD95_meanhi  c.annual_pre_365 $control , absorb(prov#year prov#month) cluster(gbcode)
	parmest , saving($figure/sf4/sf4_meanhi.dta, replace)	
	
	reghdfe death  c.mean_maxhi  c.sd_maxhi c.TN95_maxhi  c.TD95_maxhi  c.annual_pre_365 $control , absorb(prov#year prov#month) cluster(gbcode)
	parmest , saving($figure/sf4/sf4_maxhi.dta, replace)	
	
	reghdfe death  c.mean_minhi  c.sd_minhi c.TN95_minhi  c.TD95_minhi  c.annual_pre_365 $control , absorb(prov#year prov#month) cluster(gbcode)
	parmest , saving($figure/sf4/sf4_minhi.dta, replace)

	reghdfe death  c.mean_adthi  c.sd_adthi c.TN95_adthi  c.TD95_adthi  c.annual_pre_365 $control , absorb(prov#year prov#month) cluster(gbcode)
	parmest , saving($figure/sf4/sf4_adthi.dta, replace)
	
********************************************************************************

	* sf4_1
	
		cd $figure/sf4
		openall, storefilename(fn)
		keep if parm=="mean_mean" | parm=="mean_max" | parm=="mean_min" | parm=="mean_adt" | parm=="mean_meanhi" | parm=="mean_maxhi" | parm=="mean_minhi" | parm=="mean_adthi"
		
		* group
		gen no=1
		replace no=2 if parm=="mean_max"
		replace no=3 if parm=="mean_min"
		replace no=4 if parm=="mean_adt"
		replace no=5 if parm=="mean_meanhi"
		replace no=6 if parm=="mean_maxhi"
		replace no=7 if parm=="mean_minhi"
		replace no=8 if parm=="mean_adthi"
		sort no 
		
		replace estimate=estimate*100*4.039344 if parm=="mean_mean"
		replace estimate=estimate*100*3.760127 if parm=="mean_max"
		replace estimate=estimate*100*4.518336 if parm=="mean_min"
		replace estimate=estimate*100*4.087901 if parm=="mean_adt"
		replace estimate=estimate*100*4.68573 if parm=="mean_meanhi"
		replace estimate=estimate*100*4.74924 if parm=="mean_maxhi"
		replace estimate=estimate*100*5.123317 if parm=="mean_minhi"
		replace estimate=estimate*100*4.7727 if parm=="mean_adthi"
		
		replace min95=min95*100*4.039344 if parm=="mean_mean"
		replace min95=min95*100*3.760127 if parm=="mean_max"
		replace min95=min95*100*4.518336 if parm=="mean_min"
		replace min95=min95*100*4.087901 if parm=="mean_adt"
		replace min95=min95*100*4.68573 if parm=="mean_meanhi"
		replace min95=min95*100*4.74924 if parm=="mean_maxhi"
		replace min95=min95*100*5.123317 if parm=="mean_minhi"
		replace min95=min95*100*4.7727 if parm=="mean_adthi"
		
		replace max95=max95*100*4.039344 if parm=="mean_mean"
		replace max95=max95*100*3.760127 if parm=="mean_max"
		replace max95=max95*100*4.518336 if parm=="mean_min"
		replace max95=max95*100*4.087901 if parm=="mean_adt"
		replace max95=max95*100*4.68573 if parm=="mean_meanhi"
		replace max95=max95*100*4.74924 if parm=="mean_maxhi"
		replace max95=max95*100*5.123317 if parm=="mean_minhi"
		replace max95=max95*100*4.7727 if parm=="mean_adthi"
		
		*adjust numerical scheme
		gen maker1 = estimate
		format %3.2f maker1
		gen x = 9- no 
		
		label define ylabel			///
				0 " "				///
				1 " Average daily temperature index " ///
				2 " Daily min temperature index " ///
				3 " Daily max temperature index " ///
				4 " Daily mean temperature index " ///
				5 " Average daily temperature " ///
				6 " Daily min temperature " ///
				7 " Daily max temperature " ///
				8 " Daily mean temperature " ///
			
			label values x ylabel
			
	     graph twoway   (rcap min95 max95 x if no==1, horizontal lcolor(red*1.2) lwidth(medthick))	///
						(rcap min95 max95 x if no==2, horizontal lcolor(orange*1.2) lwidth(medthick))	///
						(rcap min95 max95 x if no==3, horizontal lcolor(gold*1.2) lwidth(medthick))	///
						(rcap min95 max95 x if no==4, horizontal lcolor(lime*1.2) lwidth(medthick))	///
						(rcap min95 max95 x if no==5, horizontal lcolor(green*1.2) lwidth(medthick))	///
						(rcap min95 max95 x if no==6, horizontal lcolor(ebblue*1.2) lwidth(medthick))	///
						(rcap min95 max95 x if no==7, horizontal lcolor(blue*1.2) lwidth(medthick))	///
						(rcap min95 max95 x if no==8, horizontal lcolor(purple*1.2) lwidth(medthick))	///	
						(scatter x estimate if no==1, msymbol(O) mlcolor(red*1) mfcolor(red*0.6) msize(1.5) mlabel(maker1) mlabposition(5) mlabgap(*1.2) mlabsize(3)) ///
						(scatter x estimate if no==2, msymbol(O) mlcolor(orange*1) mfcolor(orange*0.6) msize(1.5) mlabel(maker1) mlabposition(5) mlabgap(*1.2) mlabsize(3)) ///
						(scatter x estimate if no==3, msymbol(O) mlcolor(gold*1) mfcolor(gold*0.6) msize(1.5) mlabel(maker1) mlabposition(5) mlabgap(*1.2) mlabsize(3)) ///
						(scatter x estimate if no==4, msymbol(O) mlcolor(lime*1) mfcolor(lime*0.6) msize(1.5) mlabel(maker1) mlabposition(5) mlabgap(*1.2) mlabsize(3)) ///
						(scatter x estimate if no==5, msymbol(O) mlcolor(green*1) mfcolor(green*0.6) msize(1.5) mlabel(maker1) mlabposition(5) mlabgap(*1.2) mlabsize(3)) ///
						(scatter x estimate if no==6, msymbol(O) mlcolor(ebblue*1) mfcolor(ebblue*0.6) msize(1.5) mlabel(maker1) mlabposition(5) mlabgap(*1.2) mlabsize(3)) ///
						(scatter x estimate if no==7, msymbol(O) mlcolor(blue*1) mfcolor(blue*0.6) msize(1.5) mlabel(maker1) mlabposition(5) mlabgap(*1.2) mlabsize(3)) ///
						(scatter x estimate if no==8, msymbol(O) mlcolor(purple*1) mfcolor(purple*0.6) msize(1.5) mlabel(maker1) mlabposition(5) mlabgap(*1.2) mlabsize(3)) ///
						,scheme(s1mono) ///
						legend(off) ///
						ysize(6) xsize(8) ///
						xline(0, lp(dash) lc(yellow*1.3) lwidth(thin)) ///
						ylabel(1/8, valuelabel labsize(3) angle(0) nogrid) ///
						yscale(range(0.2 8.5)) ///
						ytitle("") ///
						title("a. Annual mean temperature""index", pos(12) size(3.2) color(black)) ///
						fysize(100) fxsize(142) ///
						yline(1, lp(shortdash) lc(gray*0.7) lwidth(thin)) ///
						yline(2, lp(shortdash) lc(gray*0.7) lwidth(thin)) ///
						yline(3, lp(shortdash) lc(gray*0.7) lwidth(thin)) ///
						yline(4, lp(shortdash) lc(gray*0.7) lwidth(thin)) ///
						yline(5, lp(shortdash) lc(gray*0.7) lwidth(thin)) ///
						yline(6, lp(shortdash) lc(gray*0.7) lwidth(thin)) ///
						yline(7, lp(shortdash) lc(gray*0.7) lwidth(thin)) ///
						yline(8, lp(shortdash) lc(gray*0.7) lwidth(thin)) ///
						xlabel(-2 (2) 6, labsize(3.15) nogrid)  ///
						xtitle(" ",size(3.15) color(black)) 
		graph save "$figure/sf4/sf4_1", replace

********************************************************************************

	* sf4_2
	
		cd $figure/sf4
		openall, storefilename(fn)
		keep if parm=="sd_mean" | parm=="sd_max" | parm=="sd_min" | parm=="sd_adt" | parm=="sd_meanhi" | parm=="sd_maxhi" | parm=="sd_minhi" | parm=="sd_adthi"
		
		* group
		gen no=1
		replace no=2 if parm=="sd_max"
		replace no=3 if parm=="sd_min"
		replace no=4 if parm=="sd_adt"
		replace no=5 if parm=="sd_meanhi"
		replace no=6 if parm=="sd_maxhi"
		replace no=7 if parm=="sd_minhi"
		replace no=8 if parm=="sd_adthi"
		sort no 
		
		replace estimate=estimate*100*0.4294424 if parm=="sd_mean"
		replace estimate=estimate*100*0.5018827 if parm=="sd_max"
		replace estimate=estimate*100*0.4385632 if parm=="sd_min"
		replace estimate=estimate*100*0.4217333 if parm=="sd_adt"
		replace estimate=estimate*100*0.4553658 if parm=="sd_meanhi"
		replace estimate=estimate*100*0.5047112 if parm=="sd_maxhi"
		replace estimate=estimate*100*0.4907366 if parm=="sd_minhi"
		replace estimate=estimate*100*0.4468442 if parm=="sd_adthi"
		
		replace min95=min95*100*0.4294424 if parm=="sd_mean"
		replace min95=min95*100*0.5018827 if parm=="sd_max"
		replace min95=min95*100*0.4385632 if parm=="sd_min"
		replace min95=min95*100*0.4217333 if parm=="sd_adt"
		replace min95=min95*100*0.4553658 if parm=="sd_meanhi"
		replace min95=min95*100*0.5047112 if parm=="sd_maxhi"
		replace min95=min95*100*0.4907366 if parm=="sd_minhi"
		replace min95=min95*100*0.4468442 if parm=="sd_adthi"
		
		replace max95=max95*100*0.4294424 if parm=="sd_mean"
		replace max95=max95*100*0.5018827 if parm=="sd_max"
		replace max95=max95*100*0.4385632 if parm=="sd_min"
		replace max95=max95*100*0.4217333 if parm=="sd_adt"
		replace max95=max95*100*0.4553658 if parm=="sd_meanhi"
		replace max95=max95*100*0.5047112 if parm=="sd_maxhi"
		replace max95=max95*100*0.4907366 if parm=="sd_minhi"
		replace max95=max95*100*0.4468442 if parm=="sd_adthi"
		
		*adjust numerical scheme
		gen maker1 = estimate
		format %3.2f maker1
		gen x = 9- no 
		
			
	    graph twoway   (rcap min95 max95 x if no==1, horizontal lcolor(red*1.2) lwidth(medthick))	///
						(rcap min95 max95 x if no==2, horizontal lcolor(orange*1.2) lwidth(medthick))	///
						(rcap min95 max95 x if no==3, horizontal lcolor(gold*1.2) lwidth(medthick))	///
						(rcap min95 max95 x if no==4, horizontal lcolor(lime*1.2) lwidth(medthick))	///
						(rcap min95 max95 x if no==5, horizontal lcolor(green*1.2) lwidth(medthick))	///
						(rcap min95 max95 x if no==6, horizontal lcolor(ebblue*1.2) lwidth(medthick))	///
						(rcap min95 max95 x if no==7, horizontal lcolor(blue*1.2) lwidth(medthick))	///
						(rcap min95 max95 x if no==8, horizontal lcolor(purple*1.2) lwidth(medthick))	///	
						(scatter x estimate if no==1, msymbol(O) mlcolor(red*1) mfcolor(red*0.6) msize(1.5) mlabel(maker1) mlabposition(5) mlabgap(*1.2) mlabsize(3)) ///
						(scatter x estimate if no==2, msymbol(O) mlcolor(orange*1) mfcolor(orange*0.6) msize(1.5) mlabel(maker1) mlabposition(5) mlabgap(*1.2) mlabsize(3)) ///
						(scatter x estimate if no==3, msymbol(O) mlcolor(gold*1) mfcolor(gold*0.6) msize(1.5) mlabel(maker1) mlabposition(5) mlabgap(*1.2) mlabsize(3)) ///
						(scatter x estimate if no==4, msymbol(O) mlcolor(lime*1) mfcolor(lime*0.6) msize(1.5) mlabel(maker1) mlabposition(5) mlabgap(*1.2) mlabsize(3)) ///
						(scatter x estimate if no==5, msymbol(O) mlcolor(green*1) mfcolor(green*0.6) msize(1.5) mlabel(maker1) mlabposition(5) mlabgap(*1.2) mlabsize(3)) ///
						(scatter x estimate if no==6, msymbol(O) mlcolor(ebblue*1) mfcolor(ebblue*0.6) msize(1.5) mlabel(maker1) mlabposition(5) mlabgap(*1.2) mlabsize(3)) ///
						(scatter x estimate if no==7, msymbol(O) mlcolor(blue*1) mfcolor(blue*0.6) msize(1.5) mlabel(maker1) mlabposition(5) mlabgap(*1.2) mlabsize(3)) ///
						(scatter x estimate if no==8, msymbol(O) mlcolor(purple*1) mfcolor(purple*0.6) msize(1.5) mlabel(maker1) mlabposition(5) mlabgap(*1.2) mlabsize(3)) ///
						,scheme(s1mono) ///
						legend(off) ///
						ysize(6) xsize(5) ///
						xline(0, lp(dash) lc(yellow*1.3) lwidth(thin)) ///
						ylabel(1/8, nolabels noticks nogrid) ///
						yscale(range(0.2 8.5)) ///
						ytitle("") ///
						title("b. Day-to-day temperature""index variability", pos(12) size(3.2) color(black)) ///
						fysize(100) fxsize(65) ///
						yline(1, lp(shortdash) lc(gray*0.7) lwidth(thin)) ///
						yline(2, lp(shortdash) lc(gray*0.7) lwidth(thin)) ///
						yline(3, lp(shortdash) lc(gray*0.7) lwidth(thin)) ///
						yline(4, lp(shortdash) lc(gray*0.7) lwidth(thin)) ///
						yline(5, lp(shortdash) lc(gray*0.7) lwidth(thin)) ///
						yline(6, lp(shortdash) lc(gray*0.7) lwidth(thin)) ///
						yline(7, lp(shortdash) lc(gray*0.7) lwidth(thin)) ///
						yline(8, lp(shortdash) lc(gray*0.7) lwidth(thin)) ///
						xlabel(-2 (2) 6, labsize(3.15) nogrid)  ///
						xtitle(" ",size(3.15) color(black)) 
		graph save "$figure/sf4/sf4_2", replace

********************************************************************************

	* sf4_3
	
		cd $figure/sf4
		openall, storefilename(fn)
		keep if parm=="TN95_mean" | parm=="TN95_max" | parm=="TN95_min" | parm=="TN95_adt" | parm=="TN95_meanhi" | parm=="TN95_maxhi" | parm=="TN95_minhi" | parm=="TN95_adthi"
		
		* group
		gen no=1
		replace no=2 if parm=="TN95_max"
		replace no=3 if parm=="TN95_min"
		replace no=4 if parm=="TN95_adt"
		replace no=5 if parm=="TN95_meanhi"
		replace no=6 if parm=="TN95_maxhi"
		replace no=7 if parm=="TN95_minhi"
		replace no=8 if parm=="TN95_adthi"
		sort no 
		
		replace estimate=estimate*100*1.894491 if parm=="TN95_mean"
		replace estimate=estimate*100*3.151766 if parm=="TN95_max"
		replace estimate=estimate*100*1.586885 if parm=="TN95_min"
		replace estimate=estimate*100*1.798498 if parm=="TN95_adt"
		replace estimate=estimate*100*3.426954 if parm=="TN95_meanhi"
		replace estimate=estimate*100*7.090092 if parm=="TN95_maxhi"
		replace estimate=estimate*100*2.258864 if parm=="TN95_minhi"
		replace estimate=estimate*100*3.429071 if parm=="TN95_adthi"
		
		replace min95=min95*100*1.894491 if parm=="TN95_mean"
		replace min95=min95*100*3.151766 if parm=="TN95_max"
		replace min95=min95*100*1.586885 if parm=="TN95_min"
		replace min95=min95*100*1.798498 if parm=="TN95_adt"
		replace min95=min95*100*3.426954 if parm=="TN95_meanhi"
		replace min95=min95*100*7.090092 if parm=="TN95_maxhi"
		replace min95=min95*100*2.258864 if parm=="TN95_minhi"
		replace min95=min95*100*3.429071 if parm=="TN95_adthi"
		
		replace max95=max95*100*1.894491 if parm=="TN95_mean"
		replace max95=max95*100*3.151766 if parm=="TN95_max"
		replace max95=max95*100*1.586885 if parm=="TN95_min"
		replace max95=max95*100*1.798498 if parm=="TN95_adt"
		replace max95=max95*100*3.426954 if parm=="TN95_meanhi"
		replace max95=max95*100*7.090092 if parm=="TN95_maxhi"
		replace max95=max95*100*2.258864 if parm=="TN95_minhi"
		replace max95=max95*100*3.429071 if parm=="TN95_adthi"
		
		*adjust numerical scheme
		gen maker1 = estimate
		format %3.2f maker1
		gen x = 9- no 
		
			
	    graph twoway   (rcap min95 max95 x if no==1, horizontal lcolor(red*1.2) lwidth(medthick))	///
						(rcap min95 max95 x if no==2, horizontal lcolor(orange*1.2) lwidth(medthick))	///
						(rcap min95 max95 x if no==3, horizontal lcolor(gold*1.2) lwidth(medthick))	///
						(rcap min95 max95 x if no==4, horizontal lcolor(lime*1.2) lwidth(medthick))	///
						(rcap min95 max95 x if no==5, horizontal lcolor(green*1.2) lwidth(medthick))	///
						(rcap min95 max95 x if no==6, horizontal lcolor(ebblue*1.2) lwidth(medthick))	///
						(rcap min95 max95 x if no==7, horizontal lcolor(blue*1.2) lwidth(medthick))	///
						(rcap min95 max95 x if no==8, horizontal lcolor(purple*1.2) lwidth(medthick))	///	
						(scatter x estimate if no==1, msymbol(O) mlcolor(red*1) mfcolor(red*0.6) msize(1.5) mlabel(maker1) mlabposition(5) mlabgap(*1.2) mlabsize(3)) ///
						(scatter x estimate if no==2, msymbol(O) mlcolor(orange*1) mfcolor(orange*0.6) msize(1.5) mlabel(maker1) mlabposition(5) mlabgap(*1.2) mlabsize(3)) ///
						(scatter x estimate if no==3, msymbol(O) mlcolor(gold*1) mfcolor(gold*0.6) msize(1.5) mlabel(maker1) mlabposition(5) mlabgap(*1.2) mlabsize(3)) ///
						(scatter x estimate if no==4, msymbol(O) mlcolor(lime*1) mfcolor(lime*0.6) msize(1.5) mlabel(maker1) mlabposition(5) mlabgap(*1.2) mlabsize(3)) ///
						(scatter x estimate if no==5, msymbol(O) mlcolor(green*1) mfcolor(green*0.6) msize(1.5) mlabel(maker1) mlabposition(5) mlabgap(*1.2) mlabsize(3)) ///
						(scatter x estimate if no==6, msymbol(O) mlcolor(ebblue*1) mfcolor(ebblue*0.6) msize(1.5) mlabel(maker1) mlabposition(5) mlabgap(*1.2) mlabsize(3)) ///
						(scatter x estimate if no==7, msymbol(O) mlcolor(blue*1) mfcolor(blue*0.6) msize(1.5) mlabel(maker1) mlabposition(5) mlabgap(*1.2) mlabsize(3)) ///
						(scatter x estimate if no==8, msymbol(O) mlcolor(purple*1) mfcolor(purple*0.6) msize(1.5) mlabel(maker1) mlabposition(5) mlabgap(*1.2) mlabsize(3)) ///
						,scheme(s1mono) ///
						legend(off) ///
						ysize(6) xsize(5) ///
						xline(0, lp(dash) lc(yellow*1.3) lwidth(thin)) ///
						ylabel(1/8, nolabels noticks nogrid) ///
						yscale(range(0.2 8.5)) ///
						ytitle("") ///
						title("c. Annual mean EHF"" ", pos(12) size(3.2) color(black)) ///
						fysize(100) fxsize(65) ///
						yline(1, lp(shortdash) lc(gray*0.7) lwidth(thin)) ///
						yline(2, lp(shortdash) lc(gray*0.7) lwidth(thin)) ///
						yline(3, lp(shortdash) lc(gray*0.7) lwidth(thin)) ///
						yline(4, lp(shortdash) lc(gray*0.7) lwidth(thin)) ///
						yline(5, lp(shortdash) lc(gray*0.7) lwidth(thin)) ///
						yline(6, lp(shortdash) lc(gray*0.7) lwidth(thin)) ///
						yline(7, lp(shortdash) lc(gray*0.7) lwidth(thin)) ///
						yline(8, lp(shortdash) lc(gray*0.7) lwidth(thin)) ///
						xlabel(-2 (2) 6, labsize(3.15) nogrid)  ///
						xtitle(" ",size(3.15) color(black)) 
		graph save "$figure/sf4/sf4_3", replace

********************************************************************************

	* sf4_4
	
		cd $figure/sf4
		openall, storefilename(fn)
		keep if parm=="TD95_mean" | parm=="TD95_max" | parm=="TD95_min" | parm=="TD95_adt" | parm=="TD95_meanhi" | parm=="TD95_maxhi" | parm=="TD95_minhi" | parm=="TD95_adthi"
		
		* group
		gen no=1
		replace no=2 if parm=="TD95_max"
		replace no=3 if parm=="TD95_min"
		replace no=4 if parm=="TD95_adt"
		replace no=5 if parm=="TD95_meanhi"
		replace no=6 if parm=="TD95_maxhi"
		replace no=7 if parm=="TD95_minhi"
		replace no=8 if parm=="TD95_adthi"
		sort no 
		
		replace estimate=estimate*100*7.340765 if parm=="TD95_mean"
		replace estimate=estimate*100*7.266269 if parm=="TD95_max"
		replace estimate=estimate*100*7.370803 if parm=="TD95_min"
		replace estimate=estimate*100*7.342541 if parm=="TD95_adt"
		replace estimate=estimate*100*6.932517 if parm=="TD95_meanhi"
		replace estimate=estimate*100*6.466835 if parm=="TD95_maxhi"
		replace estimate=estimate*100*7.351274 if parm=="TD95_minhi"
		replace estimate=estimate*100*6.977581 if parm=="TD95_adthi"
		
		replace min95=min95*100*7.340765 if parm=="TD95_mean"
		replace min95=min95*100*7.266269 if parm=="TD95_max"
		replace min95=min95*100*7.370803 if parm=="TD95_min"
		replace min95=min95*100*7.342541 if parm=="TD95_adt"
		replace min95=min95*100*6.932517 if parm=="TD95_meanhi"
		replace min95=min95*100*6.466835 if parm=="TD95_maxhi"
		replace min95=min95*100*7.351274 if parm=="TD95_minhi"
		replace min95=min95*100*6.977581 if parm=="TD95_adthi"
		
		replace max95=max95*100*7.340765 if parm=="TD95_mean"
		replace max95=max95*100*7.266269 if parm=="TD95_max"
		replace max95=max95*100*7.370803 if parm=="TD95_min"
		replace max95=max95*100*7.342541 if parm=="TD95_adt"
		replace max95=max95*100*6.932517 if parm=="TD95_meanhi"
		replace max95=max95*100*6.466835 if parm=="TD95_maxhi"
		replace max95=max95*100*7.351274 if parm=="TD95_minhi"
		replace max95=max95*100*6.977581 if parm=="TD95_adthi"
		
		*adjust numerical scheme
		gen maker1 = estimate
		format %3.2f maker1
		gen x = 9- no 
		
			
	    graph twoway   (rcap min95 max95 x if no==1, horizontal lcolor(red*1.2) lwidth(medthick))	///
						(rcap min95 max95 x if no==2, horizontal lcolor(orange*1.2) lwidth(medthick))	///
						(rcap min95 max95 x if no==3, horizontal lcolor(gold*1.2) lwidth(medthick))	///
						(rcap min95 max95 x if no==4, horizontal lcolor(lime*1.2) lwidth(medthick))	///
						(rcap min95 max95 x if no==5, horizontal lcolor(green*1.2) lwidth(medthick))	///
						(rcap min95 max95 x if no==6, horizontal lcolor(ebblue*1.2) lwidth(medthick))	///
						(rcap min95 max95 x if no==7, horizontal lcolor(blue*1.2) lwidth(medthick))	///
						(rcap min95 max95 x if no==8, horizontal lcolor(purple*1.2) lwidth(medthick))	///	
						(scatter x estimate if no==1, msymbol(O) mlcolor(red*1) mfcolor(red*0.6) msize(1.5) mlabel(maker1) mlabposition(5) mlabgap(*1.2) mlabsize(3)) ///
						(scatter x estimate if no==2, msymbol(O) mlcolor(orange*1) mfcolor(orange*0.6) msize(1.5) mlabel(maker1) mlabposition(5) mlabgap(*1.2) mlabsize(3)) ///
						(scatter x estimate if no==3, msymbol(O) mlcolor(gold*1) mfcolor(gold*0.6) msize(1.5) mlabel(maker1) mlabposition(5) mlabgap(*1.2) mlabsize(3)) ///
						(scatter x estimate if no==4, msymbol(O) mlcolor(lime*1) mfcolor(lime*0.6) msize(1.5) mlabel(maker1) mlabposition(5) mlabgap(*1.2) mlabsize(3)) ///
						(scatter x estimate if no==5, msymbol(O) mlcolor(green*1) mfcolor(green*0.6) msize(1.5) mlabel(maker1) mlabposition(5) mlabgap(*1.2) mlabsize(3)) ///
						(scatter x estimate if no==6, msymbol(O) mlcolor(ebblue*1) mfcolor(ebblue*0.6) msize(1.5) mlabel(maker1) mlabposition(5) mlabgap(*1.2) mlabsize(3)) ///
						(scatter x estimate if no==7, msymbol(O) mlcolor(blue*1) mfcolor(blue*0.6) msize(1.5) mlabel(maker1) mlabposition(5) mlabgap(*1.2) mlabsize(3)) ///
						(scatter x estimate if no==8, msymbol(O) mlcolor(purple*1) mfcolor(purple*0.6) msize(1.5) mlabel(maker1) mlabposition(5) mlabgap(*1.2) mlabsize(3)) ///
						,scheme(s1mono) ///
						legend(off) ///
						ysize(6) xsize(5) ///
						xline(0, lp(dash) lc(yellow*1.3) lwidth(thin)) ///
						ylabel(1/8, nolabels noticks nogrid) ///
						yscale(range(0.2 8.5)) ///
						ytitle("") ///
						title("d. Number of days""with EHF>0", pos(12) size(3.2) color(black)) ///
						fysize(100) fxsize(65) ///
						yline(1, lp(shortdash) lc(gray*0.7) lwidth(thin)) ///
						yline(2, lp(shortdash) lc(gray*0.7) lwidth(thin)) ///
						yline(3, lp(shortdash) lc(gray*0.7) lwidth(thin)) ///
						yline(4, lp(shortdash) lc(gray*0.7) lwidth(thin)) ///
						yline(5, lp(shortdash) lc(gray*0.7) lwidth(thin)) ///
						yline(6, lp(shortdash) lc(gray*0.7) lwidth(thin)) ///
						yline(7, lp(shortdash) lc(gray*0.7) lwidth(thin)) ///
						yline(8, lp(shortdash) lc(gray*0.7) lwidth(thin)) ///
						xlabel(-2 (2) 6, labsize(3.15) nogrid)  ///
						xtitle(" ",size(3.15) color(black)) 
		graph save "$figure/sf4/sf4_4", replace

********************************************************************************


		graph combine "$figure/sf4/sf4_1" "$figure/sf4/sf4_2" "$figure/sf4/sf4_3""$figure/sf4/sf4_4", ///
				graphregion(fcolor(white) lcolor(white)) imargin(small) col(4) iscale(1) fysize(150) fxsize(240) xsize(15) ysize(6)  title("            		     	             Marginal effect on mortality risk of a 1-s.d. increase (% points)"" ", pos(6) size(3.2) color(black))
							

		graph export "$figure/sf4/sf4.png", replace width(10000)
		
