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
* Figure 5: Heterogeneity of the mortality effect of annual total EHF cross diet
*
********************************************************************************

use "$data/main.dta", clear
	
	global control sex trueage g101 g1021 h3 d1 smoke drink exercise area f1 income  hypertension diabetes heartdisease stroke_cvd asthma tuberculosis cataract glaucoma cancer gastric_ulcer parkinson bedsore arthritis dementia a2 meat fish egg bean veg tea garl a51 vegeta fruit f41 chil 
	 

	gen corn=d1
	replace corn=0 if corn==1|corn==3|corn==4|corn==5
	replace corn=1 if corn==2
		

		
	reghdfe death c.sd_meanhi#i.egg c.mean_maxhi c.TN95_adthi c.TD95_adthi c.annual_pre_365 $control , absorb(prov#year prov#month) cluster(gbcode)
	
	parmest , saving($figure/fig5/fig5_sd_egg.dta, replace)
	
	
	reghdfe death c.sd_meanhi#i.bean c.mean_maxhi c.TN95_adthi c.TD95_adthi c.annual_pre_365 $control , absorb(prov#year prov#month) cluster(gbcode)
	
	parmest , saving($figure/fig5/fig5_sd_bean.dta, replace)
	
		
	reghdfe death c.TN95_adthi#i.fish c.mean_maxhi c.sd_meanhi c.TD95_adthi c.annual_pre_365 $control , absorb(prov#year prov#month) cluster(gbcode)
	
	parmest , saving($figure/fig5/fig5_tn95_fish.dta, replace)
		
	reghdfe death c.TN95_adthi#i.egg c.mean_maxhi c.sd_meanhi c.TD95_adthi c.annual_pre_365 $control , absorb(prov#year prov#month) cluster(gbcode)
	
	parmest , saving($figure/fig5/fig5_tn95_egg.dta, replace)
	
********************************************************************************

	* figure5_1
	
		cd $figure/fig5
		openall, storefilename(fn)
		keep if fn=="fig5_sd_egg.dta"|fn=="fig5_sd_bean.dta"
		
		* group
		gen group = 1 if parm == "0b.bean#c.sd_meanhi" | parm == "1.bean#c.sd_meanhi" 
		replace group = 2 if parm == "0b.egg#c.sd_meanhi" | parm == "1.egg#c.sd_meanhi" 
		drop if group==.
		gen no=1 if parm == "0b.bean#c.sd_meanhi"
		replace no=2 if parm == "1.bean#c.sd_meanhi"
		replace no=3 if parm == "0b.egg#c.sd_meanhi"
		replace no=4 if parm == "1.egg#c.sd_meanhi"
		
		
		sort no 
		
		replace estimate=estimate*100*0.4470969 if no==1
		replace min95=min95*100*0.4470969 if no==1
		replace max95=max95*100*0.4470969 if no==1
		
		replace estimate=estimate*100*0.4625904 if no==2
		replace min95=min95*100*0.4625904 if no==2
		replace max95=max95*100*0.4625904 if no==2
		
		replace estimate=estimate*100*0.4519155 if no==3
		replace min95=min95*100*0.4519155 if no==3
		replace max95=max95*100*0.4519155 if no==3
		
		replace estimate=estimate*100*0.4542961 if no==4
		replace min95=min95*100*0.4542961 if no==4
		replace max95=max95*100*0.4542961 if no==4
		
		*adjust numerical scheme
		gen maker1 = estimate
		format %3.2f maker1
		gen x = 5- no 
		
		label define ylabel			///
				0 " "				///
				1 " Almost everyday " ///
				2 " {it:Frequency of eating eggs},Not everyday " ///
				3 " Almost everyday " ///
				4 " {it:Frequency of eating beans},Not everyday " ///

			
			label values x ylabel
			
	     graph twoway   (rcap min95 max95 x if group==1, horizontal lcolor(red*1.2) lwidth(medthick))	///
					 	(rcap min95 max95 x if group==2, horizontal lcolor(blue*1.2) lwidth(medthick)) ///
						(scatter x estimate if group==1, msymbol(O) mlcolor(red*1) mfcolor(red*0.6) msize(1.5) mlabel(maker1) mlabposition(5) mlabgap(*1.2) mlabsize(3)) ///
						(scatter x estimate if group==2, msymbol(O) mlcolor(blue*1) mfcolor(blue*0.6) msize(1.5) mlabel(maker1) mlabposition(5) mlabgap(*1.2) mlabsize(3)) ///
						,scheme(s1mono) ///
						legend(off) ///
						ysize(6) xsize(10) ///
						xline(0, lp(dash) lc(yellow*1.3) lwidth(thin)) ///
						ylabel(1/4, valuelabel labsize(3.2) angle(0) nogrid) ///
						yscale(range(0.2 4.5)) ///
						ytitle("") ///
						title("Day-to-day temperature index variability"" ", pos(12) size(4) color(black)) ///
						fysize(100) fxsize(140) ///
						yline(1, lp(shortdash) lc(gray*0.7) lwidth(thin)) ///
						yline(2, lp(shortdash) lc(gray*0.7) lwidth(thin)) ///
						yline(3, lp(shortdash) lc(gray*0.7) lwidth(thin)) ///
						yline(4, lp(shortdash) lc(gray*0.7) lwidth(thin)) ///
						xlabel(-2 (2) 6, labsize(3.5) nogrid)  ///
						xtitle(" " " Effect on mortality risk of a 1-s.d. increase (%points)",size(3.15) color(black)) 
		graph save "$figure/fig5/fig5_1", replace
		graph export "$figure/fig5/fig5_1.png", replace width(5000)
		
********************************************************************************

	* figure5_2
	
		cd $figure/fig5
		openall, storefilename(fn)
		keep if fn=="fig5_tn95_fish.dta"|fn=="fig5_tn95_egg.dta"
		
		* group
		gen group = 1 if parm == "0b.fish#c.TN95_adthi" | parm == "1.fish#c.TN95_adthi" 
		replace group = 2 if parm == "0b.egg#c.TN95_adthi" | parm == "1.egg#c.TN95_adthi" 
		drop if group==.
		gen no=1 if parm == "0b.fish#c.TN95_adthi"
		replace no=2 if parm == "1.fish#c.TN95_adthi"
		replace no=3 if parm == "0b.egg#c.TN95_adthi"
		replace no=4 if parm == "1.egg#c.TN95_adthi"
		
		
		sort no 
		
		replace estimate=estimate*100*3.438738 if no==1
		replace min95=min95*100*3.438738 if no==1
		replace max95=max95*100*3.438738 if no==1
		
		replace estimate=estimate*100*3.358066 if no==2
		replace min95=min95*100*3.358066 if no==2
		replace max95=max95*100*3.358066 if no==2
		
		replace estimate=estimate*100*3.630748 if no==3
		replace min95=min95*100*3.630748 if no==3
		replace max95=max95*100*3.630748 if no==3
		
		replace estimate=estimate*100*3.23069 if no==4
		replace min95=min95*100*3.23069 if no==4
		replace max95=max95*100*3.23069 if no==4
		
		*adjust numerical scheme
		gen maker1 = estimate
		format %3.2f maker1
		gen x = 5- no 
		
		label define ylabel			///
				0 " "				///
				1 " Almost everyday " ///
				2 " {it:Frequency of eating eggs},Not everyday " ///
				3 " Almost everyday " ///
				4 " {it:Frequency of eating fish},Not everyday " ///

			
			label values x ylabel
			
	     graph twoway   (rcap min95 max95 x if group==1, horizontal lcolor(green*1.2) lwidth(medthick))	///
						(rcap min95 max95 x if group==1, horizontal lcolor(green*1.2) lwidth(medthick) yaxis(2))	///
					 	(rcap min95 max95 x if group==2, horizontal lcolor(orange*1.2) lwidth(medthick)) ///
						(rcap min95 max95 x if group==2, horizontal lcolor(orange*1.2) lwidth(medthick) yaxis(2)) ///
						(scatter x estimate if group==1, msymbol(O) mlcolor(green*1) mfcolor(green*0.6) msize(1.5) mlabel(maker1) mlabposition(5) mlabgap(*1.2) mlabsize(3)) ///
						(scatter x estimate if group==1, msymbol(O) mlcolor(green*1) mfcolor(green*0.6) msize(1.5) mlabel(maker1) mlabposition(5) mlabgap(*1.2) mlabsize(3) yaxis(2)) ///
						(scatter x estimate if group==2, msymbol(O) mlcolor(orange*1) mfcolor(orange*0.6) msize(1.5) mlabel(maker1) mlabposition(5) mlabgap(*1.2) mlabsize(3)) ///
						(scatter x estimate if group==2, msymbol(O) mlcolor(orange*1) mfcolor(orange*0.6) msize(1.5) mlabel(maker1) mlabposition(5) mlabgap(*1.2) mlabsize(3) yaxis(2)) ///
						,scheme(s1mono) ///
						legend(off) ///
						ysize(6) xsize(10) ///
						xline(0, lp(dash) lc(yellow*1.3) lwidth(thin)) ///
						ylabel(none, axis(1)) ///
						ylabel(1/4, axis(2) valuelabel labsize(3.2) angle(0) nogrid) ///
						yscale(range(0.2 4.5) axis(1)) ///
						yscale(range(0.2 4.5) axis(2)) ///
						ytitle("", axis(1)) ///
						ytitle("", axis(2)) ///
						title("Annual mean EHF"" ", pos(12) size(4) color(black)) ///
						fysize(100) fxsize(140) ///
						yline(1, lp(shortdash) lc(gray*0.7) lwidth(thin)) ///
						yline(2, lp(shortdash) lc(gray*0.7) lwidth(thin)) ///
						yline(3, lp(shortdash) lc(gray*0.7) lwidth(thin)) ///
						yline(4, lp(shortdash) lc(gray*0.7) lwidth(thin)) ///
						xlabel(-2 (2) 6, labsize(3.5) nogrid)  ///
						xtitle(" " " Effect on mortality risk of a 1-s.d. increase (%points)",size(3.15) color(black)) 
		graph save "$figure/fig5/fig5_2", replace
		graph export "$figure/fig5/fig5_2.png", replace width(5000)
		