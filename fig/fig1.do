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
* Figure 1: Effects of four temperature measures on mortality risk of older adults
*
********************************************************************************


	* figure 1-1
	
use "$data/main.dta", clear
	
	
	global control sex trueage g101 g1021 h3 d1 smoke drink exercise area f1 income  hypertension diabetes heartdisease stroke_cvd asthma tuberculosis cataract glaucoma cancer gastric_ulcer parkinson bedsore arthritis dementia a2 meat fish egg bean veg tea garl a51 vegeta fruit f41 chil 
	
	
	
	*regression
	
	reghdfe death c.mean_maxhi c.sd_meanhi c.TN95_adthi c.TD95_adthi c.annual_pre_365 $control , absorb(prov#year prov#month) cluster(gbcode)
	parmest , saving($figure/fig1/fig1_all.dta, replace)
	
	* figure
		cd $figure/fig1
		openall, storefilename(fn)
		keep if (parm == "mean_maxhi" | parm == "sd_meanhi" | parm == "TN95_adthi" | parm == "TD95_adthi")
		replace estimate=estimate*100*4.74924 if parm == "mean_maxhi"
		replace estimate=estimate*100*0.4553658 if parm == "sd_meanhi"
		replace estimate=estimate*100*3.429071 if parm == "TN95_adthi"
		replace estimate=estimate*100*6.977581 if parm == "TD95_adthi"
		
		replace min95=min95*100*4.74924 if parm == "mean_maxhi"
		replace min95=min95*100*0.4553658 if parm == "sd_meanhi"
		replace min95=min95*100*3.429071 if parm == "TN95_adthi"
		replace min95=min95*100*6.977581 if parm == "TD95_adthi"
		
		replace max95=max95*100*4.74924 if parm == "mean_maxhi"
		replace max95=max95*100*0.4553658 if parm == "sd_meanhi"
		replace max95=max95*100*3.429071 if parm == "TN95_adthi"
		replace max95=max95*100*6.977581 if parm == "TD95_adthi"

		
		* group
		gen group = 1 if parm == "mean_maxhi"
		replace group = 2 if parm == "sd_meanhi"
		replace group = 3 if parm == "TN95_adthi"
		replace group = 4 if parm == "TD95_adthi"
		sort group
		
		*adjust numerical scheme
		gen y = 5 - _n			

		graph twoway (rcap min95 max95 y if y == 1, horizontal lcolor(gold*1.2) lwidth(0.4)) ///
					 (rcap min95 max95 y if y == 2, horizontal lcolor(green*1.2) lwidth(0.4)) ///
					 (rcap min95 max95 y if y == 3, horizontal lcolor(blue*1.2) lwidth(0.4)) ///
					 (rcap min95 max95 y if y == 4, horizontal lcolor(red*1.2) lwidth(0.4)) ///					 
					 (scatter y estimate if y == 1, msymbol(O) mlcolor(gold*1) mfcolor(gold*0.6) msize(1) ) ///
					 (scatter y estimate if y == 2, msymbol(O) mlcolor(green*1) mfcolor(green*0.6) msize(1)) ///
					 (scatter y estimate if y == 3, msymbol(O) mlcolor(blue*1) mfcolor(blue*0.6) msize(1) ) ///
					 (scatter y estimate if y == 4, msymbol(O) mlcolor(red*1) mfcolor(red*0.6) msize(1)) ///
				, scheme(plotplain) 	///	
				xline(0, lp(dash) lc(gs10*1.2) lwidth(thin)) ///
				legend(off) ///
				xlabel(-6 (2) 12, nogrid labsize(4)) ///
				xscale(range(-6 12)) ///
				ylabel("", valuelabel) ///
				yscale(range(0.5 5.2)) ///
				xtitle("") ///
				ytitle("") ///
				yline(4.5, lp(solid) lc(gs10*0.8) lwidth(0.1)) ///
				text(5 -3.2 "{bf:Temperature metrics}", place(c) size(4)) ///
				text(4 -3.2 "Annual mean temperature index", place(c) size(3.5)) ///
				text(3 -3.2 "Day-to-day temperature index variability", place(c) size(3.5)) ///
				text(2 -3.2 "Annual mean EHF", place(c) size(3.5)) ///
				text(1 -3.2 "Number of days with EHF>0", place(c) size(3.5)) ///
				text(5 4.6 "{bf:Marginal effects of a 1-s.d. increase (95% CI)}", place(c) size(4)) ///
				text(4 7 "2.10% (1.05%, 3.16%)", place(c) size(3.5)) ///
				text(3 7 "1.32% (0.48%, 2.16%)", place(c) size(3.5)) ///
				text(2 7 "1.79% (1.05%, 2.52%)", place(c) size(3.5)) ///
				text(1 7 "3.71% (2.80%, 4.61%)", place(c) size(3.5)) ///
				text(5 11 "{bf:P-value}", place(c) size(4)) ///
				text(4 11 "<0.01", place(c) size(3.5)) ///
				text(3 11 "<0.01", place(c) size(3.5)) ///
				text(2 11 "<0.01", place(c) size(3.5)) ///
				text(1 11 "<0.01", place(c) size(3.5)) ///
 				ysize(10) xsize(20) ///
				fysize(100) fxsize(200) 
				 
		
		 graph export "$figure/fig1/fig1_1.png", replace width(3000)
		 
********************************************************************************

	* figure 1-2
	
use "$data/main.dta", clear
	
	
	global control sex trueage g101 g1021 h3 d1 smoke drink exercise area f1 income  hypertension diabetes heartdisease stroke_cvd asthma tuberculosis cataract glaucoma cancer gastric_ulcer parkinson bedsore arthritis dementia a2 meat fish egg bean veg tea garl a51 vegeta fruit f41 chil 
	
	
	
	*regression
	
	reghdfe death c.mean_maxhi##c.mean_maxhi c.sd_meanhi c.TN95_adthi c.TD95_adthi c.annual_pre_365 $control , absorb(prov#year prov#month) cluster(gbcode)
	
	
		* Calculated marginal effect
		ereturn list
		matrix list e(V)
		matrix  b = e(b)
		matrix  V = e(V)
		scalar b1 = b[1,1]
		scalar b3 = b[1,2]
		scalar varb1  = V[1,1]
		scalar varb3  = V[2,2]
		scalar covb1b3= V[1,2]
		
		sum mean_maxhi
		scalar mean_365_mean = r(mean)
		dis "Margins：" b1+2*b3*mean_365_mean
		dis "Std.Err：" sqrt(varb1+varb3*4*(mean_365_mean^2)+4*covb1b3*mean_365_mean)
		
		set obs 305170
		generate MVZ=(_n+16639)/10000
		
		gen conbx=b1+2*b3*MVZ
		gen consx=sqrt(varb1+varb3*4*(MVZ^2)+4*covb1b3*MVZ)
		gen ax=1.96*consx
		gen upperx=conbx+ax
		gen lowerx=conbx-ax
		gen yline=0
		replace conbx=conbx*100*4.74924
		replace upperx=upperx*100*4.74924
		replace lowerx=lowerx*100*4.74924

		
		graph twoway hist mean_maxhi, width(0.5) percent color(eltblue*0.8) yaxis(2)        ///
            ||   rarea upperx lowerx MVZ,color(red*0.5) ///
			||   line conbx  MVZ,clpattern(solid) clwidth(medium) clcolor(black) yaxis(1)  ///
			||   line yline  MVZ,clpattern(dash) clwidth(medium)   clcolor(black)   ///
			||   ,    ///
				 xlabel(2 8 14 20 26 32 , nogrid labsize(3.5))  ///
				 ylabel(-15 -10 -5 0 5 10 15 , axis(1) nogrid labsize(3.5))  ///
				 ylabel(0 4 8 12 16 20 24,axis(2) angle(270))  ///
				 yscale(noline alt)  ///
				 yscale(range(0 24) alt axis(2))  ///    
				 xscale(noline)  ///
				 legend(off)  ///
				 xtitle("Annual mean temperature index (℃)" , size(3.5))  ///
				 ytitle("Marginal effect on mortality risk of older adults""(% points per 1-s.d. increase)"" " , axis(1) size(3.5))  ///
				 ytitle("Frequency distributions of observed""moderating variables (%)"" ", axis(2) orientation(rvertical) size(3.5))  ///
				 title("Annual mean temperature index "" " , size(3.5)) ///
				 xsca(titlegap(2))  ///
				 ysca(titlegap(2))  ///
				 fysize(180) fxsize(200) ///
				 ysize(18) xsize(20) ///
				 scheme(s1mono) graphregion(fcolor(white) ilcolor(white) lcolor(white))
		 graph save "$figure/fig1/fig1_2", replace
		 graph export "$figure/fig1/fig1_2.png", replace width(3000)
		 
********************************************************************************

	* figure 1-3
	
use "$data/main.dta", clear
	
	
	global control sex trueage g101 g1021 h3 d1 smoke drink exercise area f1 income  hypertension diabetes heartdisease stroke_cvd asthma tuberculosis cataract glaucoma cancer gastric_ulcer parkinson bedsore arthritis dementia a2 meat fish egg bean veg tea garl a51 vegeta fruit f41 chil 
	
	
	
	*regression
	
	reghdfe death c.TD95_adthi##c.TD95_adthi c.sd_meanhi c.TN95_adthi c.mean_maxhi c.annual_pre_365 $control , absorb(prov#year prov#month) cluster(gbcode)
	
		* Calculated marginal effect
		ereturn list
		matrix list e(V)
		matrix  b = e(b)
		matrix  V = e(V)
		scalar b1 = b[1,1]
		scalar b3 = b[1,2]
		scalar varb1  = V[1,1]
		scalar varb3  = V[2,2]
		scalar covb1b3= V[1,2]
		
		sum TD95_adthi
		scalar mean_td_365 = r(mean)
		dis "Margins：" 2*b3*mean_td_365
		dis "Std.Err：" sqrt(varb1+varb3*4*(mean_td_365^2)+4*covb1b3*mean_td_365)
		
		set obs 370001
		generate MVZ=(_n-1)/10000
		
		gen conbx=b1+2*b3*MVZ 
		gen consx=sqrt(varb1+varb3*4*(MVZ^2)+4*covb1b3*MVZ)
		gen ax=1.96*consx
		gen upperx=conbx+ax
		gen lowerx=conbx-ax
		gen yline=0
		replace conbx=conbx*100*6.977581
		replace upperx=upperx*100*6.977581
		replace lowerx=lowerx*100*6.977581

		
		graph twoway hist TD95_adthi, width(0.5) percent color(eltblue*0.8) yaxis(2)        ///
            ||   rarea upperx lowerx MVZ,color(red*0.5) ///
			||   line conbx  MVZ,clpattern(solid) clwidth(medium) clcolor(black) yaxis(1)  ///
			||   line yline  MVZ,clpattern(dash) clwidth(medium)   clcolor(black)   ///
			||   ,    ///
				 xlabel(0 7 14 21 28 35, nogrid labsize(3.5))  ///
				 ylabel(-15 -10 -5 0 5 10 15 , axis(1) nogrid labsize(3.5))  ///
				 ylabel(0 4 8 12 16 20 24,axis(2) angle(270))  ///
				 yscale(noline alt)  ///
				 yscale(range(0 24) alt axis(2))  ///    
				 xscale(noline)  ///
				 legend(off)  ///
				 xtitle("Number of days with EHF>0 (days)" , size(3.5))  ///
				 ytitle("Marginal effect on mortality risk of older adults""(% points per 1-s.d. increase)"" " , axis(1) size(3.5))  ///
				 ytitle("Frequency distributions of observed""moderating variables (%)"" ", axis(2) orientation(rvertical) size(3.5))  ///
				 title("Number of days with EHF>0 "" " , size(3.5)) ///
				 xsca(titlegap(2))  ///
				 ysca(titlegap(2))  ///
				 fysize(180) fxsize(200) ///
				 ysize(18) xsize(20) ///
				 scheme(s1mono) graphregion(fcolor(white) ilcolor(white) lcolor(white))
		 graph save "$figure/fig1/fig1_3", replace
		 graph export "$figure/fig1/fig1_3.png", replace width(3000)
		 
		 
		 
********************************************************************************

		* figure 1-4
	
use "$data/main.dta", clear
	
	
	global control sex trueage g101 g1021 h3 d1 smoke drink exercise area f1 income  hypertension diabetes heartdisease stroke_cvd asthma tuberculosis cataract glaucoma cancer gastric_ulcer parkinson bedsore arthritis dementia a2 meat fish egg bean veg tea garl a51 vegeta fruit f41 chil 
	
	
	
	*regression

	reghdfe death c.TN95_adthi##c.mean_maxhi c.sd_meanhi  c.mean_maxhi c.TD95_adthi c.annual_pre_365 $control , absorb(prov#year prov#month) cluster(gbcode)
	
		* Calculated marginal effect
		ereturn list
		matrix list e(V)
		matrix  b = e(b)
		matrix  V = e(V)
		scalar b1 = b[1,1]
		scalar b3 = b[1,3]
		scalar varb1  = V[1,1]
		scalar varb3  = V[3,3]
		scalar covb1b3= V[1,3]
		
		sum mean_maxhi
		scalar mean_365_mean = r(mean)
		dis "Margins：" b1+b3*mean_365_mean
		dis "Std.Err：" sqrt(varb1+varb3*(mean_365_mean^2)+2*covb1b3*mean_365_mean)
		
		set obs 305170
		generate MVZ=(_n+16639)/10000
		
		gen conbx=b1+b3*MVZ
		gen consx=sqrt(varb1+varb3*(MVZ^2)+2*covb1b3*MVZ)
		gen ax=1.96*consx
		gen upperx=conbx+ax
		gen lowerx=conbx-ax
		gen yline=0
		replace conbx=conbx*100*3.429071
		replace upperx=upperx*100*3.429071
		replace lowerx=lowerx*100*3.429071

		
		graph twoway hist mean_maxhi, width(0.5) percent color(eltblue*0.8) yaxis(2)        ///
            ||   rarea upperx lowerx MVZ,color(red*0.5) ///
			||   line conbx  MVZ,clpattern(solid) clwidth(medium) clcolor(black) yaxis(1)  ///
			||   line yline  MVZ,clpattern(dash) clwidth(medium)   clcolor(black)   ///
			||   ,    ///
				 xlabel(2 8 14 20 26 32 , nogrid labsize(3.5))  ///
				 ylabel(-15 -10 -5 0 5 10 15 , axis(1) nogrid labsize(3.5))  ///
				 ylabel(0 4 8 12 16 20 24,axis(2) angle(270))  ///
				 yscale(noline alt)  ///
				 yscale(range(0 18) alt axis(2))  ///    
				 xscale(noline)  ///
				 legend(off)  ///
				 xtitle("Annual mean temperature index (℃)" , size(3.5))  ///
				 ytitle("Marginal effect on mortality risk of older adults""(% points per 1-s.d. increase)"" " , axis(1) size(3.5))  ///
				 ytitle("Frequency distributions of observed""moderating variables (%)"" ", axis(2) orientation(rvertical) size(3.5))  ///
				 title("Annual mean EHF "" " , size(3.5)) ///
				 xsca(titlegap(2))  ///
				 ysca(titlegap(2))  ///
				 fysize(180) fxsize(200) ///
				 ysize(18) xsize(20) ///
				 scheme(s1mono) graphregion(fcolor(white) ilcolor(white) lcolor(white))
		 graph save "$figure/fig1/fig1_4", replace
		 graph export "$figure/fig1/fig1_4.png", replace width(3000)
		 
		 
********************************************************************************
