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
* SF5: 
*
********************************************************************************


use "$data/main.dta", clear
	
	global control sex trueage g101 g1021 h3 d1 smoke drink exercise area f1 income  hypertension diabetes heartdisease stroke_cvd asthma tuberculosis cataract glaucoma cancer gastric_ulcer parkinson bedsore arthritis dementia a2 meat fish egg bean veg tea garl a51 vegeta fruit f41 chil 

	*regression
	reghdfe death c.mean_maxhi c.sd_meanhi c.TN90_adthi c.TD90_adthi c.annual_pre_365 $control , absorb(prov#year prov#month) cluster(gbcode)
	parmest , saving($figure/sf5/sf5_t90.dta, replace)
	
	reghdfe death c.mean_maxhi c.sd_meanhi c.TN95_adthi c.TD95_adthi c.annual_pre_365 $control , absorb(prov#year prov#month) cluster(gbcode)
	parmest , saving($figure/sf5/sf5_t95.dta, replace)
	
	reghdfe death c.mean_maxhi c.sd_meanhi c.TN99_adthi c.TD99_adthi c.annual_pre_365 $control , absorb(prov#year prov#month) cluster(gbcode)
	parmest , saving($figure/sf5/sf5_t99.dta, replace)


********************************************************************************

	* sf5-1
	
		cd $figure/sf5
		openall, storefilename(fn)
		keep if parm=="TN90_adthi" | parm=="TN95_adthi" | parm=="TN99_adthi"
		
		* group
		gen no=1
		replace no=2 if parm=="TN95_adthi"
		replace no=3 if parm=="TN99_adthi"
		sort no 

		
		replace estimate=estimate*100*4.270308 if parm=="TN90_adthi"
		replace estimate=estimate*100*3.429071 if parm=="TN95_adthi"
		replace estimate=estimate*100*3.164947 if parm=="TN99_adthi"
		
		replace min95=min95*100*4.270308 if parm=="TN90_adthi"
		replace min95=min95*100*3.429071 if parm=="TN95_adthi"
		replace min95=min95*100*3.164947 if parm=="TN99_adthi"
		
		replace max95=max95*100*4.270308 if parm=="TN90_adthi"
		replace max95=max95*100*3.429071 if parm=="TN95_adthi"
		replace max95=max95*100*3.164947 if parm=="TN99_adthi"
		
		*adjust numerical scheme
		gen maker1 = estimate
		format %3.2f maker1
		gen x = 4- no 
		
		label define ylabel			///
				0 " "				///
				1 " T{sub:99} " ///
				2 " T{sub:95} " ///
				3 " T{sub:90} " ///

			
			label values x ylabel
		
			
	     graph twoway   (rcap min95 max95 x if no==1, horizontal lcolor(red*1.2) lwidth(medthick))	///
						(rcap min95 max95 x if no==2, horizontal lcolor(orange_red*1.2) lwidth(medthick))	///
						(rcap min95 max95 x if no==3, horizontal lcolor(orange*1.2) lwidth(medthick))	///
						(scatter x estimate if no==1, msymbol(O) mlcolor(red*1) mfcolor(red*0.6) msize(1.5) mlabel(maker1) mlabposition(5) mlabgap(*1.2) mlabsize(3)) ///
						(scatter x estimate if no==2, msymbol(O) mlcolor(orange_red*1) mfcolor(orange_red*0.6) msize(1.5) mlabel(maker1) mlabposition(5) mlabgap(*1.2) mlabsize(3)) ///
						(scatter x estimate if no==3, msymbol(O) mlcolor(orange*1) mfcolor(orange*0.6) msize(1.5) mlabel(maker1) mlabposition(5) mlabgap(*1.2) mlabsize(3)) ///
						,scheme(s1mono) ///
						legend(off) ///
						xline(0, lp(dash) lc(yellow*1.3) lwidth(thin)) ///
						ylabel(1/3, valuelabel labsize(3.2) angle(0) nogrid) ///
						yscale(range(0.2 3.5)) ///
						ytitle("") ///
						title("Annual mean EHF"" ", pos(12) size(4) color(black)) ///
						fysize(90) fxsize(150) ///
						ysize(4.5) xsize(7.5) ///
						yline(1, lp(shortdash) lc(gray*0.7) lwidth(thin)) ///
						yline(2, lp(shortdash) lc(gray*0.7) lwidth(thin)) ///
						yline(3, lp(shortdash) lc(gray*0.7) lwidth(thin)) ///
						xlabel(-2 (2) 6, labsize(3.5) nogrid)  ///
						xtitle(" ""Marginal effect on mortality risk of older adults (% points per 1-s.d. increase)",size(3.5) color(black)) 
						
		graph export "$figure/sf5/sf5_1.png", replace width(3000)
		
********************************************************************************


	* sf5-2
	
		cd $figure/sf5
		openall, storefilename(fn)
		keep if parm=="TD90_adthi" | parm=="TD95_adthi" | parm=="TD99_adthi"
		
		* group
		gen no=1
		replace no=2 if parm=="TD95_adthi"
		replace no=3 if parm=="TD99_adthi"
		sort no 

		
		replace estimate=estimate*100*7.653615 if parm=="TD90_adthi"
		replace min95=min95*100*7.653615 if parm=="TD90_adthi"
		replace max95=max95*100*7.653615 if parm=="TD90_adthi"
		
		replace estimate=estimate*100*6.977581 if parm=="TD95_adthi"
		replace min95=min95*100*6.977581 if parm=="TD95_adthi"
		replace max95=max95*100*6.977581 if parm=="TD95_adthi"
		
		replace estimate=estimate*100*5.503181 if parm=="TD99_adthi"
		replace min95=min95*100*5.503181 if parm=="TD99_adthi"
		replace max95=max95*100*5.503181 if parm=="TD99_adthi"
		
		*adjust numerical scheme
		gen maker1 = estimate
		format %3.2f maker1
		gen x = 4- no 
		
		label define ylabel			///
				0 " "				///
				1 " T{sub:99} " ///
				2 " T{sub:95} " ///
				3 " T{sub:90} " ///

			
			label values x ylabel
		
			
	     graph twoway   (rcap min95 max95 x if no==1, horizontal lcolor(red*1.2) lwidth(medthick))	///
						(rcap min95 max95 x if no==2, horizontal lcolor(orange_red*1.2) lwidth(medthick))	///
						(rcap min95 max95 x if no==3, horizontal lcolor(orange*1.2) lwidth(medthick))	///
						(scatter x estimate if no==1, msymbol(O) mlcolor(red*1) mfcolor(red*0.6) msize(1.5) mlabel(maker1) mlabposition(5) mlabgap(*1.2) mlabsize(3)) ///
						(scatter x estimate if no==2, msymbol(O) mlcolor(orange_red*1) mfcolor(orange_red*0.6) msize(1.5) mlabel(maker1) mlabposition(5) mlabgap(*1.2) mlabsize(3)) ///
						(scatter x estimate if no==3, msymbol(O) mlcolor(orange*1) mfcolor(orange*0.6) msize(1.5) mlabel(maker1) mlabposition(5) mlabgap(*1.2) mlabsize(3)) ///
						,scheme(s1mono) ///
						legend(off) ///
						xline(0, lp(dash) lc(yellow*1.3) lwidth(thin)) ///
						ylabel(1/3, valuelabel labsize(3.2) angle(0) nogrid) ///
						yscale(range(0.2 3.5)) ///
						ytitle("") ///
						title("Number of days with EHF>0"" ", pos(12) size(4) color(black)) ///
						fysize(90) fxsize(150) ///
						ysize(4.5) xsize(7.5) ///
						yline(1, lp(shortdash) lc(gray*0.7) lwidth(thin)) ///
						yline(2, lp(shortdash) lc(gray*0.7) lwidth(thin)) ///
						yline(3, lp(shortdash) lc(gray*0.7) lwidth(thin)) ///
						xlabel(-2 (2) 6, labsize(3.5) nogrid)  ///
						xtitle(" ""Marginal effect on mortality risk of older adults (% points per 1-s.d. increase)",size(3.5) color(black)) 
						
		graph export "$figure/sf5/sf5_2.png", replace width(3000)
		
********************************************************************************


* sf5-3
	
use "$data/main.dta", clear
	
	global control sex trueage g101 g1021 h3 d1 smoke drink exercise area f1 income  hypertension diabetes heartdisease stroke_cvd asthma tuberculosis cataract glaucoma cancer gastric_ulcer parkinson bedsore arthritis dementia a2 meat fish egg bean veg tea garl a51 vegeta fruit f41 chil 

	*regression

	reghdfe death c.TN90_adthi##c.TN90_adthi c.mean_maxhi c.sd_meanhi  c.TD90_adthi c.annual_pre_365 $control , absorb(prov#year prov#month) cluster(gbcode)


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
		
		sum TN90_adthi

		
		set obs 405886
		generate MVZ=(_n+4176)/10000
		
		gen conbx=b1+2*b3*MVZ 
		gen consx=sqrt(varb1+varb3*4*(MVZ^2)+4*covb1b3*MVZ)
		gen ax=1.96*consx
		gen upperx=conbx+ax
		gen lowerx=conbx-ax
		gen yline=0
		replace conbx=conbx*100*4.270308
		replace upperx=upperx*100*4.270308
		replace lowerx=lowerx*100*4.270308

		
		graph twoway hist TN90_adthi, width(0.5) percent color(eltblue*0.8) yaxis(2)        ///
            ||   rarea upperx lowerx MVZ,color(red*0.5) ///
			||   line conbx  MVZ,clpattern(solid) clwidth(medium) clcolor(black) yaxis(1)  ///
			||   line yline  MVZ,clpattern(dash) clwidth(medium)   clcolor(black)   ///
			||   ,    ///
				 xlabel(0 8 16 24 32 40, nogrid labsize(3.5))  ///
				 ylabel(-15 -10 -5 0 5 10 15, axis(1) nogrid labsize(3.5))  ///
				 ylabel(0 4 8 12 16 20 24,axis(2) angle(270))  ///
				 yscale(noline alt)  ///
				 yscale(range(0 24) alt axis(2))  ///    
				 xscale(noline)  ///
				 legend(off)  ///
				 xtitle("Annual mean EHF (℃²)" , size(3.5))  ///
				 ytitle("Marginal effect on mortality risk of older adults""(% points per 1-s.d. increase)"" " , axis(1) size(3.5))  ///
				 ytitle("Frequency distributions of observed""moderating variables (%)"" ", axis(2) orientation(rvertical) size(3.5))  ///
				 title("Annual mean EHF (T{sub:90})"" " , size(3.5)) ///
				 xsca(titlegap(2))  ///
				 ysca(titlegap(2))  ///
				 fysize(180) fxsize(200) ///
				 ysize(4.5) xsize(5) ///
				 scheme(s1mono) graphregion(fcolor(white) ilcolor(white) lcolor(white))

		 graph export "$figure/sf5/sf5_3.png", replace width(3000)
		 
********************************************************************************


	* sf 2-4
	
use "$data/main.dta", clear
	
	global control sex trueage g101 g1021 h3 d1 smoke drink exercise area f1 income  hypertension diabetes heartdisease stroke_cvd asthma tuberculosis cataract glaucoma cancer gastric_ulcer parkinson bedsore arthritis dementia a2 meat fish egg bean veg tea garl a51 vegeta fruit f41 chil

	*regression
	reghdfe death c.TN95_adthi##c.TN95_adthi c.mean_maxhi c.sd_meanhi  c.TD95_adthi c.annual_pre_365 $control , absorb(prov#year prov#month) cluster(gbcode)


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
		
		sum TN95_adthi
		
		set obs 272765
		generate MVZ=(_n-1)/10000
		
		gen conbx=b1+2*b3*MVZ 
		gen consx=sqrt(varb1+varb3*4*(MVZ^2)+4*covb1b3*MVZ)
		gen ax=1.96*consx
		gen upperx=conbx+ax
		gen lowerx=conbx-ax
		gen yline=0
		replace conbx=conbx*100*3.429071
		replace upperx=upperx*100*3.429071
		replace lowerx=lowerx*100*3.429071

		
		graph twoway hist TN95_adthi, width(0.5) percent color(eltblue*0.8) yaxis(2)        ///
            ||   rarea upperx lowerx MVZ,color(red*0.5) ///
			||   line conbx  MVZ,clpattern(solid) clwidth(medium) clcolor(black) yaxis(1)  ///
			||   line yline  MVZ,clpattern(dash) clwidth(medium)   clcolor(black)   ///
			||   ,    ///
				 xlabel(0 5 10 15 20 25, nogrid labsize(3.5))  ///
				 ylabel(-15 -10 -5 0 5 10 15 , axis(1) nogrid labsize(3.5))  ///
				 ylabel(0 4 8 12 16 20 24,axis(2) angle(270))  ///
				 yscale(noline alt)  ///
				 yscale(range(0 24) alt axis(2))  ///    
				 xscale(noline)  ///
				 legend(off)  ///
				 xtitle("Annual mean EHF (℃²)" , size(3.5))  ///
				 ytitle("Marginal effect on mortality risk of older adults""(% points per 1-s.d. increase)"" " , axis(1) size(3.5))  ///
				 ytitle("Frequency distributions of observed""moderating variables (%)"" ", axis(2) orientation(rvertical) size(3.5))  ///
				 title("Annual mean EHF (T{sub:95})"" " , size(3.5)) ///
				 xsca(titlegap(2))  ///
				 ysca(titlegap(2))  ///
				 fysize(180) fxsize(200) ///
				 ysize(4.5) xsize(5) ///
				 scheme(s1mono) graphregion(fcolor(white) ilcolor(white) lcolor(white))

		 graph export "$figure/sf5/sf5_4.png", replace width(3000)
	
	
********************************************************************************

	* sf5-5
	
use "$data/main.dta", clear
	
	global control sex trueage g101 g1021 h3 d1 smoke drink exercise area f1 income  hypertension diabetes heartdisease stroke_cvd asthma tuberculosis cataract glaucoma cancer gastric_ulcer parkinson bedsore arthritis dementia a2 meat fish egg bean veg tea garl a51 vegeta fruit f41 chil

	*regression
	reghdfe death c.TN99_adthi##c.TN99_adthi c.mean_maxhi c.sd_meanhi  c.TD99_adthi c.annual_pre_365 $control , absorb(prov#year prov#month) cluster(gbcode)


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
		
		sum TN99_adthi
		
		set obs 258703
		generate MVZ=(_n-1)/10000
		
		gen conbx=b1+2*b3*MVZ 
		gen consx=sqrt(varb1+varb3*4*(MVZ^2)+4*covb1b3*MVZ)
		gen ax=1.96*consx
		gen upperx=conbx+ax
		gen lowerx=conbx-ax
		gen yline=0
		replace conbx=conbx*100*3.164947
		replace upperx=upperx*100*3.164947
		replace lowerx=lowerx*100*3.164947

		
		graph twoway hist TN99_adthi, width(0.5) percent color(eltblue*0.8) yaxis(2)        ///
            ||   rarea upperx lowerx MVZ,color(red*0.5) ///
			||   line conbx  MVZ,clpattern(solid) clwidth(medium) clcolor(black) yaxis(1)  ///
			||   line yline  MVZ,clpattern(dash) clwidth(medium)   clcolor(black)   ///
			||   ,    ///
				 xlabel(0 5 10 15 20 25, nogrid labsize(3.5))  ///
				 ylabel(-15 -10 -5 0 5 10 15 , axis(1) nogrid labsize(3.5))  ///
				 ylabel(0 5 10 15 20 25 30,axis(2) angle(270))  ///
				 yscale(noline alt)  ///
				 yscale(range(0 30) alt axis(2))  ///    
				 xscale(noline)  ///
				 legend(off)  ///
				 xtitle("Annual mean EHF (℃²)" , size(3.5))  ///
				 ytitle("Marginal effect on mortality risk of older adults""(% points per 1-s.d. increase)"" " , axis(1) size(3.5))  ///
				 ytitle("Frequency distributions of observed""moderating variables (%)"" ", axis(2) orientation(rvertical) size(3.5))  ///
				 title("Annual mean EHF (T{sub:99})"" " , size(3.5)) ///
				 xsca(titlegap(2))  ///
				 ysca(titlegap(2))  ///
				 fysize(180) fxsize(200) ///
				 ysize(4.5) xsize(5) ///
				 scheme(s1mono) graphregion(fcolor(white) ilcolor(white) lcolor(white))
				 

		 graph export "$figure/sf5/sf5_5.png", replace width(3000)
		 	
	
	
********************************************************************************


	* sf5-6
	
use "$data/main.dta", clear
	
	global control sex trueage g101 g1021 h3 d1 smoke drink exercise area f1 income  hypertension diabetes heartdisease stroke_cvd asthma tuberculosis cataract glaucoma cancer gastric_ulcer parkinson bedsore arthritis dementia a2 meat fish egg bean veg tea garl a51 vegeta fruit f41 chil

	*regression
	reghdfe death c.TD90_adthi##c.TD90_adthi c.mean_maxhi c.sd_meanhi  c.TN90_adthi c.annual_pre_365 $control , absorb(prov#year prov#month) cluster(gbcode)


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
		
		sum TD90_adthi
		
		set obs 54001
		generate MVZ=(_n+3999)/1000
		
		gen conbx=b1+2*b3*MVZ 
		gen consx=sqrt(varb1+varb3*4*(MVZ^2)+4*covb1b3*MVZ)
		gen ax=1.96*consx
		gen upperx=conbx+ax
		gen lowerx=conbx-ax
		gen yline=0
		replace conbx=conbx*100*7.653615
		replace upperx=upperx*100*7.653615
		replace lowerx=lowerx*100*7.653615

		
		graph twoway hist TD90_adthi, width(0.5) percent color(eltblue*0.8) yaxis(2)        ///
            ||   rarea upperx lowerx MVZ,color(red*0.5) ///
			||   line conbx  MVZ,clpattern(solid) clwidth(medium) clcolor(black) yaxis(1)  ///
			||   line yline  MVZ,clpattern(dash) clwidth(medium)   clcolor(black)   ///
			||   ,    ///
				 xlabel(5 15 25 35 45 55 , nogrid labsize(3.5))  ///
				 ylabel(-15 -10 -5 0 5 10 15 , axis(1) nogrid labsize(3.5))  ///
				 ylabel(0 4 8 12 16 20 24,axis(2) angle(270))  ///
				 yscale(noline alt)  ///
				 yscale(range(0 24) alt axis(2))  ///    
				 xscale(noline)  ///
				 legend(off)  ///
				 xtitle("Number of days with EHF>0 (days)" , size(3.5))  ///
				 ytitle("Marginal effect on mortality risk of older adults""(% points per 1-s.d. increase)"" " , axis(1) size(3.5))  ///
				 ytitle("Frequency distributions of observed""moderating variables (%)"" ", axis(2) orientation(rvertical) size(3.5))  ///
				 title("Number of days with EHF>0 (T{sub:90})"" " , size(3.5)) ///
				 xsca(titlegap(2))  ///
				 ysca(titlegap(2))  ///
				 fysize(180) fxsize(200) ///
				 ysize(4.5) xsize(5) ///
				 scheme(s1mono) graphregion(fcolor(white) ilcolor(white) lcolor(white))
				 

		 graph export "$figure/sf5/sf5_6.png", replace width(3000)
		 

********************************************************************************


	* sf 2-7
	
use "$data/main.dta", clear
	
	global control sex trueage g101 g1021 h3 d1 smoke drink exercise area f1 income  hypertension diabetes heartdisease stroke_cvd asthma tuberculosis cataract glaucoma cancer gastric_ulcer parkinson bedsore arthritis dementia a2 meat fish egg bean veg tea garl a51 vegeta fruit f41 chil

	*regression
	reghdfe death c.TD95_adthi##c.TD95_adthi c.mean_maxhi c.sd_meanhi  c.TN95_adthi c.annual_pre_365 $control , absorb(prov#year prov#month) cluster(gbcode)


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
		
		set obs 74001
		generate MVZ=(_n-1)/2000
		
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
				 title("Number of days with EHF>0 (T{sub:95})"" " , size(3.5)) ///
				 xsca(titlegap(2))  ///
				 ysca(titlegap(2))  ///
				 fysize(180) fxsize(200) ///
				 ysize(4.5) xsize(5) ///
				 scheme(s1mono) graphregion(fcolor(white) ilcolor(white) lcolor(white))
				 

		 graph export "$figure/sf5/sf5_7.png", replace width(3000)
		 
********************************************************************************


	* sf5-8
	
use "$data/main.dta", clear
	
	global control sex trueage g101 g1021 h3 d1 smoke drink exercise area f1 income  hypertension diabetes heartdisease stroke_cvd asthma tuberculosis cataract glaucoma cancer gastric_ulcer parkinson bedsore arthritis dementia a2 meat fish egg bean veg tea garl a51 vegeta fruit f41 chil

	*regression
	reghdfe death c.TD99_adthi##c.TD99_adthi c.mean_maxhi c.sd_meanhi  c.TN99_adthi c.annual_pre_365 $control , absorb(prov#year prov#month) cluster(gbcode)

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
		
		sum TD99_adthi
		
		set obs 62001
		generate MVZ=(_n-1)/2000
		
		gen conbx=b1+2*b3*MVZ 
		gen consx=sqrt(varb1+varb3*4*(MVZ^2)+4*covb1b3*MVZ)
		gen ax=1.96*consx
		gen upperx=conbx+ax
		gen lowerx=conbx-ax
		gen yline=0
		replace conbx=conbx*100*5.503181
		replace upperx=upperx*100*5.503181
		replace lowerx=lowerx*100*5.503181

		
		graph twoway hist TD99_adthi, width(0.5) percent color(eltblue*0.8) yaxis(2)        ///
            ||   rarea upperx lowerx MVZ,color(red*0.5) ///
			||   line conbx  MVZ,clpattern(solid) clwidth(medium) clcolor(black) yaxis(1)  ///
			||   line yline  MVZ,clpattern(dash) clwidth(medium)   clcolor(black)   ///
			||   ,    ///
				 xlabel(0 6 12 18 24 30, nogrid labsize(3.5))  ///
				 ylabel(-15 -10 -5 0 5 10 15 , axis(1) nogrid labsize(3.5))  ///
				 ylabel(0 4 8 12 16 20 24,axis(2) angle(270))  ///
				 yscale(noline alt)  ///
				 yscale(range(0 24) alt axis(2))  ///    
				 xscale(noline)  ///
				 legend(off)  ///
				 xtitle("Number of days with EHF>0 (days)" , size(3.5))  ///
				 ytitle("Marginal effect on mortality risk of older adults""(% points per 1-s.d. increase)"" " , axis(1) size(3.5))  ///
				 ytitle("Frequency distributions of observed""moderating variables (%)"" ", axis(2) orientation(rvertical) size(3.5))  ///
				 title("Number of days with EHF>0 (T{sub:99})"" " , size(3.5)) ///
				 xsca(titlegap(2))  ///
				 ysca(titlegap(2))  ///
				 fysize(180) fxsize(200) ///
				 ysize(4.5) xsize(5) ///
				 scheme(s1mono) graphregion(fcolor(white) ilcolor(white) lcolor(white))
				 

		 graph export "$figure/sf5/sf5_8.png", replace width(3000)
		 
********************************************************************************

		