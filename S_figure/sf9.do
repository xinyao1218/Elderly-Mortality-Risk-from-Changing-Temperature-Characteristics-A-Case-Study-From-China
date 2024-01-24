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
* sf9:Income heterogeneity on mortality risk of older adults to changes in temperature
*
********************************************************************************
	
	use "$data/main.dta", clear
	
	gen group_income=1
	replace group_income=2 if(income>=0.22&income<0.6)
	replace group_income=3 if(income>=0.6&income<1.5)
	replace group_income=4 if(income>=1.5&income<3.8)
	replace group_income=5 if(income>=3.8)
	replace group_income=. if(income==.)
	
	global control sex trueage g101 g1021 h3 d1 smoke drink exercise area f1 income  hypertension diabetes heartdisease stroke_cvd asthma tuberculosis cataract glaucoma cancer gastric_ulcer parkinson bedsore arthritis dementia a2 meat fish egg bean veg tea garl a51 vegeta fruit f41 chil 
	
	sum mean_maxhi
	global Min: dis %4.0f r(min)
	global Max: dis %4.0f r(max)
	global Grid = ($Max-$Min)/100
	
	reghdfe death c.mean_maxhi##c.mean_maxhi#i.group_income c.sd_meanhi c.TN95_adthi c.TD95_adthi c.annual_pre_365 $control , absorb(prov#year prov#month) cluster(gbcode)
    margins group_income, dydx(mean_maxhi) at(mean_maxhi=($Max($Grid)$Min)) post
	parmest , saving($figure/sf9/sf9_mean_income.dta, replace)
	
	
	sum TD95_adthi
	global Min: dis %4.0f r(min)
	global Max: dis %4.0f r(max)
	global Grid = ($Max-$Min)/100
	
	reghdfe death c.mean_maxhi c.sd_meanhi c.TN95_adthi c.TD95_adthi##c.TD95_adthi#i.group_income c.annual_pre_365 $control , absorb(prov#year prov#month) cluster(gbcode)
    margins group_income, dydx(TD95_adthi) at(TD95_adthi=($Max($Grid)$Min)) post
	parmest , saving($figure/sf9/sf9_td95_income.dta, replace)
	
	

	
	
	
********************************************************************************

	* sf9_1
	
		cd $figure/sf9
		openall, storefilename(fn)
		keep if fn=="sf9_mean_income.dta"
		split parm, p("#")
		split parm1, p(".")
		gen no=real(parm11)
		replace no=(102-no)*0.3+1.7
		keep if parm2=="1.group_income"
		gen key=_n
		sort key
		save "$figure/sf9/temp.dta",replace
		use "$data/main.dta", clear
		gen key=_n
		sort key
		merge key using "$figure/sf9/temp.dta"
		gen group_income=1
		replace group_income=2 if(income>=0.22&income<0.6)
		replace group_income=3 if(income>=0.6&income<1.5)
		replace group_income=4 if(income>=1.5&income<3.8)
		replace group_income=5 if(income>=3.8)
		replace group_income=. if(income==.)
		gen yline=0
		replace estimate=estimate*100*4.633662
		replace max95=max95*100*4.633662
		replace min95=min95*100*4.633662
		
		graph twoway hist mean_maxhi if group_income==1, width(0.5) percent color(red*0.8%60) yaxis(2)        ///
            ||   rarea max95 min95 no ,color(red*0.8%60) ///
			||   line estimate  no ,clpattern(solid) clwidth(medium) clcolor(red*1.1) yaxis(1)  ///
			||   line yline  no,clpattern(dash) clwidth(medium)   clcolor(black)   ///
			||   ,    ///
				 xlabel(2 8 14 20 26 32, nogrid labsize(3.5))  ///
				 ylabel(-15 -10 -5 0 5 10 15 , axis(1) nogrid labsize(3.5))  ///
				 ylabel(0 4 8 12 16 20 24,axis(2) angle(270))  ///
				 yscale(noline alt)  ///
				 yscale(range(0 24) alt axis(2))  ///    
				 xscale(noline)  ///
				 legend(order(3) label(3 "Income:Lowest")  ring(0) pos(12) rowgap(0.5) cols(1) size(3))  ///
				 xtitle("Annual mean temperature index (℃)" , size(3.5))  ///
				 ytitle("Marginal effect on mortality risk of older adults""(% points per 1-s.d. increase)"" " , axis(1) size(3.5))  ///
				 ytitle("Frequency distributions of observed""moderating variables (%)"" ", axis(2) orientation(rvertical) size(3.5))  ///
				 title("Annual mean temperature index"" " , size(3.5)) ///
				 xsca(titlegap(2))  ///
				 ysca(titlegap(2))  ///
				 fysize(180) fxsize(200) ///
				 ysize(18) xsize(20) ///
				 scheme(s1mono) graphregion(fcolor(white) ilcolor(white) lcolor(white))
				 
		 graph save "$figure/sf9/sf9_1", replace
		 graph export "$figure/sf9/sf9_1.png", replace width(3000)
		 erase "$figure/sf9/temp.dta"
		 
********************************************************************************

	* sf9_2
	
		cd $figure/sf9
		openall, storefilename(fn)
		keep if fn=="sf9_mean_income.dta"
		split parm, p("#")
		split parm1, p(".")
		gen no=real(parm11)
		replace no=(102-no)*0.3+1.7
		keep if parm2=="2.group_income"
		gen key=_n
		sort key
		save "$figure/sf9/temp.dta",replace
		use "$data/main.dta", clear
		gen key=_n
		sort key
		merge key using "$figure/sf9/temp.dta"
		gen group_income=1
		replace group_income=2 if(income>=0.22&income<0.6)
		replace group_income=3 if(income>=0.6&income<1.5)
		replace group_income=4 if(income>=1.5&income<3.8)
		replace group_income=5 if(income>=3.8)
		replace group_income=. if(income==.)
		gen yline=0
		replace estimate=estimate*100*4.763254
		replace max95=max95*100*4.763254
		replace min95=min95*100*4.763254
		
		graph twoway hist mean_maxhi if group_income==2, width(0.5) percent color(orange_red*0.8%60) yaxis(2)        ///
            ||   rarea max95 min95 no ,color(orange_red*0.8%60) ///
			||   line estimate  no ,clpattern(solid) clwidth(medium) clcolor(orange_red*1.1) yaxis(1)  ///
			||   line yline  no,clpattern(dash) clwidth(medium)   clcolor(black)   ///
			||   ,    ///
				xlabel(2 8 14 20 26 32, nogrid labsize(3.5))  ///
				 ylabel(-15 -10 -5 0 5 10 15 , axis(1) nogrid labsize(3.5))  ///
				 ylabel(0 4 8 12 16 20 24,axis(2) angle(270))  ///
				 yscale(noline alt)  ///
				 yscale(range(0 24) alt axis(2))  ///    
				 xscale(noline)  ///
				 legend(order(3) label(3 "Income:Low")  ring(0) pos(12) rowgap(0.5) cols(1) size(3))  ///
				 xtitle("Annual mean temperature index (℃)" , size(3.5))  ///
				 ytitle("Marginal effect on mortality risk of older adults""(% points per 1-s.d. increase)"" " , axis(1) size(3.5))  ///
				 ytitle("Frequency distributions of observed""moderating variables (%)"" ", axis(2) orientation(rvertical) size(3.5))  ///
				 title("Annual mean temperature index"" " , size(3.5)) ///
				 xsca(titlegap(2))  ///
				 ysca(titlegap(2))  ///
				 fysize(180) fxsize(200) ///
				 ysize(18) xsize(20) ///
				 scheme(s1mono) graphregion(fcolor(white) ilcolor(white) lcolor(white))
				 
		 graph save "$figure/sf9/sf9_2", replace
		 graph export "$figure/sf9/sf9_2.png", replace width(3000)
		 erase "$figure/sf9/temp.dta"
		 
********************************************************************************

	* sf9_3
	
		cd $figure/sf9
		openall, storefilename(fn)
		keep if fn=="sf9_mean_income.dta"
		split parm, p("#")
		split parm1, p(".")
		gen no=real(parm11)
		replace no=(102-no)*0.3+1.7
		keep if parm2=="3.group_income"
		gen key=_n
		sort key
		save "$figure/sf9/temp.dta",replace
		use "$data/main.dta", clear
		gen key=_n
		sort key
		merge key using "$figure/sf9/temp.dta"
		gen group_income=1
		replace group_income=2 if(income>=0.22&income<0.6)
		replace group_income=3 if(income>=0.6&income<1.5)
		replace group_income=4 if(income>=1.5&income<3.8)
		replace group_income=5 if(income>=3.8)
		replace group_income=. if(income==.)
		gen yline=0
		replace estimate=estimate*100*4.759138
		replace max95=max95*100*4.759138
		replace min95=min95*100*4.759138
		
		graph twoway hist mean_maxhi if group_income==3, width(0.5) percent color(green*0.8%60) yaxis(2)        ///
            ||   rarea max95 min95 no ,color(green*0.8%60) ///
			||   line estimate  no ,clpattern(solid) clwidth(medium) clcolor(green*1.1) yaxis(1)  ///
			||   line yline  no,clpattern(dash) clwidth(medium)   clcolor(black)   ///
			||   ,    ///
				 xlabel(2 8 14 20 26 32, nogrid labsize(3.5))  ///
				 ylabel(-15 -10 -5 0 5 10 15 , axis(1) nogrid labsize(3.5))  ///
				 ylabel(0 4 8 12 16 20 24,axis(2) angle(270))  ///
				 yscale(noline alt)  ///
				 yscale(range(0 24) alt axis(2))  ///    
				 xscale(noline)  ///
				 legend(order(3) label(3 "Income:Middle")  ring(0) pos(12) rowgap(0.5) cols(1) size(3))  ///
				 xtitle("Annual mean temperature index (℃)" , size(3.5))  ///
				 ytitle("Marginal effect on mortality risk of older adults""(% points per 1-s.d. increase)"" " , axis(1) size(3.5))  ///
				 ytitle("Frequency distributions of observed""moderating variables (%)"" ", axis(2) orientation(rvertical) size(3.5))  ///
				 title("Annual mean temperature index"" " , size(3.5)) ///
				 xsca(titlegap(2))  ///
				 ysca(titlegap(2))  ///
				 fysize(180) fxsize(200) ///
				 ysize(18) xsize(20) ///
				 scheme(s1mono) graphregion(fcolor(white) ilcolor(white) lcolor(white))
				 
		 graph save "$figure/sf9/sf9_3", replace
		 graph export "$figure/sf9/sf9_3.png", replace width(3000)
		 erase "$figure/sf9/temp.dta"
		 
********************************************************************************

	* sf9_4
	
		cd $figure/sf9
		openall, storefilename(fn)
		keep if fn=="sf9_mean_income.dta"
		split parm, p("#")
		split parm1, p(".")
		gen no=real(parm11)
		replace no=(102-no)*0.3+1.7
		keep if parm2=="4.group_income"
		gen key=_n
		sort key
		save "$figure/sf9/temp.dta",replace
		use "$data/main.dta", clear
		gen key=_n
		sort key
		merge key using "$figure/sf9/temp.dta"
		gen group_income=1
		replace group_income=2 if(income>=0.22&income<0.6)
		replace group_income=3 if(income>=0.6&income<1.5)
		replace group_income=4 if(income>=1.5&income<3.8)
		replace group_income=5 if(income>=3.8)
		replace group_income=. if(income==.)
		gen yline=0
		replace estimate=estimate*100*4.902299
		replace max95=max95*100*4.902299
		replace min95=min95*100*4.902299
		
		graph twoway hist mean_maxhi if group_income==4, width(0.5) percent color(ebblue*0.8%60) yaxis(2)        ///
            ||   rarea max95 min95 no ,color(ebblue*0.8%60) ///
			||   line estimate  no ,clpattern(solid) clwidth(medium) clcolor(ebblue*1.1) yaxis(1)  ///
			||   line yline  no,clpattern(dash) clwidth(medium)   clcolor(black)   ///
			||   ,    ///
				 xlabel(2 8 14 20 26 32, nogrid labsize(3.5))  ///
				 ylabel(-15 -10 -5 0 5 10 15 , axis(1) nogrid labsize(3.5))  ///
				 ylabel(0 4 8 12 16 20 24,axis(2) angle(270))  ///
				 yscale(noline alt)  ///
				 yscale(range(0 24) alt axis(2))  ///    
				 xscale(noline)  ///
				 legend(order(3) label(3 "Income:High")  ring(0) pos(12) rowgap(0.5) cols(1) size(3))  ///
				 xtitle("Annual mean temperature index (℃)" , size(3.5))  ///
				 ytitle("Marginal effect on mortality risk of older adults""(% points per 1-s.d. increase)"" " , axis(1) size(3.5))  ///
				 ytitle("Frequency distributions of observed""moderating variables (%)"" ", axis(2) orientation(rvertical) size(3.5))  ///
				 title("Annual mean temperature index"" " , size(3.5)) ///
				 xsca(titlegap(2))  ///
				 ysca(titlegap(2))  ///
				 fysize(180) fxsize(200) ///
				 ysize(18) xsize(20) ///
				 scheme(s1mono) graphregion(fcolor(white) ilcolor(white) lcolor(white))
				 
		 graph save "$figure/sf9/sf9_4", replace
		 graph export "$figure/sf9/sf9_4.png", replace width(3000)
		 erase "$figure/sf9/temp.dta"
		 
********************************************************************************

	* sf9_5
	
		cd $figure/sf9
		openall, storefilename(fn)
		keep if fn=="sf9_mean_income.dta"
		split parm, p("#")
		split parm1, p(".")
		gen no=real(parm11)
		replace no=(102-no)*0.3+1.7
		keep if parm2=="5.group_income"
		gen key=_n
		sort key
		save "$figure/sf9/temp.dta",replace
		use "$data/main.dta", clear
		gen key=_n
		sort key
		merge key using "$figure/sf9/temp.dta"
		gen group_income=1
		replace group_income=2 if(income>=0.22&income<0.6)
		replace group_income=3 if(income>=0.6&income<1.5)
		replace group_income=4 if(income>=1.5&income<3.8)
		replace group_income=5 if(income>=3.8)
		replace group_income=. if(income==.)
		gen yline=0
		replace estimate=estimate*100*4.594879
		replace max95=max95*100*4.594879
		replace min95=min95*100*4.594879
		
		graph twoway hist mean_maxhi if group_income==5, width(0.5) percent color(blue*0.8%60) yaxis(2)        ///
            ||   rarea max95 min95 no ,color(blue*0.8%60) ///
			||   line estimate  no ,clpattern(solid) clwidth(medium) clcolor(blue*1.1) yaxis(1)  ///
			||   line yline  no,clpattern(dash) clwidth(medium)   clcolor(black)   ///
			||   ,    ///
				 xlabel(2 8 14 20 26 32, nogrid labsize(3.5))  ///
				 ylabel(-15 -10 -5 0 5 10 15 , axis(1) nogrid labsize(3.5))  ///
				 ylabel(0 4 8 12 16 20 24,axis(2) angle(270))  ///
				 yscale(noline alt)  ///
				 yscale(range(0 24) alt axis(2))  ///    
				 xscale(noline)  ///
				 legend(order(3) label(3 "Income:Highest")  ring(0) pos(12) rowgap(0.5) cols(1) size(3))  ///
				 xtitle("Annual mean temperature index (℃)" , size(3.5))  ///
				 ytitle("Marginal effect on mortality risk of older adults""(% points per 1-s.d. increase)"" " , axis(1) size(3.5))  ///
				 ytitle("Frequency distributions of observed""moderating variables (%)"" ", axis(2) orientation(rvertical) size(3.5))  ///
				 title("Annual mean temperature index"" " , size(3.5)) ///
				 xsca(titlegap(2))  ///
				 ysca(titlegap(2))  ///
				 fysize(180) fxsize(200) ///
				 ysize(18) xsize(20) ///
				 scheme(s1mono) graphregion(fcolor(white) ilcolor(white) lcolor(white))
				 
		 graph save "$figure/sf9/sf9_5", replace
		 graph export "$figure/sf9/sf9_5.png", replace width(3000)
		 erase "$figure/sf9/temp.dta"
		 
********************************************************************************

	* sf9_6
	
		cd $figure/sf9
		openall, storefilename(fn)
		keep if fn=="sf9_td95_income.dta"
		split parm, p("#")
		split parm1, p(".")
		gen no=real(parm11)
		replace no=(102-no)*0.37-0.37
		keep if parm2=="1.group_income"
		gen key=_n
		sort key
		save "$figure/sf9/temp.dta",replace
		use "$data/main.dta", clear
		gen key=_n
		sort key
		merge key using "$figure/sf9/temp.dta"
		gen group_income=1
		replace group_income=2 if(income>=0.22&income<0.6)
		replace group_income=3 if(income>=0.6&income<1.5)
		replace group_income=4 if(income>=1.5&income<3.8)
		replace group_income=5 if(income>=3.8)
		replace group_income=. if(income==.)
		gen yline=0
		replace estimate=estimate*100*6.504463
		replace max95=max95*100*6.504463
		replace min95=min95*100*6.504463
		
		graph twoway hist TD95_adthi if group_income==1, width(0.5) percent color(red*0.8%60) yaxis(2)        ///
            ||   rarea max95 min95 no ,color(red*0.8%60) ///
			||   line estimate  no ,clpattern(solid) clwidth(medium) clcolor(red*1.1) yaxis(1)  ///
			||   line yline  no,clpattern(dash) clwidth(medium)   clcolor(black)   ///
			||   ,    ///
				 xlabel(0 7 14 21 28 35, nogrid labsize(3.5))  ///
				 ylabel(-15 -10 -5 0 5 10 15 , axis(1) nogrid labsize(3.5))  ///
				 ylabel(0 4 8 12 16 20 24,axis(2) angle(270))  ///
				 yscale(noline alt)  ///
				 yscale(range(0 24) alt axis(2))  ///    
				 xscale(noline)  ///
				 legend(order(3) label(3 "Income:Lowest")  ring(0) pos(12) rowgap(0.5) cols(1) size(3))  ///
				 xtitle("Number of days with EHF>0 (days)" , size(3.5))  ///
				 ytitle("Marginal effect on mortality risk of older adults""(% points per 1-s.d. increase)"" " , axis(1) size(3.5))  ///
				 ytitle("Frequency distributions of observed""moderating variables (%)"" ", axis(2) orientation(rvertical) size(3.5))  ///
				 title("Number of days with EHF>0 "" " , size(3.5)) ///
				 xsca(titlegap(2))  ///
				 ysca(titlegap(2))  ///
				 fysize(180) fxsize(200) ///
				 ysize(18) xsize(20) ///
				 scheme(s1mono) graphregion(fcolor(white) ilcolor(white) lcolor(white))
				 
		 graph save "$figure/sf9/sf9_6", replace
		 graph export "$figure/sf9/sf9_6.png", replace width(3000)
		 erase "$figure/sf9/temp.dta"
		 
********************************************************************************

	* sf9_7
	
		cd $figure/sf9
		openall, storefilename(fn)
		keep if fn=="sf9_td95_income.dta"
		split parm, p("#")
		split parm1, p(".")
		gen no=real(parm11)
		replace no=(102-no)*0.37-0.37
		keep if parm2=="2.group_income"
		gen key=_n
		sort key
		save "$figure/sf9/temp.dta",replace
		use "$data/main.dta", clear
		gen key=_n
		sort key
		merge key using "$figure/sf9/temp.dta"
		gen group_income=1
		replace group_income=2 if(income>=0.22&income<0.6)
		replace group_income=3 if(income>=0.6&income<1.5)
		replace group_income=4 if(income>=1.5&income<3.8)
		replace group_income=5 if(income>=3.8)
		replace group_income=. if(income==.)
		gen yline=0
		replace estimate=estimate*100*6.894038
		replace max95=max95*100*6.894038
		replace min95=min95*100*6.894038
		
		graph twoway hist TD95_adthi if group_income==2, width(0.5) percent color(orange_red*0.8%60) yaxis(2)        ///
            ||   rarea max95 min95 no ,color(orange_red*0.8%60) ///
			||   line estimate  no ,clpattern(solid) clwidth(medium) clcolor(orange_red*1.1) yaxis(1)  ///
			||   line yline  no,clpattern(dash) clwidth(medium)   clcolor(black)   ///
			||   ,    ///
				 xlabel(0 7 14 21 28 35, nogrid labsize(3.5))  ///
				 ylabel(-15 -10 -5 0 5 10 15 , axis(1) nogrid labsize(3.5))  ///
				 ylabel(0 4 8 12 16 20 24,axis(2) angle(270))  ///
				 yscale(noline alt)  ///
				 yscale(range(0 24) alt axis(2))  ///    
				 xscale(noline)  ///
				 legend(order(3) label(3 "Income:Low")  ring(0) pos(12) rowgap(0.5) cols(1) size(3))  ///
				xtitle("Number of days with EHF>0 (days)" , size(3.5))  ///
				 ytitle("Marginal effect on mortality risk of older adults""(% points per 1-s.d. increase)"" " , axis(1) size(3.5))  ///
				 ytitle("Frequency distributions of observed""moderating variables (%)"" ", axis(2) orientation(rvertical) size(3.5))  ///
				 title("Number of days with EHF>0 "" " , size(3.5)) ///
				 xsca(titlegap(2))  ///
				 ysca(titlegap(2))  ///
				 fysize(180) fxsize(200) ///
				 ysize(18) xsize(20) ///
				 scheme(s1mono) graphregion(fcolor(white) ilcolor(white) lcolor(white))
				 
		 graph save "$figure/sf9/sf9_7", replace
		 graph export "$figure/sf9/sf9_7.png", replace width(3000)
		 erase "$figure/sf9/temp.dta"
		 
********************************************************************************

	* sf9_8
	
		cd $figure/sf9
		openall, storefilename(fn)
		keep if fn=="sf9_td95_income.dta"
		split parm, p("#")
		split parm1, p(".")
		gen no=real(parm11)
		replace no=(102-no)*0.37-0.37
		keep if parm2=="3.group_income"
		gen key=_n
		sort key
		save "$figure/sf9/temp.dta",replace
		use "$data/main.dta", clear
		gen key=_n
		sort key
		merge key using "$figure/sf9/temp.dta"
		gen group_income=1
		replace group_income=2 if(income>=0.22&income<0.6)
		replace group_income=3 if(income>=0.6&income<1.5)
		replace group_income=4 if(income>=1.5&income<3.8)
		replace group_income=5 if(income>=3.8)
		replace group_income=. if(income==.)
		gen yline=0
		replace estimate=estimate*100*7.060935
		replace max95=max95*100*7.060935
		replace min95=min95*100*7.060935
		
		graph twoway hist TD95_adthi if group_income==3, width(0.5) percent color(green*0.8%60) yaxis(2)        ///
            ||   rarea max95 min95 no ,color(green*0.8%60) ///
			||   line estimate  no ,clpattern(solid) clwidth(medium) clcolor(green*1.1) yaxis(1)  ///
			||   line yline  no,clpattern(dash) clwidth(medium)   clcolor(black)   ///
			||   ,    ///
				 xlabel(0 7 14 21 28 35, nogrid labsize(3.5))  ///
				 ylabel(-15 -10 -5 0 5 10 15 , axis(1) nogrid labsize(3.5))  ///
				 ylabel(0 4 8 12 16 20 24,axis(2) angle(270))  ///
				 yscale(noline alt)  ///
				 yscale(range(0 24) alt axis(2))  ///    
				 xscale(noline)  ///
				 legend(order(3) label(3 "Income:Middle")  ring(0) pos(12) rowgap(0.5) cols(1) size(3))  ///
				 xtitle("Number of days with EHF>0 (days)" , size(3.5))  ///
				 ytitle("Marginal effect on mortality risk of older adults""(% points per 1-s.d. increase)"" " , axis(1) size(3.5))  ///
				 ytitle("Frequency distributions of observed""moderating variables (%)"" ", axis(2) orientation(rvertical) size(3.5))  ///
				 title("Number of days with EHF>0 "" " , size(3.5)) ///
				 xsca(titlegap(2))  ///
				 ysca(titlegap(2))  ///
				 fysize(180) fxsize(200) ///
				 ysize(18) xsize(20) ///
				 scheme(s1mono) graphregion(fcolor(white) ilcolor(white) lcolor(white))
				 
		 graph save "$figure/sf9/sf9_8", replace
		 graph export "$figure/sf9/sf9_8.png", replace width(3000)
		 erase "$figure/sf9/temp.dta"
		 
********************************************************************************

	* sf9_9
	
		cd $figure/sf9
		openall, storefilename(fn)
		keep if fn=="sf9_td95_income.dta"
		split parm, p("#")
		split parm1, p(".")
		gen no=real(parm11)
		replace no=(102-no)*0.37-0.37
		keep if parm2=="4.group_income"
		gen key=_n
		sort key
		save "$figure/sf9/temp.dta",replace
		use "$data/main.dta", clear
		gen key=_n
		sort key
		merge key using "$figure/sf9/temp.dta"
		gen group_income=1
		replace group_income=2 if(income>=0.22&income<0.6)
		replace group_income=3 if(income>=0.6&income<1.5)
		replace group_income=4 if(income>=1.5&income<3.8)
		replace group_income=5 if(income>=3.8)
		replace group_income=. if(income==.)
		gen yline=0
		replace estimate=estimate*100*7.281255
		replace max95=max95*100*7.281255
		replace min95=min95*100*7.281255
		
		graph twoway hist TD95_adthi if group_income==4, width(0.5) percent color(ebblue*0.8%60) yaxis(2)        ///
            ||   rarea max95 min95 no ,color(ebblue*0.8%60) ///
			||   line estimate  no ,clpattern(solid) clwidth(medium) clcolor(ebblue*1.1) yaxis(1)  ///
			||   line yline  no,clpattern(dash) clwidth(medium)   clcolor(black)   ///
			||   ,    ///
				 xlabel(0 7 14 21 28 35, nogrid labsize(3.5))  ///
				 ylabel(-15 -10 -5 0 5 10 15 , axis(1) nogrid labsize(3.5))  ///
				 ylabel(0 4 8 12 16 20 24,axis(2) angle(270))  ///
				 yscale(noline alt)  ///
				 yscale(range(0 24) alt axis(2))  ///    
				 xscale(noline)  ///
				 legend(order(3) label(3 "Income:High")  ring(0) pos(12) rowgap(0.5) cols(1) size(3))  ///
				xtitle("Number of days with EHF>0 (days)" , size(3.5))  ///
				 ytitle("Marginal effect on mortality risk of older adults""(% points per 1-s.d. increase)"" " , axis(1) size(3.5))  ///
				 ytitle("Frequency distributions of observed""moderating variables (%)"" ", axis(2) orientation(rvertical) size(3.5))  ///
				 title("Number of days with EHF>0 "" " , size(3.5)) ///
				 xsca(titlegap(2))  ///
				 ysca(titlegap(2))  ///
				 fysize(180) fxsize(200) ///
				 ysize(18) xsize(20) ///
				 scheme(s1mono) graphregion(fcolor(white) ilcolor(white) lcolor(white))
				 
		 graph save "$figure/sf9/sf9_9", replace
		 graph export "$figure/sf9/sf9_9.png", replace width(3000)
		 erase "$figure/sf9/temp.dta"
		 
********************************************************************************

	* sf9_10
	
		cd $figure/sf9
		openall, storefilename(fn)
		keep if fn=="sf9_td95_income.dta"
		split parm, p("#")
		split parm1, p(".")
		gen no=real(parm11)
		replace no=(102-no)*0.37-0.37
		keep if parm2=="5.group_income"
		gen key=_n
		sort key
		save "$figure/sf9/temp.dta",replace
		use "$data/main.dta", clear
		gen key=_n
		sort key
		merge key using "$figure/sf9/temp.dta"
		gen group_income=1
		replace group_income=2 if(income>=0.22&income<0.6)
		replace group_income=3 if(income>=0.6&income<1.5)
		replace group_income=4 if(income>=1.5&income<3.8)
		replace group_income=5 if(income>=3.8)
		replace group_income=. if(income==.)
		gen yline=0
		replace estimate=estimate*100*7.037794
		replace max95=max95*100*7.037794
		replace min95=min95*100*7.037794
		
		graph twoway hist TD95_adthi if group_income==5, width(0.5) percent color(blue*0.8%60) yaxis(2)        ///
            ||   rarea max95 min95 no ,color(blue*0.8%60) ///
			||   line estimate  no ,clpattern(solid) clwidth(medium) clcolor(blue*1.1) yaxis(1)  ///
			||   line yline  no,clpattern(dash) clwidth(medium)   clcolor(black)   ///
			||   ,    ///
				 xlabel(0 7 14 21 28 35, nogrid labsize(3.5))  ///
				 ylabel(-15 -10 -5 0 5 10 15 , axis(1) nogrid labsize(3.5))  ///
				 ylabel(0 4 8 12 16 20 24,axis(2) angle(270))  ///
				 yscale(noline alt)  ///
				 yscale(range(0 24) alt axis(2))  ///    
				 xscale(noline)  ///
				 legend(order(3) label(3 "Income:Highest")  ring(0) pos(12) rowgap(0.5) cols(1) size(3))  ///
				xtitle("Number of days with EHF>0 (days)" , size(3.5))  ///
				 ytitle("Marginal effect on mortality risk of older adults""(% points per 1-s.d. increase)"" " , axis(1) size(3.5))  ///
				 ytitle("Frequency distributions of observed""moderating variables (%)"" ", axis(2) orientation(rvertical) size(3.5))  ///
				 title("Number of days with EHF>0 "" " , size(3.5)) ///
				 xsca(titlegap(2))  ///
				 ysca(titlegap(2))  ///
				 fysize(180) fxsize(200) ///
				 ysize(18) xsize(20) ///
				 scheme(s1mono) graphregion(fcolor(white) ilcolor(white) lcolor(white))
				 
		 graph save "$figure/sf9/sf9_10", replace
		 graph export "$figure/sf9/sf9_10.png", replace width(3000)
		 erase "$figure/sf9/temp.dta"
		 
