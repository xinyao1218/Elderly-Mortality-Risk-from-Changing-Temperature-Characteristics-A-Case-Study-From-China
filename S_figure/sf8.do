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
* sf8: Individual characteristics heterogeneity on mortality risk of older adults to changes in temperature
*
********************************************************************************

use "$data/main.dta", clear

	
	
	*regression_sex
	global control sex trueage g101 g1021 h3 d1 smoke drink exercise area f1 income  hypertension diabetes heartdisease stroke_cvd asthma tuberculosis cataract glaucoma cancer gastric_ulcer parkinson bedsore arthritis dementia a2 meat fish egg bean veg tea garl a51 vegeta fruit f41 chil 

	reghdfe death c.mean_maxhi##c.mean_maxhi#i.sex c.sd_meanhi c.TN95_adthi c.TD95_adthi c.annual_pre_365 $control , absorb(prov#year prov#month) cluster(gbcode)
	
	sum mean_maxhi
	global Min: dis %4.0f r(min)
	global Max: dis %4.0f r(max)
	global Grid = ($Max-$Min)/100
	
    margins sex, dydx(mean_maxhi) at(mean_maxhi=($Max($Grid)$Min)) post
	parmest , saving($figure/sf8/sf8_mean_sex.dta, replace)
	
	
	reghdfe death c.mean_maxhi c.sd_meanhi c.TN95_adthi c.TD95_adthi##c.TD95_adthi#i.sex c.annual_pre_365 $control , absorb(prov#year prov#month) cluster(gbcode)

	sum TD95_adthi
	global Min: dis %4.0f r(min)
	global Max: dis %4.0f r(max)
	global Grid = ($Max-$Min)/100
	
    margins sex, dydx(TD95_adthi) at(TD95_adthi=($Max($Grid)$Min)) post
	parmest , saving($figure/sf8/sf8_td95_sex.dta, replace)
	
	
	*regression_age

	
	gen group_age=1
	replace group_age=2 if(trueage>=75&trueage<85)
	replace group_age=3 if(trueage>=85&trueage<95)
	replace group_age=4 if(trueage>=95)
	replace group_age=. if trueage==.
	replace group_age=. if trueage<65
	
	
	reghdfe death c.mean_maxhi##c.mean_maxhi#i.group_age c.sd_meanhi c.TN95_adthi c.TD95_adthi c.annual_pre_365 $control , absorb(prov#year prov#month) cluster(gbcode)
	
	sum mean_maxhi
	global Min: dis %4.0f r(min)
	global Max: dis %4.0f r(max)
	global Grid = ($Max-$Min)/100
	
    margins group_age, dydx(mean_maxhi) at(mean_maxhi=($Max($Grid)$Min)) post
	parmest , saving($figure/sf8/sf8_mean_age.dta, replace)
	
	

	reghdfe death c.mean_maxhi c.sd_meanhi c.TN95_adthi c.TD95_adthi##c.TD95_adthi#i.group_age c.annual_pre_365 i.group_age $control , absorb(prov#year prov#month) cluster(gbcode)

	sum TD95_adthi
	global Min: dis %4.0f r(min)
	global Max: dis %4.0f r(max)
	global Grid = ($Max-$Min)/100
	
    margins group_age, dydx(TD95_adthi) at(TD95_adthi=($Max($Grid)$Min)) post
	parmest , saving($figure/sf8/sf8_td95_age.dta, replace)
	
	*regression_BMI
	
use "$data/main.dta", clear
	
	
	gen BMI=g101/((g1021/100)*(g1021/100))
	replace BMI=0 if BMI<24
	replace BMI=2 if BMI>=28
	replace BMI=1 if BMI>=24

	reghdfe death c.mean_maxhi##c.mean_maxhi#i.BMI c.sd_meanhi c.TN95_adthi c.TD95_adthi c.annual_pre_365 $control , absorb(prov#year prov#month) cluster(gbcode)
	
	sum mean_maxhi
	global Min: dis %4.0f r(min)
	global Max: dis %4.0f r(max)
	global Grid = ($Max-$Min)/100
	
    margins BMI, dydx(mean_maxhi) at(mean_maxhi=($Max($Grid)$Min)) post
	parmest , saving($figure/sf8/sf8_mean_BMI.dta, replace)
	
	

	reghdfe death c.mean_maxhi c.sd_meanhi c.TN95_adthi c.TD95_adthi##c.TD95_adthi#i.BMI c.annual_pre_365 $control , absorb(prov#year prov#month) cluster(gbcode)

	sum TD95_adthi
	global Min: dis %4.0f r(min)
	global Max: dis %4.0f r(max)
	global Grid = ($Max-$Min)/100
	
    margins BMI, dydx(TD95_adthi) at(TD95_adthi=($Max($Grid)$Min)) post
	parmest , saving($figure/sf8/sf8_td95_BMI.dta, replace)
	
********************************************************************************

	* sf8_1
	
		cd $figure/sf8
		openall, storefilename(fn)
		keep if fn=="sf8_mean_sex.dta"
		split parm, p("#")
		split parm1, p(".")
		gen no=real(parm11)
		replace no=(102-no)*0.3+1.7
		gen group=0 if parm2=="0.sex"
		replace group=1 if parm2=="1.sex"
		gen key=_n
		sort key
		save "$figure/sf8/temp.dta",replace
		use "$data/main.dta", clear
		gen key=_n
		sort key
		merge key using "$figure/sf8/temp.dta"
		gen yline=0
		replace estimate=estimate*100*4.677362 if parm2=="0.sex"
		replace max95=max95*100*4.677362 if parm2=="0.sex"
		replace min95=min95*100*4.677362 if parm2=="0.sex"
		replace estimate=estimate*100*4.838326 if parm2=="1.sex"
		replace max95=max95*100*4.838326 if parm2=="1.sex"
		replace min95=min95*100*4.838326 if parm2=="1.sex"
		
		
		graph twoway hist mean_maxhi if sex==0, width(0.5) percent color(ebblue*0.8%60) yaxis(2)        ///
			||   hist mean_maxhi if sex==1, width(0.5) percent color(orange_red*0.6%60) yaxis(2)       ///
            ||   rarea max95 min95 no if group==0,color(ebblue*0.8%60) ///
			||   rarea max95 min95 no if group==1,color(orange_red*0.6%60) ///
			||   line estimate  no if group==0,clpattern(solid) clwidth(medium) clcolor(ebblue*1.1) yaxis(1)  ///
			||   line estimate  no if group==1,clpattern(solid) clwidth(medium) clcolor(orange_red*0.9) yaxis(1)  ///
			||   line yline  no,clpattern(dash) clwidth(medium)   clcolor(black)   ///
			||   ,    ///
				 xlabel(2 8 14 20 26 32, nogrid labsize(3.5))  ///
				 ylabel(-15 -10 -5 0 5 10 15 , axis(1) nogrid labsize(3.5))  ///
				 ylabel(0 4 8 12 16 20 24,axis(2) angle(270))  ///
				 yscale(noline alt)  ///
				 yscale(range(0 24) alt axis(2))  ///    
				 xscale(noline)  ///
				 legend(order(5 6) label(5 "Sex:Male") label(6 "Sex:Female")  ring(0) pos(12) rowgap(0.5) cols(1) size(3))  ///
				 xtitle("Annual mean temperature index (℃)" , size(3.5))  ///
				 ytitle("Marginal effect on mortality risk of older adults""(% points per 1-s.d. increase)"" " , axis(1) size(3.5))  ///
				 ytitle("Frequency distributions of observed""moderating variables (%)"" ", axis(2) orientation(rvertical) size(3.5))  ///
				 title("Annual mean temperature index"" " , size(3.5)) ///
				 xsca(titlegap(2))  ///
				 ysca(titlegap(2))  ///
				 fysize(180) fxsize(200) ///
				 ysize(18) xsize(20) ///
				 scheme(s1mono) graphregion(fcolor(white) ilcolor(white) lcolor(white))
				 
		 graph save "$figure/sf8/sf8_1", replace
		 graph export "$figure/sf8/sf8_1.png", replace width(3000)
		 erase "$figure/sf8/temp.dta"
		 
********************************************************************************

	* sf8_2
	
		cd $figure/sf8
		openall, storefilename(fn)
		keep if fn=="sf8_td95_sex.dta"
		split parm, p("#")
		split parm1, p(".")
		gen no=real(parm11)
		replace no=(102-no)*0.37-0.37
		gen group=0 if parm2=="0.sex"
		replace group=1 if parm2=="1.sex"
		gen key=_n
		sort key
		save "$figure/sf8/temp.dta",replace
		use "$data/main.dta", clear
		gen key=_n
		sort key
		merge key using "$figure/sf8/temp.dta"
		gen yline=0
		replace estimate=estimate*100*6.952793 if parm2=="0.sex"
		replace max95=max95*100*6.952793 if parm2=="0.sex"
		replace min95=min95*100*6.952793 if parm2=="0.sex"
		replace estimate=estimate*100*6.996572 if parm2=="1.sex"
		replace max95=max95*100*6.996572 if parm2=="1.sex"
		replace min95=min95*100*6.996572 if parm2=="1.sex"
		
		graph twoway hist TD95_adthi if sex==0, width(0.5) percent color(ebblue*0.8%60) yaxis(2)        ///
			||   hist TD95_adthi if sex==1, width(0.5) percent color(orange_red*0.6%60) yaxis(2)       ///
            ||   rarea max95 min95 no if group==0,color(ebblue*0.8%60) ///
			||   rarea max95 min95 no if group==1,color(orange_red*0.6%60) ///
			||   line estimate  no if group==0,clpattern(solid) clwidth(medium) clcolor(ebblue*1.1) yaxis(1)  ///
			||   line estimate  no if group==1,clpattern(solid) clwidth(medium) clcolor(orange_red*0.9) yaxis(1)  ///
			||   line yline  no,clpattern(dash) clwidth(medium)   clcolor(black)   ///
			||   ,    ///
				 xlabel(0 7 14 21 28 35, nogrid labsize(3.5))  ///
				 ylabel(-15 -10 -5 0 5 10 15 , axis(1) nogrid labsize(3.5))  ///
				 ylabel(0 4 8 12 16 20 24,axis(2) angle(270))  ///
				 yscale(noline alt)  ///
				 yscale(range(0 24) alt axis(2))  ///    
				 xscale(noline)  ///
				 legend(order(5 6) label(5 "Sex:Male") label(6 "Sex:Female")  ring(0) pos(12) rowgap(0.5) cols(1) size(3))  ///
				 xtitle("Number of days with EHF>0 (days)" , size(3.5))  ///
				 ytitle("Marginal effect on mortality risk of older adults""(% points per 1-s.d. increase)"" " , axis(1) size(3.5))  ///
				 ytitle("Frequency distributions of observed""moderating variables (%)"" ", axis(2) orientation(rvertical) size(3.5))  ///
				 title("Number of days with EHF>0 "" " , size(3.5)) ///
				 xsca(titlegap(2))  ///
				 ysca(titlegap(2))  ///
				 fysize(180) fxsize(200) ///
				 ysize(18) xsize(20) ///
				 scheme(s1mono) graphregion(fcolor(white) ilcolor(white) lcolor(white))
				 
		 graph save "$figure/sf8/sf8_2", replace
		 graph export "$figure/sf8/sf8_2.png", replace width(3000)
		 erase "$figure/sf8/temp.dta"
		 
********************************************************************************

	* sf8_3
	
		cd $figure/sf8
		openall, storefilename(fn)
		keep if fn=="sf8_mean_age.dta"
		split parm, p("#")
		split parm1, p(".")
		gen no=real(parm11)
		replace no=(102-no)*0.3+1.7
		gen group=1 if parm2=="1.group_age"
		replace group=2 if parm2=="2.group_age"
		replace group=3 if parm2=="3.group_age"
		replace group=4 if parm2=="4.group_age"
		gen key=_n
		sort key
		save "$figure/sf8/temp.dta",replace
		use "$data/main.dta", clear
		gen key=_n
		sort key
		merge key using "$figure/sf8/temp.dta"
		gen yline=0
		
		replace estimate=estimate*100*4.81732 if parm2=="1.group_age"
		replace max95=max95*100*4.81732 if parm2=="1.group_age"
		replace min95=min95*100*4.81732 if parm2=="1.group_age"
		
		replace estimate=estimate*100*4.637835 if parm2=="2.group_age"
		replace max95=max95*100*4.637835 if parm2=="2.group_age"
		replace min95=min95*100*4.637835 if parm2=="2.group_age"
		
		replace estimate=estimate*100*4.692696 if parm2=="3.group_age"
		replace max95=max95*100*4.692696 if parm2=="3.group_age"
		replace min95=min95*100*4.692696 if parm2=="3.group_age"
		
		replace estimate=estimate*100*4.850742 if parm2=="4.group_age"
		replace max95=max95*100*4.850742 if parm2=="4.group_age"
		replace min95=min95*100*4.850742 if parm2=="4.group_age"
		
		gen group_age=1
		replace group_age=2 if(trueage>=75&trueage<85)
		replace group_age=3 if(trueage>=85&trueage<95)
		replace group_age=4 if(trueage>=95)
		replace group_age=. if trueage==.
		replace group_age=. if trueage<65
		
		graph twoway hist mean_maxhi if group_age==4, width(0.5) percent color(gold*0.6%60) yaxis(2)       ///
			||   hist mean_maxhi if group_age==3, width(0.5) percent color(midgreen*0.6%60) yaxis(2)       ///
			||   hist mean_maxhi if group_age==1, width(0.5) percent color(ebblue*0.8%60) yaxis(2)        ///
			||   hist mean_maxhi if group_age==2, width(0.5) percent color(orange_red*0.6%60) yaxis(2)       ///
           	||   rarea max95 min95 no if group==3,color(midgreen*0.6%60) ///
			||   rarea max95 min95 no if group==4,color(gold*0.6%60) ///
		    ||   rarea max95 min95 no if group==1,color(ebblue*0.8%60) ///
			||   rarea max95 min95 no if group==2,color(orange_red*0.6%60) ///
			||   line estimate  no if group==1,clpattern(solid) clwidth(medium) clcolor(ebblue*1.1) yaxis(1)  ///
			||   line estimate  no if group==2,clpattern(solid) clwidth(medium) clcolor(orange_red*0.9) yaxis(1)  ///
			||   line estimate  no if group==3,clpattern(solid) clwidth(medium) clcolor(midgreen*0.9) yaxis(1)  ///
			||   line estimate  no if group==4,clpattern(solid) clwidth(medium) clcolor(gold*0.9) yaxis(1)  ///
			||   line yline  no,clpattern(dash) clwidth(medium)   clcolor(black)   ///
			||   ,    ///
				 xlabel(2 8 14 20 26 32, nogrid labsize(3.5))  ///
				 ylabel(-15 -10 -5 0 5 10 15 , axis(1) nogrid labsize(3.5))  ///
				 ylabel(0 4 8 12 16 20 24,axis(2) angle(270))  ///
				 yscale(noline alt)  ///
				 yscale(range(0 24) alt axis(2))  ///    
				 xscale(noline)  ///
				 legend(order(9 10 11 12) label(9 "Age:65-75") label(10 "Age:75-85") label(11 "Age:85-95") label(12 "Age:Upper 95")  ring(0) pos(12) rowgap(0.5) cols(2) size(3))  ///
				 xtitle("Annual mean temperature index (℃)" , size(3.5))  ///
				 ytitle("Marginal effect on mortality risk of older adults""(% points per 1℃ increase)"" " , axis(1) size(3.5))  ///
				 ytitle("Frequency distributions of observed""moderating variables (%)"" ", axis(2) orientation(rvertical) size(3.5))  ///
				 title("Annual mean temperature index "" " , size(3.5)) ///
				 xsca(titlegap(2))  ///
				 ysca(titlegap(2))  ///
				 fysize(180) fxsize(200) ///
				 ysize(18) xsize(20) ///
				 scheme(s1mono) graphregion(fcolor(white) ilcolor(white) lcolor(white))
				 
		 graph save "$figure/sf8/sf8_3", replace
		 graph export "$figure/sf8/sf8_3.png", replace width(3000)
		 erase "$figure/sf8/temp.dta"
		 
********************************************************************************

* sf8_4
	
		cd $figure/sf8
		openall, storefilename(fn)
		keep if fn=="sf8_td95_age.dta"
		split parm, p("#")
		split parm1, p(".")
		gen no=real(parm11)
		replace no=(102-no)*0.37-0.37
		gen group=1 if parm2=="1.group_age"
		replace group=2 if parm2=="2.group_age"
		replace group=3 if parm2=="3.group_age"
		replace group=4 if parm2=="4.group_age"
		gen key=_n
		sort key
		save "$figure/sf8/temp.dta",replace
		use "$data/main.dta", clear
		gen key=_n
		sort key
		merge key using "$figure/sf8/temp.dta"
		gen yline=0
		replace estimate=estimate*100*6.541455 if parm2=="1.group_age"
		replace max95=max95*100*6.541455 if parm2=="1.group_age"
		replace min95=min95*100*6.541455 if parm2=="1.group_age"
		
		replace estimate=estimate*100*6.945769 if parm2=="2.group_age"
		replace max95=max95*100*6.945769 if parm2=="2.group_age"
		replace min95=min95*100*6.945769 if parm2=="2.group_age"
		
		replace estimate=estimate*100*7.095044 if parm2=="3.group_age"
		replace max95=max95*100*7.095044 if parm2=="3.group_age"
		replace min95=min95*100*7.095044 if parm2=="3.group_age"
		
		replace estimate=estimate*100*7.142057 if parm2=="4.group_age"
		replace max95=max95*100*7.142057 if parm2=="4.group_age"
		replace min95=min95*100*7.142057 if parm2=="4.group_age"
		
		gen group_age=1
		replace group_age=2 if(trueage>=75&trueage<85)
		replace group_age=3 if(trueage>=85&trueage<95)
		replace group_age=4 if(trueage>=95)
		replace group_age=. if trueage==.
		replace group_age=. if trueage<65
		
		graph twoway hist TD95_adthi if group_age==4, width(0.5) percent color(gold*0.6%60) yaxis(2)       ///
			||   hist TD95_adthi if group_age==3, width(0.5) percent color(midgreen*0.6%60) yaxis(2)       ///
			||   hist TD95_adthi if group_age==1, width(0.5) percent color(ebblue*0.8%60) yaxis(2)        ///
			||   hist TD95_adthi if group_age==2, width(0.5) percent color(orange_red*0.6%60) yaxis(2)       ///
           	||   rarea max95 min95 no if group==3,color(midgreen*0.6%60) ///
			||   rarea max95 min95 no if group==4,color(gold*0.6%60) ///
		    ||   rarea max95 min95 no if group==1,color(ebblue*0.8%60) ///
			||   rarea max95 min95 no if group==2,color(orange_red*0.6%60) ///
			||   line estimate  no if group==1,clpattern(solid) clwidth(medium) clcolor(ebblue*1.1) yaxis(1)  ///
			||   line estimate  no if group==2,clpattern(solid) clwidth(medium) clcolor(orange_red*0.9) yaxis(1)  ///
			||   line estimate  no if group==3,clpattern(solid) clwidth(medium) clcolor(midgreen*0.9) yaxis(1)  ///
			||   line estimate  no if group==4,clpattern(solid) clwidth(medium) clcolor(gold*0.9) yaxis(1)  ///
			||   line yline  no,clpattern(dash) clwidth(medium)   clcolor(black)   ///
			||   ,    ///
				 xlabel(0 7 14 21 28 35, nogrid labsize(3.5))  ///
				 ylabel(-15 -10 -5 0 5 10 15 , axis(1) nogrid labsize(3.5))  ///
				 ylabel(0 4 8 12 16 20 24,axis(2) angle(270))  ///
				 yscale(noline alt)  ///
				 yscale(range(0 24) alt axis(2))  ///
				 xscale(noline)  ///
				 legend(order(9 10 11 12) label(9 "Age:65-75") label(10 "Age:75-85") label(11 "Age:85-95") label(12 "Age:Upper 95")  ring(0) pos(12) rowgap(0.5) cols(2) size(3))  ///
				 xtitle("Number of days with EHF>0 (days)" , size(3.5))  ///
				 ytitle("Marginal effect on mortality risk of older adults""(% points per 1-s.d. increase)"" " , axis(1) size(3.5))  ///
				 ytitle("Frequency distributions of observed""moderating variables (%)"" ", axis(2) orientation(rvertical) size(3.5))  ///
				 title("Number of days with EHF>0 "" " , size(3.5)) ///
				 xsca(titlegap(2))  ///
				 ysca(titlegap(2))  ///
				 fysize(180) fxsize(200) ///
				 ysize(18) xsize(20) ///
				 scheme(s1mono) graphregion(fcolor(white) ilcolor(white) lcolor(white))
				 
		 graph save "$figure/sf8/sf8_4", replace
		 graph export "$figure/sf8/sf8_4.png", replace width(3000)
		 erase "$figure/sf8/temp.dta"
		 
********************************************************************************

	* sf8_5
	
		cd $figure/sf8
		openall, storefilename(fn)
		keep if fn=="sf8_mean_bmi.dta"
		split parm, p("#")
		split parm1, p(".")
		gen no=real(parm11)
		replace no=(102-no)*0.3+1.7
		gen group=0 if parm2=="0.BMI"
		replace group=1 if parm2=="1.BMI"
		replace group=2 if parm2=="2.BMI"
		gen key=_n
		sort key
		save "$figure/sf8/temp.dta",replace
		use "$data/main.dta", clear
		gen key=_n
		sort key
		merge key using "$figure/sf8/temp.dta"
		gen BMI=g101/((g1021/100)*(g1021/100))
		replace BMI=0 if BMI<24
		replace BMI=2 if BMI>=28
		replace BMI=1 if BMI>=24
		gen yline=0
		
		replace estimate=estimate*100*4.717299 if parm2=="0.BMI"
		replace max95=max95*100*4.717299 if parm2=="0.BMI"
		replace min95=min95*100*4.717299 if parm2=="0.BMI"
		
		replace estimate=estimate*100*4.601998 if parm2=="1.BMI"
		replace max95=max95*100*4.601998 if parm2=="1.BMI"
		replace min95=min95*100*4.601998 if parm2=="1.BMI"
		
		replace estimate=estimate*100*4.949718 if parm2=="2.BMI"
		replace max95=max95*100*4.949718 if parm2=="2.BMI"
		replace min95=min95*100*4.949718 if parm2=="2.BMI"
		
		graph twoway hist mean_maxhi if BMI==0, width(0.5) percent color(ebblue*0.8%60) yaxis(2)        ///
			||   hist mean_maxhi if BMI==1, width(0.5) percent color(orange_red*0.6%60) yaxis(2)       ///
			||   hist mean_maxhi if BMI==2, width(0.5) percent color(midgreen*0.6%60) yaxis(2)       ///
            ||   rarea max95 min95 no if group==0,color(ebblue*0.8%60) ///
			||   rarea max95 min95 no if group==1,color(orange_red*0.6%60) ///
			||   rarea max95 min95 no if group==2,color(midgreen*0.6%60) ///
			||   line estimate  no if group==0,clpattern(solid) clwidth(medium) clcolor(ebblue*1.1) yaxis(1)  ///
			||   line estimate  no if group==1,clpattern(solid) clwidth(medium) clcolor(orange_red*0.9) yaxis(1)  ///
			||   line estimate  no if group==2,clpattern(solid) clwidth(medium) clcolor(midgreen*0.9) yaxis(1)  ///
			||   line yline  no,clpattern(dash) clwidth(medium)   clcolor(black)   ///
			||   ,    ///
				 xlabel(2 8 14 20 26 32, nogrid labsize(3.5))  ///
				 ylabel(-15 -10 -5 0 5 10 15 , axis(1) nogrid labsize(3.5))  ///
				 ylabel(0 4 8 12 16 20 24,axis(2) angle(270))  ///
				 yscale(noline alt)  ///
				 yscale(range(0 24) alt axis(2))  ///    
				 xscale(noline)  ///
				 legend(order(7 8 9) label(7 "BMI:Less than 24") label(8 "BMI:24-28") label(9 "BMI:Over 28") ring(0) pos(12) rowgap(0.5) cols(1) size(3))  ///
				 xtitle("Annual mean temperature index (℃)" , size(3.5))  ///
				 ytitle("Marginal effect on mortality risk of older adults""(% points per 1-s.d. increase)"" " , axis(1) size(3.5))  ///
				 ytitle("Frequency distributions of observed""moderating variables (%)"" ", axis(2) orientation(rvertical) size(3.5))  ///
				 title("Annual mean temperature index"" " , size(3.5)) ///
				 xsca(titlegap(2))  ///
				 ysca(titlegap(2))  ///
				 fysize(180) fxsize(200) ///
				 ysize(18) xsize(20) ///
				 scheme(s1mono) graphregion(fcolor(white) ilcolor(white) lcolor(white))
				 
		 graph save "$figure/sf8/sf8_5", replace
		 graph export "$figure/sf8/sf8_5.png", replace width(3000)
		 erase "$figure/sf8/temp.dta"
		 
********************************************************************************



	* sf8_6
	
		cd $figure/sf8
		openall, storefilename(fn)
		keep if fn=="sf8_td95_bmi.dta"
		split parm, p("#")
		split parm1, p(".")
		gen no=real(parm11)
		replace no=(102-no)*0.37-0.37
		gen group=0 if parm2=="0.BMI"
		replace group=1 if parm2=="1.BMI"
		replace group=2 if parm2=="2.BMI"
		gen key=_n
		sort key
		save "$figure/sf8/temp.dta",replace
		use "$data/main.dta", clear
		gen key=_n
		sort key
		merge key using "$figure/sf8/temp.dta"
		gen BMI=g101/((g1021/100)*(g1021/100))
		replace BMI=0 if BMI<24
		replace BMI=2 if BMI>=28
		replace BMI=1 if BMI>=24
		gen yline=0
		
		replace estimate=estimate*100*6.938681 if parm2=="0.BMI"
		replace max95=max95*100*6.938681 if parm2=="0.BMI"
		replace min95=min95*100*6.938681 if parm2=="0.BMI"
		
		replace estimate=estimate*100*6.950091 if parm2=="1.BMI"
		replace max95=max95*100*6.950091 if parm2=="1.BMI"
		replace min95=min95*100*6.950091 if parm2=="1.BMI"
		
		replace estimate=estimate*100*7.219665 if parm2=="2.BMI"
		replace max95=max95*100*7.219665 if parm2=="2.BMI"
		replace min95=min95*100*7.219665 if parm2=="2.BMI"
		
		graph twoway hist TD95_adthi if BMI==0, width(0.5) percent color(ebblue*0.8%60) yaxis(2)        ///
			||   hist TD95_adthi if BMI==1, width(0.5) percent color(orange_red*0.6%60) yaxis(2)       ///
			||   hist TD95_adthi if BMI==2, width(0.5) percent color(midgreen*0.6%60) yaxis(2)       ///
            ||   rarea max95 min95 no if group==0,color(ebblue*0.8%60) ///
			||   rarea max95 min95 no if group==1,color(orange_red*0.6%60) ///
			||   rarea max95 min95 no if group==2,color(midgreen*0.6%60) ///
			||   line estimate  no if group==0,clpattern(solid) clwidth(medium) clcolor(ebblue*1.1) yaxis(1)  ///
			||   line estimate  no if group==1,clpattern(solid) clwidth(medium) clcolor(orange_red*0.9) yaxis(1)  ///
			||   line estimate  no if group==2,clpattern(solid) clwidth(medium) clcolor(midgreen*0.9) yaxis(1)  ///
			||   line yline  no,clpattern(dash) clwidth(medium)   clcolor(black)   ///
			||   ,    ///
				 xlabel(0 7 14 21 28 35, nogrid labsize(3.5))  ///
				 ylabel(-15 -10 -5 0 5 10 15 , axis(1) nogrid labsize(3.5))  ///
				 ylabel(0 4 8 12 16 20 24,axis(2) angle(270))  ///
				 yscale(noline alt)  ///
				 yscale(range(0 24) alt axis(2))  ///
				 xscale(noline)  ///
				 legend(order(7 8 9) label(7 "BMI:Less than 24") label(8 "BMI:24-28") label(9 "BMI:Over 28") ring(0) pos(12) rowgap(0.5) cols(1) size(3))  ///
				 xtitle("Number of days with EHF>0 (days)" , size(3.5))  ///
				 ytitle("Marginal effect on mortality risk of older adults""(% points per 1-s.d. increase)"" " , axis(1) size(3.5))  ///
				 ytitle("Frequency distributions of observed""moderating variables (%)"" ", axis(2) orientation(rvertical) size(3.5))  ///
				 title("Number of days with EHF>0 "" " , size(3.5)) ///
				 xsca(titlegap(2))  ///
				 ysca(titlegap(2))  ///
				 fysize(180) fxsize(200) ///
				 ysize(18) xsize(20) ///
				 scheme(s1mono) graphregion(fcolor(white) ilcolor(white) lcolor(white))
				 
		 graph save "$figure/sf8/sf8_6", replace
		 graph export "$figure/sf8/sf8_6.png", replace width(3000)
		 erase "$figure/sf8/temp.dta"
		 
********************************************************************************