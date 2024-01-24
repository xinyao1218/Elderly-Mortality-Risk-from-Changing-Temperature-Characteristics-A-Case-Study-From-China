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
* SF6: 
*
********************************************************************************

		* sf6-1
	
use "$data/main.dta", clear
	
	
	global control sex trueage g101 g1021 h3 d1 smoke drink exercise area f1 income  hypertension diabetes heartdisease stroke_cvd asthma tuberculosis cataract glaucoma cancer gastric_ulcer parkinson bedsore arthritis dementia a2 meat fish egg bean veg tea garl a51 vegeta fruit f41 chil  
	
	
	
	*regression
	reghdfe death c.TN90_adthi##c.mean_maxhi c.sd_meanhi c.TD90_adthi c.annual_pre_365 $control , absorb(prov#year prov#month) cluster(gbcode)
	
	
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
		replace conbx=conbx*100*4.270308
		replace upperx=upperx*100*4.270308
		replace lowerx=lowerx*100*4.270308

		
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
				 title("Annual mean EHF (T{sub:90})"" " , size(3.5)) ///
				 xsca(titlegap(2))  ///
				 ysca(titlegap(2))  ///
				 fysize(180) fxsize(200) ///
				 ysize(18) xsize(20) ///
				 scheme(s1mono) graphregion(fcolor(white) ilcolor(white) lcolor(white))

		 graph export "$figure/sf6/sf6_1.png", replace width(3000)



		 
********************************************************************************


		* sf6-2
	
use "$data/main.dta", clear
	
	
	global control sex trueage g101 g1021 h3 d1 smoke drink exercise area f1 income  hypertension diabetes heartdisease stroke_cvd asthma tuberculosis cataract glaucoma cancer gastric_ulcer parkinson bedsore arthritis dementia a2 meat fish egg bean veg tea garl a51 vegeta fruit f41 chil 
	
	
	
	*regression
	
	reghdfe death c.TN95_adthi##c.mean_maxhi c.sd_meanhi c.TD95_adthi c.annual_pre_365 $control , absorb(prov#year prov#month) cluster(gbcode)
	
	
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
				 yscale(range(0 24) alt axis(2))  ///   
				 xscale(noline)  ///
				 legend(off)  ///
				 xtitle("Annual mean temperature index (℃)" , size(3.5))  ///
				 ytitle("Marginal effect on mortality risk of older adults""(% points per 1-s.d. increase)"" " , axis(1) size(3.5))  ///
				 ytitle("Frequency distributions of observed""moderating variables (%)"" ", axis(2) orientation(rvertical) size(3.5))  ///
				 title("Annual mean EHF (T{sub:95})"" " , size(3.5)) ///
				 xsca(titlegap(2))  ///
				 ysca(titlegap(2))  ///
				 fysize(180) fxsize(200) ///
				 ysize(18) xsize(20) ///
				 scheme(s1mono) graphregion(fcolor(white) ilcolor(white) lcolor(white))

		 graph export "$figure/sf6/sf6_2.png", replace width(3000)



		 
********************************************************************************

		* sf6-3
	
use "$data/main.dta", clear
	
	
	global control sex trueage g101 g1021 h3 d1 smoke drink exercise area f1 income  hypertension diabetes heartdisease stroke_cvd asthma tuberculosis cataract glaucoma cancer gastric_ulcer parkinson bedsore arthritis dementia a2 meat fish egg bean veg tea garl a51 vegeta fruit f41 chil 
	
	
	
	*regression
	
	reghdfe death c.TN99_adthi##c.mean_maxhi c.sd_meanhi c.TD99_adthi c.annual_pre_365 $control , absorb(prov#year prov#month) cluster(gbcode)
	
	
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
		replace conbx=conbx*100*3.164947
		replace upperx=upperx*100*3.164947
		replace lowerx=lowerx*100*3.164947

		
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
				 title("Annual mean EHF (T{sub:99})"" " , size(3.5)) ///
				 xsca(titlegap(2))  ///
				 ysca(titlegap(2))  ///
				 fysize(180) fxsize(200) ///
				 ysize(18) xsize(20) ///
				 scheme(s1mono) graphregion(fcolor(white) ilcolor(white) lcolor(white))

		 graph export "$figure/sf6/sf6_3.png", replace width(3000)



		 
********************************************************************************

		* sf6-4
	
use "$data/main.dta", clear
	
	
	global control sex trueage g101 g1021 h3 d1 smoke drink exercise area f1 income  hypertension diabetes heartdisease stroke_cvd asthma tuberculosis cataract glaucoma cancer gastric_ulcer parkinson bedsore arthritis dementia a2 meat fish egg bean veg tea garl a51 vegeta fruit f41 chil  
	
	
	
	*regression
	
	reghdfe death c.TD90_adthi##c.mean_maxhi c.sd_meanhi c.TN90_adthi c.annual_pre_365 $control , absorb(prov#year prov#month) cluster(gbcode)
	
	
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
		
		sum TD90_adthi
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
		replace conbx=conbx*100*7.653615
		replace upperx=upperx*100*7.653615
		replace lowerx=lowerx*100*7.653615

		
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
				 title("Number of days with EHF>0 (T{sub:90})"" " , size(3.5)) ///
				 xsca(titlegap(2))  ///
				 ysca(titlegap(2))  ///
				 fysize(180) fxsize(200) ///
				 ysize(18) xsize(20) ///
				 scheme(s1mono) graphregion(fcolor(white) ilcolor(white) lcolor(white))

		 graph export "$figure/sf6/sf6_4.png", replace width(3000)



		 
********************************************************************************

		* sf6-5
	
use "$data/main.dta", clear
	
	
	global control sex trueage g101 g1021 h3 d1 smoke drink exercise area f1 income  hypertension diabetes heartdisease stroke_cvd asthma tuberculosis cataract glaucoma cancer gastric_ulcer parkinson bedsore arthritis dementia a2 meat fish egg bean veg tea garl a51 vegeta fruit f41 chil 
	
	
	
	*regression
	
	reghdfe death c.TD95_adthi##c.mean_maxhi c.sd_meanhi c.TN95_adthi c.annual_pre_365 $control , absorb(prov#year prov#month) cluster(gbcode)
	
	
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
		replace conbx=conbx*100*6.977581
		replace upperx=upperx*100*6.977581
		replace lowerx=lowerx*100*6.977581

		
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
				 title("Number of days with EHF>0 (T{sub:95})"" " , size(3.5)) ///
				 xsca(titlegap(2))  ///
				 ysca(titlegap(2))  ///
				 fysize(180) fxsize(200) ///
				 ysize(18) xsize(20) ///
				 scheme(s1mono) graphregion(fcolor(white) ilcolor(white) lcolor(white))

		 graph export "$figure/sf6/sf6_5.png", replace width(3000)



		 
********************************************************************************


		* sf6-6
	
use "$data/main.dta", clear
	
	
	global control sex trueage g101 g1021 h3 d1 smoke drink exercise area f1 income  hypertension diabetes heartdisease stroke_cvd asthma tuberculosis cataract glaucoma cancer gastric_ulcer parkinson bedsore arthritis dementia a2 meat fish egg bean veg tea garl a51 vegeta fruit f41 chil 
	
	
	
	*regression
	
	reghdfe death c.TD99_adthi##c.mean_maxhi c.sd_meanhi c.TN99_adthi c.annual_pre_365 $control , absorb(prov#year prov#month) cluster(gbcode)
	
	
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
		replace conbx=conbx*100*5.503181
		replace upperx=upperx*100*5.503181
		replace lowerx=lowerx*100*5.503181

		
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
				 title("Number of days with EHF>0 (T{sub:99})"" " , size(3.5)) ///
				 xsca(titlegap(2))  ///
				 ysca(titlegap(2))  ///
				 fysize(180) fxsize(200) ///
				 ysize(18) xsize(20) ///
				 scheme(s1mono) graphregion(fcolor(white) ilcolor(white) lcolor(white))

		 graph export "$figure/sf6/sf6_6.png", replace width(3000)


		