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
* SF 7: Robustness CHeck
*
********************************************************************************

	
	
	global control sex trueage g101 g1021 h3 d1 smoke drink exercise area f1 income  hypertension diabetes heartdisease stroke_cvd asthma tuberculosis cataract glaucoma cancer gastric_ulcer parkinson bedsore arthritis dementia a2 meat fish egg bean veg tea garl a51 vegeta fruit f41 chil 
	

	*regression 
	use "$data/main.dta", clear
	reghdfe death c.mean_maxhi c.sd_meanhi c.TN95_adthi c.TD95_adthi c.annual_pre_365 $control , absorb(prov#year prov#month) cluster(gbcode)
	parmest , saving($figure/sf7/sf7_reg.dta, replace)
		
		
	*Robustness_checks1
	use "$data/main.dta", clear
	gen pro=floor(gbcode/10000)
	bys death:tab pro
	drop if pro==51
	
	reghdfe death c.mean_maxhi c.sd_meanhi c.TN95_adthi c.TD95_adthi c.annual_pre_365 $control , absorb(prov#year prov#month) cluster(gbcode)
	parmest , saving($figure/sf7/sf7_rc1.dta, replace)
	
		
	*Robustness_checks2
	use "$data/main.dta", clear
	bys death:tab year
	drop if year==2006
	reghdfe death c.mean_maxhi c.sd_meanhi c.TN95_adthi c.TD95_adthi c.annual_pre_365 $control , absorb(prov#year prov#month) cluster(gbcode)
	parmest , saving($figure/sf7/sf7_rc2.dta, replace)
		
		
		
	*Robustness_checks3
	use "$data/main.dta", clear
	reghdfe death c.mean_maxhi c.sd_meanhi c.TN95_adthi c.TD95_adthi c.annual_pre_365 $control , absorb(prov#year prov#month prov#day) cluster(gbcode)
	parmest , saving($figure/sf7/sf7_rc3.dta, replace)
	
	
	*Robustness_checks4
	use "$data/main.dta", clear
	reghdfe death c.mean_maxhi c.sd_meanhi c.TN95_adthi c.TD95_adthi c.annual_pre_365 $control , absorb(prov year month) cluster(gbcode)
	parmest , saving($figure/sf7/sf7_rc4.dta, replace)
	
		
	*Robustness_checks5
	use "$data/main.dta", clear
	replace b11=. if b11>6
	replace b12=. if b12>6
	global control sex b11 b12 trueage g101 g1021 h3 d1 smoke drink exercise area f1 income  hypertension diabetes heartdisease stroke_cvd asthma tuberculosis cataract glaucoma cancer gastric_ulcer parkinson bedsore arthritis dementia a2 meat fish egg bean veg tea garl a51 vegeta fruit f41 chil
	reghdfe death c.mean_maxhi c.sd_meanhi c.TN95_adthi c.TD95_adthi c.annual_pre_365 $control , absorb(prov#year prov#month) cluster(gbcode)
	parmest , saving($figure/sf7/sf7_rc5.dta, replace)
	
	
		
	*Robustness_checks6
	global control sex trueage g101 g1021 h3 d1 smoke drink exercise area f1 income  hypertension diabetes heartdisease stroke_cvd asthma tuberculosis cataract glaucoma cancer gastric_ulcer parkinson bedsore arthritis dementia a2 meat fish egg bean veg tea garl a51 vegeta fruit f41 chil 
	
	
	use "$data/Robustness_test_ewembi.dta", clear
	reghdfe death c.mean_maxhi c.sd_meanhi c.TN95_adthi c.TD95_adthi c.annual_pre_365 $control , absorb(prov#year prov#month) cluster(gbcode)
	parmest , saving($figure/sf7/sf7_rc6.dta, replace)
	
********************************************************************************

	* sf7_1
		cd $figure/sf7
		openall, storefilename(fn)
		keep if parm == "mean_maxhi" 	
		
		* group
		gen group=1
		replace group=2 if fn=="sf7_rc1.dta"
		replace group=3 if fn=="sf7_rc2.dta"
		replace group=4 if fn=="sf7_rc3.dta"
		replace group=5 if fn=="sf7_rc4.dta"
		replace group=6 if fn=="sf7_rc5.dta"
		replace group=7 if fn=="sf7_rc6.dta"
		sort group
		
		replace estimate=estimate*100*4.74924 if group==1
		replace min95=min95*100*4.74924 if group==1
		replace max95=max95*100*4.74924 if group==1
		
		replace estimate=estimate*100*4.785317 if group==2
		replace min95=min95*100*4.785317 if group==2
		replace max95=max95*100*4.785317 if group==2
		
		replace estimate=estimate*100*4.751435 if group==3
		replace min95=min95*100*4.751435 if group==3
		replace max95=max95*100*4.751435 if group==3
		
		replace estimate=estimate*100*4.74924 if group==4
		replace min95=min95*100*4.74924 if group==4
		replace max95=max95*100*4.74924 if group==4
		
		replace estimate=estimate*100*4.74924 if group==5
		replace min95=min95*100*4.74924 if group==5
		replace max95=max95*100*4.74924 if group==5
		
		replace estimate=estimate*100*4.74924 if group==6
		replace min95=min95*100*4.74924 if group==6
		replace max95=max95*100*4.74924 if group==6
		
		replace estimate=estimate*100*4.548994 if group==7
		replace min95=min95*100*4.548994 if group==7
		replace max95=max95*100*4.548994 if group==7
		
		
		keep parm estimate min95 max95 group
		
		gen y = 8 - group
		
		label define ylabel			///
				7 "Baseline "				///
				6 "Drop elders in Guangxi " ///
				5 "Drop elders in 2006 " ///
				4 "More stringent fixed effects " ///
				3 "More relaxed fixed effects " ///
				2 "Add new control variables " ///
				1 "Temperature data:EWEMBI " ///
			
			label values y ylabel
			
		graph twoway (rspike min95 max95 y if y == 7, msymbol(circle) lcolor(blue*1) horizontal lwidth(med)) ///
			(scatter y estimate if y == 7, msymbol(circle) mcolor(blue*1) mlcolor(blue*1) mlwidth(thin) msize(1)) ///
			(rspike min95 max95 y if y <= 6, msymbol(circle) lcolor(cranberry*1) horizontal lwidth(med)) ///
			(scatter y estimate if y <= 6, msymbol(circle) mcolor(cranberry*1) mlcolor(cranberry*1) mlwidth(thin) msize(1)) ///
			, scheme(plotplain) ///
			xline(0) ///
			yline(1 2 3 4 5 6 7, lpattern(dot) lcolor(gs10) lwidth(vthin)) ///
			legend(off) ///
			ylabel(1 2 3 4 5 6 7, valuelabel nogrid labsize(4)) ///
			yscale(range(0.5 7.5)) ///
			ytitle("") xtitle("") ///
			title(" ""a. Annual mean temperature "" index ", pos(12) size(4)) ///
			xlabel(-2 (2) 6, nogrid labsize(4)) ///
			xscale(range(-2 6)) ///
			fxsize(215) fysize(140) xsize(10) ysize(2) ///
			xtitle(" " " ",size(4) color(black))
		graph save "$figure/sf7/sf7_1", replace

********************************************************************************

	* sf7_2
	
		cd $figure/sf7
		openall, storefilename(fn)
		keep if parm == "sd_meanhi" 	
		
		
		* group
		gen group=1
		replace group=2 if fn=="sf7_rc1.dta"
		replace group=3 if fn=="sf7_rc2.dta"
		replace group=4 if fn=="sf7_rc3.dta"
		replace group=5 if fn=="sf7_rc4.dta"
		replace group=6 if fn=="sf7_rc5.dta"
		replace group=7 if fn=="sf7_rc6.dta"
		sort group
		
		replace estimate=estimate*100*0.4553658 if group==1
		replace min95=min95*100*0.4553658 if group==1
		replace max95=max95*100*0.4553658 if group==1
		
		replace estimate=estimate*100*0.4339968 if group==2
		replace min95=min95*100*0.4339968 if group==2
		replace max95=max95*100*0.4339968 if group==2
		
		replace estimate=estimate*100*0.4548861 if group==3
		replace min95=min95*100*0.4548861 if group==3
		replace max95=max95*100*0.4548861 if group==3
		
		replace estimate=estimate*100*0.4553658 if group==4
		replace min95=min95*100*0.4553658 if group==4
		replace max95=max95*100*0.4553658 if group==4
		
		replace estimate=estimate*100*0.4553658 if group==5
		replace min95=min95*100*0.4553658 if group==5
		replace max95=max95*100*0.4553658 if group==5
		
		replace estimate=estimate*100*0.4553658 if group==6
		replace min95=min95*100*0.4553658 if group==6
		replace max95=max95*100*0.4553658 if group==6
		
		replace estimate=estimate*100*0.4678116 if group==7
		replace min95=min95*100*0.4678116 if group==7
		replace max95=max95*100*0.4678116 if group==7
		
		
		keep parm estimate min95 max95 group
		
		gen y = 8 - group
		
		
		
		graph twoway (rspike min95 max95 y if y == 7, msymbol(circle) lcolor(blue*1) horizontal lwidth(med)) ///
			(scatter y estimate if y == 7, msymbol(circle) mcolor(blue*1) mlcolor(blue*1) mlwidth(thin) msize(1)) ///
			(rspike min95 max95 y if y <= 6, msymbol(circle) lcolor(cranberry*1) horizontal lwidth(med)) ///
			(scatter y estimate if y <= 6, msymbol(circle) mcolor(cranberry*1) mlcolor(cranberry*1) mlwidth(thin) msize(1)) ///
			, scheme(plotplain) ///
			xline(0) ///
			yline(1 2 3 4 5 6 7, lpattern(dot) lcolor(gs10) lwidth(vthin)) ///
			legend(off) ///
			ylabel("", valuelabel) ///
			yscale(range(0.5 7.5)) ///
			ytitle("") xtitle("") ///
			title(" ""b. Day-to-day temperature "" index variability ", pos(12) size(4)) ///
			xlabel(-2 (2) 6, nogrid labsize(4)) ///
			fxsize(120) fysize(140) ///
			xtitle(" " " ",size(4) color(black))
		graph save "$figure/sf7/sf7_2", replace
		
********************************************************************************

	* sf7_3
	
		cd $figure/sf7
		openall, storefilename(fn)
		keep if parm == "TN95_adthi" 	
		
		* group
		gen group=1
		replace group=2 if fn=="sf7_rc1.dta"
		replace group=3 if fn=="sf7_rc2.dta"
		replace group=4 if fn=="sf7_rc3.dta"
		replace group=5 if fn=="sf7_rc4.dta"
		replace group=6 if fn=="sf7_rc5.dta"
		replace group=7 if fn=="sf7_rc6.dta"
		sort group
		keep parm estimate min95 max95 group
		
		replace estimate=estimate*100*3.429071 if group==1
		replace min95=min95*100*3.429071 if group==1
		replace max95=max95*100*3.429071 if group==1
		
		replace estimate=estimate*100*3.49455 if group==2
		replace min95=min95*100*3.49455 if group==2
		replace max95=max95*100*3.49455 if group==2
		
		replace estimate=estimate*100*3.44819 if group==3
		replace min95=min95*100*3.44819 if group==3
		replace max95=max95*100*3.44819 if group==3
		
		replace estimate=estimate*100*3.429071 if group==4
		replace min95=min95*100*3.429071 if group==4
		replace max95=max95*100*3.429071 if group==4
		
		replace estimate=estimate*100*3.429071 if group==5
		replace min95=min95*100*3.429071 if group==5
		replace max95=max95*100*3.429071 if group==5
		
		replace estimate=estimate*100*3.429071 if group==6
		replace min95=min95*100*3.429071 if group==6
		replace max95=max95*100*3.429071 if group==6
		
		replace estimate=estimate*100*2.680886 if group==7
		replace min95=min95*100*2.680886 if group==7
		replace max95=max95*100*2.680886 if group==7
		
		gen y = 8 - group
		
		
		
		graph twoway (rspike min95 max95 y if y == 7, msymbol(circle) lcolor(blue*1) horizontal lwidth(med)) ///
			(scatter y estimate if y == 7, msymbol(circle) mcolor(blue*1) mlcolor(blue*1) mlwidth(thin) msize(1)) ///
			(rspike min95 max95 y if y <= 6, msymbol(circle) lcolor(cranberry*1) horizontal lwidth(med)) ///
			(scatter y estimate if y <= 6, msymbol(circle) mcolor(cranberry*1) mlcolor(cranberry*1) mlwidth(thin) msize(1)) ///
			, scheme(plotplain) ///
			xline(0) ///
			yline(1 2 3 4 5 6 7, lpattern(dot) lcolor(gs10) lwidth(vthin)) ///
			legend(off) ///
			ylabel("", valuelabel) ///
			yscale(range(0.5 7.5)) ///
			ytitle("") xtitle("") ///
			title(" ""c. Annual mean EHF "" ", pos(12) size(4)) ///
			xlabel(-2 (2) 6, nogrid labsize(4)) ///
			fxsize(120) fysize(140) ///
			xtitle(" " " ",size(4) color(black))
		graph save "$figure/sf7/sf7_3", replace
		
********************************************************************************

	* sf7_4
	
		cd $figure/sf7
		openall, storefilename(fn)
		keep if parm == "TD95_adthi" 	
		

		* group
		gen group=1
		replace group=2 if fn=="sf7_rc1.dta"
		replace group=3 if fn=="sf7_rc2.dta"
		replace group=4 if fn=="sf7_rc3.dta"
		replace group=5 if fn=="sf7_rc4.dta"
		replace group=6 if fn=="sf7_rc5.dta"
		replace group=7 if fn=="sf7_rc6.dta"
		sort group
		keep parm estimate min95 max95 group
		
		replace estimate=estimate*100*6.977581 if group==1
		replace min95=min95*100*6.977581 if group==1
		replace max95=max95*100*6.977581 if group==1
		
		replace estimate=estimate*100*6.908154 if group==2
		replace min95=min95*100*6.908154 if group==2
		replace max95=max95*100*6.908154 if group==2
		
		replace estimate=estimate*100*6.970967 if group==3
		replace min95=min95*100*6.970967 if group==3
		replace max95=max95*100*6.970967 if group==3
		
		replace estimate=estimate*100*6.977581 if group==4
		replace min95=min95*100*6.977581 if group==4
		replace max95=max95*100*6.977581 if group==4
		
		replace estimate=estimate*100*6.977581 if group==5
		replace min95=min95*100*6.977581 if group==5
		replace max95=max95*100*6.977581 if group==5
		
		replace estimate=estimate*100*6.977581 if group==6
		replace min95=min95*100*6.977581 if group==6
		replace max95=max95*100*6.977581 if group==6
		
		replace estimate=estimate*100*5.587842 if group==7
		replace min95=min95*100*5.587842 if group==7
		replace max95=max95*100*5.587842 if group==7
		
		gen y = 8 - group
		

		graph twoway (rspike min95 max95 y if y == 7, msymbol(circle) lcolor(blue*1) horizontal lwidth(med)) ///
			(scatter y estimate if y == 7, msymbol(circle) mcolor(blue*1) mlcolor(blue*1) mlwidth(thin) msize(1)) ///
			(rspike min95 max95 y if y <= 6, msymbol(circle) lcolor(cranberry*1) horizontal lwidth(med)) ///
			(scatter y estimate if y <= 6, msymbol(circle) mcolor(cranberry*1) mlcolor(cranberry*1) mlwidth(thin) msize(1)) ///
			, scheme(plotplain) ///
			xline(0) ///
			yline(1 2 3 4 5 6 7, lpattern(dot) lcolor(gs10) lwidth(vthin)) ///
			legend(off) ///
			ylabel("", valuelabel) ///
			yscale(range(0.5 7.5)) ///
			ytitle("") xtitle("") ///
			title(" ""d. Number of days "" with EHF>0 ", pos(12) size(4)) ///
			xlabel(-2 (2) 6, nogrid labsize(4)) ///
			fxsize(120) fysize(140) ///
			xtitle(" " " ",size(4) color(black))
		graph save "$figure/sf7/sf7_4", replace
		
********************************************************************************
	
		graph combine "$figure/sf7/sf7_1" "$figure/sf7/sf7_2" "$figure/sf7/sf7_3" "$figure/sf7/sf7_4", ///
				graphregion(fcolor(white) lcolor(white)) imargin(small) col(4) iscale(0.6) xsize(20) ysize(10) title("            		     	             Marginal effect on mortality risk of a 1-s.d. increase (% points)"" ", pos(6) size(3.5) color(black))

				
				
		graph export "$figure/sf7/sf7.png", replace width(3000)
