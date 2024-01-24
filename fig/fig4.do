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
* Figure 4:Heterogeneity of the mortality effects cross income and urban-rural residence
*
********************************************************************************

use "$data/main.dta", clear
	
	global control sex trueage g101 g1021 h3 d1 smoke drink exercise area f1 income  hypertension diabetes heartdisease stroke_cvd asthma tuberculosis cataract glaucoma cancer gastric_ulcer parkinson bedsore arthritis dementia a2 meat fish egg bean veg tea garl a51 vegeta fruit f41 chil 
	
	
	gen group_income=1
	replace group_income=2 if(income>=0.22&income<0.6)
	replace group_income=3 if(income>=0.6&income<1.5)
	replace group_income=4 if(income>=1.5&income<3.8)
	replace group_income=5 if(income>=3.8)
	replace group_income=. if(income==.)

	*regression
	reghdfe death c.mean_maxhi#i.group_income c.sd_meanhi c.TN95_adthi c.TD95_adthi c.annual_pre_365 $control , absorb(prov#year prov#month) cluster(gbcode)
	parmest , saving($figure/fig4/fig4_mean_income.dta, replace)
	
	reghdfe death c.mean_maxhi c.sd_meanhi#i.group_income c.TN95_adthi c.TD95_adthi c.annual_pre_365 $control , absorb(prov#year prov#month) cluster(gbcode)
	parmest , saving($figure/fig4/fig4_sd_income.dta, replace)
	
	reghdfe death c.mean_maxhi c.sd_meanhi c.TN95_adthi#i.group_income c.TD95_adthi c.annual_pre_365 $control , absorb(prov#year prov#month) cluster(gbcode)
	parmest , saving($figure/fig4/fig4_tn_income.dta, replace)
	
	reghdfe death c.mean_maxhi c.sd_meanhi c.TN95_adthi c.TD95_adthi#i.group_income c.annual_pre_365 $control , absorb(prov#year prov#month) cluster(gbcode)
	parmest , saving($figure/fig4/fig4_td_income.dta, replace)
	
********************************************************************************

	global control sex trueage g101 g1021 h3 d1 smoke drink exercise area f1 income  hypertension diabetes heartdisease stroke_cvd asthma tuberculosis cataract glaucoma cancer gastric_ulcer parkinson bedsore arthritis dementia a2 meat fish egg bean veg tea garl a51 vegeta fruit f41 chil 
		
	reghdfe death c.mean_maxhi#i.area c.sd_meanhi c.TN95_adthi c.TD95_adthi c.annual_pre_365 $control , absorb(prov#year prov#month) cluster(gbcode)
	parmest , saving($figure/fig4/fig4_mean_area.dta, replace)
	
	reghdfe death c.mean_maxhi c.sd_meanhi#i.area c.TN95_adthi c.TD95_adthi c.annual_pre_365 $control , absorb(prov#year prov#month) cluster(gbcode)
	parmest , saving($figure/fig4/fig4_sd_area.dta, replace)
	
	reghdfe death c.mean_maxhi c.sd_meanhi c.TN95_adthi#i.area c.TD95_adthi c.annual_pre_365 $control , absorb(prov#year prov#month) cluster(gbcode)
	parmest , saving($figure/fig4/fig4_tn_area.dta, replace)
	
	reghdfe death c.mean_maxhi c.sd_meanhi c.TN95_adthi c.TD95_adthi#i.area c.annual_pre_365 $control , absorb(prov#year prov#month) cluster(gbcode)
	parmest , saving($figure/fig4/fig4_td_area.dta, replace)
	
********************************************************************************
	gen inn=area*5+group_income
	
	global control sex trueage g101 g1021 h3 d1 smoke drink exercise area f1 income  hypertension diabetes heartdisease stroke_cvd asthma tuberculosis cataract glaucoma cancer gastric_ulcer parkinson bedsore arthritis dementia a2 meat fish egg bean veg tea garl a51 vegeta fruit f41 chil 

	reghdfe death c.mean_maxhi#i.inn c.sd_meanhi c.TN95_adthi c.TD95_adthi c.annual_pre_365 $control , absorb(prov#year prov#month) cluster(gbcode)
	parmest , saving($figure/fig4/fig4_mean_inn.dta, replace)
	
	reghdfe death c.mean_maxhi c.sd_meanhi#i.inn c.TN95_adthi c.TD95_adthi c.annual_pre_365 $control , absorb(prov#year prov#month) cluster(gbcode)
	parmest , saving($figure/fig4/fig4_sd_inn.dta, replace)	

	reghdfe death c.mean_maxhi c.sd_meanhi c.TN95_adthi#i.inn c.TD95_adthi c.annual_pre_365 $control , absorb(prov#year prov#month) cluster(gbcode)
	parmest , saving($figure/fig4/fig4_tn_inn.dta, replace)
	
	reghdfe death c.mean_maxhi c.sd_meanhi c.TN95_adthi c.TD95_adthi#i.inn c.annual_pre_365 $control , absorb(prov#year prov#month) cluster(gbcode)
	parmest , saving($figure/fig4/fig4_td_inn.dta, replace)	
	
	
********************************************************************************

	* fig4_1
	
		cd $figure/fig4
		openall, storefilename(fn)
		keep if fn=="fig4_mean_income.dta"
		
		* group
		split parm, p(".")
		gen no=real(parm1)
		replace no=1 if parm1=="1b"
		drop if no==.
		sort no 
		
		replace estimate=estimate*100*4.633662 if no==1
		replace min95=min95*100*4.633662 if no==1
		replace max95=max95*100*4.633662 if no==1
		
		replace estimate=estimate*100*4.763254 if no==2
		replace min95=min95*100*4.763254 if no==2
		replace max95=max95*100*4.763254 if no==2
		
		replace estimate=estimate*100*4.759138 if no==3
		replace min95=min95*100*4.759138 if no==3
		replace max95=max95*100*4.759138 if no==3
		
		replace estimate=estimate*100*4.902299 if no==4
		replace min95=min95*100*4.902299 if no==4
		replace max95=max95*100*4.902299 if no==4
		
		replace estimate=estimate*100*4.594879 if no==5
		replace min95=min95*100*4.594879 if no==5
		replace max95=max95*100*4.594879 if no==5
		
		*adjust numerical scheme
		gen maker1 = estimate
		format %3.2f maker1
		gen x = 6- no 
		
		label define ylabel			///
				0 " "				///
				1 " Highest " ///
				2 " High " ///
				3 " Middle " ///
				4 " Low " ///
				5 " {it:Group by income},Lowest " ///

			
			label values x ylabel
			
	     graph twoway   (rcap min95 max95 x if no==1, horizontal lcolor(red*1.2) lwidth(medthick))	///
						(rcap min95 max95 x if no==2, horizontal lcolor(orange_red*1.2) lwidth(medthick))	///
						(rcap min95 max95 x if no==3, horizontal lcolor(green*1.2) lwidth(medthick))	///
						(rcap min95 max95 x if no==4, horizontal lcolor(ebblue*1.2) lwidth(medthick))	///
						(rcap min95 max95 x if no==5, horizontal lcolor(blue*1.2) lwidth(medthick))	///
						(scatter x estimate if no==1, msymbol(O) mlcolor(red*1) mfcolor(red*0.6) msize(1.5) mlabel(maker1) mlabposition(5) mlabgap(*1.2) mlabsize(3)) ///
						(scatter x estimate if no==2, msymbol(O) mlcolor(orange_red*1) mfcolor(orange_red*0.6) msize(1.5) mlabel(maker1) mlabposition(5) mlabgap(*1.2) mlabsize(3)) ///
						(scatter x estimate if no==3, msymbol(O) mlcolor(green*1) mfcolor(green*0.6) msize(1.5) mlabel(maker1) mlabposition(5) mlabgap(*1.2) mlabsize(3)) ///
						(scatter x estimate if no==4, msymbol(O) mlcolor(ebblue*1) mfcolor(ebblue*0.6) msize(1.5) mlabel(maker1) mlabposition(5) mlabgap(*1.2) mlabsize(3)) ///
						(scatter x estimate if no==5, msymbol(O) mlcolor(blue*1) mfcolor(blue*0.6) msize(1.5) mlabel(maker1) mlabposition(5) mlabgap(*1.2) mlabsize(3)) ///
						,scheme(s1mono) ///
						legend(off) ///
						ysize(6) xsize(8) ///
						xline(0, lp(dash) lc(yellow*1.3) lwidth(thin)) ///
						ylabel(1/5, valuelabel labsize(3.2) angle(0) nogrid) ///
						yscale(range(0.2 5.5)) ///
						ytitle("") ///
						title("Annual mean temperature""index", pos(12) size(3.2) color(black)) ///
						fysize(100) fxsize(122) ///
						yline(1, lp(shortdash) lc(gray*0.7) lwidth(thin)) ///
						yline(2, lp(shortdash) lc(gray*0.7) lwidth(thin)) ///
						yline(3, lp(shortdash) lc(gray*0.7) lwidth(thin)) ///
						yline(4, lp(shortdash) lc(gray*0.7) lwidth(thin)) ///
						yline(5, lp(shortdash) lc(gray*0.7) lwidth(thin)) ///
						xlabel(-2 (2) 6, labsize(3.15) nogrid)  ///
						xtitle(" ",size(3.15) color(black)) 
		graph save "$figure/fig4/fig4_1", replace

********************************************************************************

	* fig4_2
	
		cd $figure/fig4
		openall, storefilename(fn)
		keep if fn=="fig4_sd_income.dta"
		
		* group
		split parm, p(".")
		gen no=real(parm1)
		replace no=1 if parm1=="1b"
		drop if no==.
		sort no 
		
		replace estimate=estimate*100*0.4556555 if no==1
		replace min95=min95*100*0.4556555 if no==1
		replace max95=max95*100*0.4556555 if no==1
		
		replace estimate=estimate*100*0.4553013 if no==2
		replace min95=min95*100*0.4553013 if no==2
		replace max95=max95*100*0.4553013 if no==2
		
		replace estimate=estimate*100*0.4599229  if no==3
		replace min95=min95*100*0.4599229  if no==3
		replace max95=max95*100*0.4599229  if no==3
		
		replace estimate=estimate*100*0.4803412 if no==4
		replace min95=min95*100*0.4803412 if no==4
		replace max95=max95*100*0.4803412 if no==4
		
		replace estimate=estimate*100*0.4250306 if no==5
		replace min95=min95*100*0.4250306 if no==5
		replace max95=max95*100*0.4250306 if no==5
		
		*adjust numerical scheme
		gen maker1 = estimate
		format %3.2f maker1
		gen x = 6- no 
		
			
	    graph twoway   (rcap min95 max95 x if no==1, horizontal lcolor(red*1.2) lwidth(medthick))	///
						(rcap min95 max95 x if no==2, horizontal lcolor(orange_red*1.2) lwidth(medthick))	///
						(rcap min95 max95 x if no==3, horizontal lcolor(green*1.2) lwidth(medthick))	///
						(rcap min95 max95 x if no==4, horizontal lcolor(ebblue*1.2) lwidth(medthick))	///
						(rcap min95 max95 x if no==5, horizontal lcolor(blue*1.2) lwidth(medthick))	///
						(scatter x estimate if no==1, msymbol(O) mlcolor(red*1) mfcolor(red*0.6) msize(1.5) mlabel(maker1) mlabposition(5) mlabgap(*1.2) mlabsize(3)) ///
						(scatter x estimate if no==2, msymbol(O) mlcolor(orange_red*1) mfcolor(orange_red*0.6) msize(1.5) mlabel(maker1) mlabposition(5) mlabgap(*1.2) mlabsize(3)) ///
						(scatter x estimate if no==3, msymbol(O) mlcolor(green*1) mfcolor(green*0.6) msize(1.5) mlabel(maker1) mlabposition(5) mlabgap(*1.2) mlabsize(3)) ///
						(scatter x estimate if no==4, msymbol(O) mlcolor(ebblue*1) mfcolor(ebblue*0.6) msize(1.5) mlabel(maker1) mlabposition(5) mlabgap(*1.2) mlabsize(3)) ///
						(scatter x estimate if no==5, msymbol(O) mlcolor(blue*1) mfcolor(blue*0.6) msize(1.5) mlabel(maker1) mlabposition(5) mlabgap(*1.2) mlabsize(3)) ///
						,scheme(s1mono) ///
						legend(off) ///
						ysize(6) xsize(5) ///
						xline(0, lp(dash) lc(yellow*1.3) lwidth(thin)) ///
						ylabel(1/5, nolabels noticks nogrid) ///
						yscale(range(0.2 5.5)) ///
						ytitle("") ///
						title("Day-to-day temperature""index variability", pos(12) size(3.2) color(black)) ///
						fysize(100) fxsize(65) ///
						yline(1, lp(shortdash) lc(gray*0.7) lwidth(thin)) ///
						yline(2, lp(shortdash) lc(gray*0.7) lwidth(thin)) ///
						yline(3, lp(shortdash) lc(gray*0.7) lwidth(thin)) ///
						yline(4, lp(shortdash) lc(gray*0.7) lwidth(thin)) ///
						yline(5, lp(shortdash) lc(gray*0.7) lwidth(thin)) ///
						xlabel(-2 (2) 6, labsize(3.15) nogrid)  ///
						xtitle(" ",size(3.15) color(black)) 
		graph save "$figure/fig4/fig4_2", replace

********************************************************************************

	* fig4_3
	
		cd $figure/fig4
		openall, storefilename(fn)
		keep if fn=="fig4_tn_income.dta"
		
		* group
		split parm, p(".")
		gen no=real(parm1)
		replace no=1 if parm1=="1b"
		drop if no==.
		sort no 
		
		replace estimate=estimate*100*3.237964 if no==1
		replace min95=min95*100*3.237964 if no==1
		replace max95=max95*100*3.237964 if no==1
		
		replace estimate=estimate*100*3.472745 if no==2
		replace min95=min95*100*3.472745 if no==2
		replace max95=max95*100*3.472745 if no==2
		
		replace estimate=estimate*100*3.500754 if no==3
		replace min95=min95*100*3.500754 if no==3
		replace max95=max95*100*3.500754 if no==3
		
		replace estimate=estimate*100*3.439837 if no==4
		replace min95=min95*100*3.439837 if no==4
		replace max95=max95*100*3.439837 if no==4
		
		replace estimate=estimate*100*3.391249 if no==5
		replace min95=min95*100*3.391249 if no==5
		replace max95=max95*100*3.391249 if no==5
		
		*adjust numerical scheme
		gen maker1 = estimate
		format %3.2f maker1
		gen x = 6- no 
		
			
	    graph twoway   (rcap min95 max95 x if no==1, horizontal lcolor(red*1.2) lwidth(medthick))	///
						(rcap min95 max95 x if no==2, horizontal lcolor(orange_red*1.2) lwidth(medthick))	///
						(rcap min95 max95 x if no==3, horizontal lcolor(green*1.2) lwidth(medthick))	///
						(rcap min95 max95 x if no==4, horizontal lcolor(ebblue*1.2) lwidth(medthick))	///
						(rcap min95 max95 x if no==5, horizontal lcolor(blue*1.2) lwidth(medthick))	///
						(scatter x estimate if no==1, msymbol(O) mlcolor(red*1) mfcolor(red*0.6) msize(1.5) mlabel(maker1) mlabposition(5) mlabgap(*1.2) mlabsize(3)) ///
						(scatter x estimate if no==2, msymbol(O) mlcolor(orange_red*1) mfcolor(orange_red*0.6) msize(1.5) mlabel(maker1) mlabposition(5) mlabgap(*1.2) mlabsize(3)) ///
						(scatter x estimate if no==3, msymbol(O) mlcolor(green*1) mfcolor(green*0.6) msize(1.5) mlabel(maker1) mlabposition(5) mlabgap(*1.2) mlabsize(3)) ///
						(scatter x estimate if no==4, msymbol(O) mlcolor(ebblue*1) mfcolor(ebblue*0.6) msize(1.5) mlabel(maker1) mlabposition(5) mlabgap(*1.2) mlabsize(3)) ///
						(scatter x estimate if no==5, msymbol(O) mlcolor(blue*1) mfcolor(blue*0.6) msize(1.5) mlabel(maker1) mlabposition(5) mlabgap(*1.2) mlabsize(3)) ///
						,scheme(s1mono) ///
						legend(off) ///
						ysize(6) xsize(5) ///
						xline(0, lp(dash) lc(yellow*1.3) lwidth(thin)) ///
						ylabel(1/5, nolabels noticks nogrid) ///
						yscale(range(0.2 5.5)) ///
						ytitle("") ///
						title("Annual mean EHF"" ", pos(12) size(3.2) color(black)) ///
						fysize(100) fxsize(65) ///
						yline(1, lp(shortdash) lc(gray*0.7) lwidth(thin)) ///
						yline(2, lp(shortdash) lc(gray*0.7) lwidth(thin)) ///
						yline(3, lp(shortdash) lc(gray*0.7) lwidth(thin)) ///
						yline(4, lp(shortdash) lc(gray*0.7) lwidth(thin)) ///
						yline(5, lp(shortdash) lc(gray*0.7) lwidth(thin)) ///
						xlabel(-2 (2) 6, labsize(3.15) nogrid)  ///
						xtitle(" ",size(3.15) color(black)) 
		graph save "$figure/fig4/fig4_3", replace

********************************************************************************

	* fig4_4
	
		cd $figure/fig4
		openall, storefilename(fn)
		keep if fn=="fig4_td_income.dta"
		
		* group
		split parm, p(".")
		gen no=real(parm1)
		replace no=1 if parm1=="1b"
		drop if no==.
		sort no 
		
		replace estimate=estimate*100*6.504463 if no==1
		replace min95=min95*100*6.504463 if no==1
		replace max95=max95*100*6.504463 if no==1
		
		replace estimate=estimate*100*6.894038 if no==2
		replace min95=min95*100*6.894038 if no==2
		replace max95=max95*100*6.894038 if no==2
		
		replace estimate=estimate*100*7.060935 if no==3
		replace min95=min95*100*7.060935 if no==3
		replace max95=max95*100*7.060935 if no==3
		
		replace estimate=estimate*100*7.281255 if no==4
		replace min95=min95*100*7.281255 if no==4
		replace max95=max95*100*7.281255 if no==4
		
		replace estimate=estimate*100*7.037794 if no==5
		replace min95=min95*100*7.037794 if no==5
		replace max95=max95*100*7.037794 if no==5
		
		*adjust numerical scheme
		gen maker1 = estimate
		format %3.2f maker1
		gen x = 6- no 
		
			
	    graph twoway   (rcap min95 max95 x if no==1, horizontal lcolor(red*1.2) lwidth(medthick))	///
						(rcap min95 max95 x if no==2, horizontal lcolor(orange_red*1.2) lwidth(medthick))	///
						(rcap min95 max95 x if no==3, horizontal lcolor(green*1.2) lwidth(medthick))	///
						(rcap min95 max95 x if no==4, horizontal lcolor(ebblue*1.2) lwidth(medthick))	///
						(rcap min95 max95 x if no==5, horizontal lcolor(blue*1.2) lwidth(medthick))	///
						(scatter x estimate if no==1, msymbol(O) mlcolor(red*1) mfcolor(red*0.6) msize(1.5) mlabel(maker1) mlabposition(5) mlabgap(*1.2) mlabsize(3)) ///
						(scatter x estimate if no==2, msymbol(O) mlcolor(orange_red*1) mfcolor(orange_red*0.6) msize(1.5) mlabel(maker1) mlabposition(5) mlabgap(*1.2) mlabsize(3)) ///
						(scatter x estimate if no==3, msymbol(O) mlcolor(green*1) mfcolor(green*0.6) msize(1.5) mlabel(maker1) mlabposition(5) mlabgap(*1.2) mlabsize(3)) ///
						(scatter x estimate if no==4, msymbol(O) mlcolor(ebblue*1) mfcolor(ebblue*0.6) msize(1.5) mlabel(maker1) mlabposition(5) mlabgap(*1.2) mlabsize(3)) ///
						(scatter x estimate if no==5, msymbol(O) mlcolor(blue*1) mfcolor(blue*0.6) msize(1.5) mlabel(maker1) mlabposition(5) mlabgap(*1.2) mlabsize(3)) ///
						,scheme(s1mono) ///
						legend(off) ///
						ysize(6) xsize(5) ///
						xline(0, lp(dash) lc(yellow*1.3) lwidth(thin)) ///
						ylabel(1/5, nolabels noticks nogrid) ///
						yscale(range(0.2 5.5)) ///
						ytitle("") ///
						title("Number of days with EHF>0"" ", pos(12) size(3.2) color(black)) ///
						fysize(100) fxsize(65) ///
						yline(1, lp(shortdash) lc(gray*0.7) lwidth(thin)) ///
						yline(2, lp(shortdash) lc(gray*0.7) lwidth(thin)) ///
						yline(3, lp(shortdash) lc(gray*0.7) lwidth(thin)) ///
						yline(4, lp(shortdash) lc(gray*0.7) lwidth(thin)) ///
						yline(5, lp(shortdash) lc(gray*0.7) lwidth(thin)) ///
						xlabel(-2 (2) 6, labsize(3.15) nogrid)  ///
						xtitle(" ",size(3.15) color(black)) 
		graph save "$figure/fig4/fig4_4", replace

********************************************************************************


		graph combine "$figure/fig4/fig4_1" "$figure/fig4/fig4_2" "$figure/fig4/fig4_3""$figure/fig4/fig4_4", ///
				graphregion(fcolor(white) lcolor(white)) imargin(small) col(4) iscale(1) fysize(150) fxsize(240) xsize(15) ysize(6)  title("            		     	             Effect on mortality risk of a 1-s.d. increase (%points)"" ", pos(6) size(3.2) color(black))
							
		graph save "$figure/fig4/fig4_s1", replace
		graph export "$figure/fig4/fig4_s1.png", replace width(10000)
		
********************************************************************************

	* fig4_5
	
		cd $figure/fig4
		openall, storefilename(fn)
		keep if fn=="fig4_mean_area.dta"
		
		* group
		split parm, p(".")
		gen no=real(parm1)
		replace no=0 if parm1=="0b"
		drop if no==.
		sort no 

		
		replace estimate=estimate*100*4.49942 if no==0
		replace min95=min95*100*4.49942 if no==0
		replace max95=max95*100*4.49942 if no==0
		
		replace estimate=estimate*100*4.994595 if no==1
		replace min95=min95*100*4.994595 if no==1
		replace max95=max95*100*4.994595 if no==1
		
		*adjust numerical scheme
		gen maker1 = estimate
		format %3.2f maker1
		gen x = no +0.5
		
			
	    graph twoway   (rcap min95 max95 x if no==0, vertical lcolor(red*1.2) lwidth(medthick))	///
						(rcap min95 max95 x if no==1, vertical lcolor(blue*1.2) lwidth(medthick))	///
						(scatter estimate x  if no==0, msymbol(O) mlcolor(red*1) mfcolor(red*0.6) msize(1.5) mlabel(maker1) mlabposition(3) mlabgap(*1.2) mlabsize(3)) ///
						(scatter estimate x  if no==1, msymbol(O) mlcolor(blue*1) mfcolor(blue*0.6) msize(1.5) mlabel(maker1) mlabposition(3) mlabgap(*1.2) mlabsize(3)) ///
						,scheme(plotplainblind) ///
						legend(off) ///
						xsize(8) ysize(5) ///
						yline(0, lp(dash) lc(yellow*1.3) lwidth(thin)) ///
						xlab(0 " " 0.5 "Rural" 1.5 "City or town" 2 " ",labcolor(black) axis(1) nogrid labsize(3.5)) ///
						xscale(range(0 2)) ///
						xtitle("") ///
						title("Annual mean temperature index"" "" ", pos(12) size(3.2) color(black)) ///
						fxsize(75) fysize(65) ///
						xline(0.5, lp(shortdash) lc(gray*0.7) lwidth(thin)) ///
						xline(1.5, lp(shortdash) lc(gray*0.7) lwidth(thin)) ///
						ylabel(-2 (2) 6, labsize(3.15) nogrid)  ///
						ytitle("Effect on mortality risk of a 1-s.d. increase (%points)"" ",size(3.15) color(black)) 
		graph save "$figure/fig4/fig4_5", replace
		
********************************************************************************

	* fig4_6
	
		cd $figure/fig4
		openall, storefilename(fn)
		keep if fn=="fig4_sd_area.dta"
		
		* group
		split parm, p(".")
		gen no=real(parm1)
		replace no=0 if parm1=="0b"
		drop if no==.
		sort no 

		
		replace estimate=estimate*100*0.4358814 if no==0
		replace min95=min95*100*0.4358814 if no==0
		replace max95=max95*100*0.4358814 if no==0
		
		replace estimate=estimate*100*0.475024 if no==1
		replace min95=min95*100*0.475024 if no==1
		replace max95=max95*100*0.475024 if no==1
		
		*adjust numerical scheme
		gen maker1 = estimate
		format %3.2f maker1
		gen x = no +0.5
		
			
	    graph twoway   (rcap min95 max95 x if no==0, vertical lcolor(red*1.2) lwidth(medthick))	///
						(rcap min95 max95 x if no==1, vertical lcolor(blue*1.2) lwidth(medthick))	///
						(scatter estimate x  if no==0, msymbol(O) mlcolor(red*1) mfcolor(red*0.6) msize(1.5) mlabel(maker1) mlabposition(3) mlabgap(*1.2) mlabsize(3)) ///
						(scatter estimate x  if no==1, msymbol(O) mlcolor(blue*1) mfcolor(blue*0.6) msize(1.5) mlabel(maker1) mlabposition(3) mlabgap(*1.2) mlabsize(3)) ///
						,scheme(plotplainblind) ///
						legend(off) ///
						xsize(5) ysize(5) ///
						yline(0, lp(dash) lc(yellow*1.3) lwidth(thin)) ///
						xlab(0 " " 0.5 "Rural" 1.5 "City or town" 2 " ",labcolor(black) axis(1) nogrid labsize(3.5)) ///
						xscale(range(0 2)) ///
						xtitle("") ///
						title("Day-to-day temperature""index variability"" ", pos(12) size(3.2) color(black)) ///
						fxsize(65) fysize(65) ///
						xline(0.5, lp(shortdash) lc(gray*0.7) lwidth(thin)) ///
						xline(1.5, lp(shortdash) lc(gray*0.7) lwidth(thin)) ///
						ylabel(-2 (2) 6, labsize(3.15) nogrid)  
		graph save "$figure/fig4/fig4_6", replace
		
********************************************************************************

	* fig4_7
	
		cd $figure/fig4
		openall, storefilename(fn)
		keep if fn=="fig4_tn_area.dta"
		
		* group
		split parm, p(".")
		gen no=real(parm1)
		replace no=0 if parm1=="0b"
		drop if no==.
		sort no 

		
		replace estimate=estimate*100*3.541981 if no==0
		replace min95=min95*100*3.541981 if no==0
		replace max95=max95*100*3.541981 if no==0
		
		replace estimate=estimate*100*3.27693 if no==1
		replace min95=min95*100*3.27693 if no==1
		replace max95=max95*100*3.27693 if no==1
		
		*adjust numerical scheme
		gen maker1 = estimate
		format %3.2f maker1
		gen x = no +0.5
		
			
	    graph twoway   (rcap min95 max95 x if no==0, vertical lcolor(red*1.2) lwidth(medthick))	///
						(rcap min95 max95 x if no==1, vertical lcolor(blue*1.2) lwidth(medthick))	///
						(scatter estimate x  if no==0, msymbol(O) mlcolor(red*1) mfcolor(red*0.6) msize(1.5) mlabel(maker1) mlabposition(3) mlabgap(*1.2) mlabsize(3)) ///
						(scatter estimate x  if no==1, msymbol(O) mlcolor(blue*1) mfcolor(blue*0.6) msize(1.5) mlabel(maker1) mlabposition(3) mlabgap(*1.2) mlabsize(3)) ///
						,scheme(plotplainblind) ///
						legend(off) ///
						xsize(5) ysize(5) ///
						yline(0, lp(dash) lc(yellow*1.3) lwidth(thin)) ///
						xlab(0 " " 0.5 "Rural" 1.5 "City or town" 2 " ",labcolor(black) axis(1) nogrid labsize(3.5)) ///
						xscale(range(0 2)) ///
						xtitle("") ///
						title("Annual mean EHF"" "" ", pos(12) size(3.2) color(black)) ///
						fxsize(65) fysize(65) ///
						xline(0.5, lp(shortdash) lc(gray*0.7) lwidth(thin)) ///
						xline(1.5, lp(shortdash) lc(gray*0.7) lwidth(thin)) ///
						ylabel(-2 (2) 6, labsize(3.15) nogrid)  
		graph save "$figure/fig4/fig4_7", replace
		
********************************************************************************

	* fig4_8
	
		cd $figure/fig4
		openall, storefilename(fn)
		keep if fn=="fig4_td_area.dta"
		
		* group
		split parm, p(".")
		gen no=real(parm1)
		replace no=0 if parm1=="0b"
		drop if no==.
		sort no 

		
		replace estimate=estimate*100*7.183478 if no==0
		replace min95=min95*100*7.183478 if no==0
		replace max95=max95*100*7.183478 if no==0
		
		replace estimate=estimate*100*6.692994 if no==1
		replace min95=min95*100*6.692994 if no==1
		replace max95=max95*100*6.692994 if no==1
		
		*adjust numerical scheme
		gen maker1 = estimate
		format %3.2f maker1
		gen x = no +0.5
		
			
	    graph twoway   (rcap min95 max95 x if no==0, vertical lcolor(red*1.2) lwidth(medthick))	///
						(rcap min95 max95 x if no==1, vertical lcolor(blue*1.2) lwidth(medthick))	///
						(scatter estimate x  if no==0, msymbol(O) mlcolor(red*1) mfcolor(red*0.6) msize(1.5) mlabel(maker1) mlabposition(3) mlabgap(*1.2) mlabsize(3)) ///
						(scatter estimate x  if no==1, msymbol(O) mlcolor(blue*1) mfcolor(blue*0.6) msize(1.5) mlabel(maker1) mlabposition(3) mlabgap(*1.2) mlabsize(3)) ///
						,scheme(plotplainblind) ///
						legend(off) ///
						xsize(5) ysize(5) ///
						yline(0, lp(dash) lc(yellow*1.3) lwidth(thin)) ///
						xlab(0 " " 0.5 "Rural" 1.5 "City or town" 2 " ",labcolor(black) axis(1) nogrid labsize(3.5)) ///
						xscale(range(0 2)) ///
						xtitle("") ///
						title("Number of days with EHF>0"" "" ", pos(12) size(3.2) color(black)) ///
						fxsize(65) fysize(65) ///
						xline(0.5, lp(shortdash) lc(gray*0.7) lwidth(thin)) ///
						xline(1.5, lp(shortdash) lc(gray*0.7) lwidth(thin)) ///
						ylabel(-2 (2) 6, labsize(3.15) nogrid)  
		graph save "$figure/fig4/fig4_8", replace
		
********************************************************************************

		graph combine "$figure/fig4/fig4_5" "$figure/fig4/fig4_6" "$figure/fig4/fig4_7""$figure/fig4/fig4_8", ///
				graphregion(fcolor(white) lcolor(white)) imargin(small) col(4) iscale(1) fysize(150) fxsize(240) xsize(15) ysize(6)  
							
		graph save "$figure/fig4/fig4_s2", replace
		graph export "$figure/fig4/fig4_s2.png", replace width(10000)
		
********************************************************************************


	* fig4_9
	
		cd $figure/fig4
		openall, storefilename(fn)
		keep if fn=="fig4_mean_inn.dta"
		
		* group
		split parm, p(".")
		gen no=real(parm1)
		replace no=1 if parm1=="1b"
		drop if no==.
		sort no 

		gen group=1 if no<6
		replace group=2 if no>5
		
		replace estimate=estimate*100*4.473076 if no==1
		replace min95=min95*100*4.473076 if no==1
		replace max95=max95*100*4.473076 if no==1
		
		replace estimate=estimate*100*4.570945 if no==2
		replace min95=min95*100*4.570945 if no==2
		replace max95=max95*100*4.570945 if no==2
		
		replace estimate=estimate*100*4.545009 if no==3
		replace min95=min95*100*4.545009 if no==3
		replace max95=max95*100*4.545009 if no==3
		
		replace estimate=estimate*100*4.532459 if no==4
		replace min95=min95*100*4.532459 if no==4
		replace max95=max95*100*4.532459 if no==4
		
		replace estimate=estimate*100*4.216254 if no==5
		replace min95=min95*100*4.216254 if no==5
		replace max95=max95*100*4.216254 if no==5
		
		replace estimate=estimate*100*4.997981 if no==6
		replace min95=min95*100*4.997981 if no==6
		replace max95=max95*100*4.997981 if no==6
		
		replace estimate=estimate*100*5.062327 if no==7
		replace min95=min95*100*5.062327 if no==7
		replace max95=max95*100*5.062327 if no==7
		
		replace estimate=estimate*100*4.937198 if no==8
		replace min95=min95*100*4.937198 if no==8
		replace max95=max95*100*4.937198 if no==8
		
		replace estimate=estimate*100*5.087413 if no==9
		replace min95=min95*100*5.087413 if no==9
		replace max95=max95*100*5.087413 if no==9
		
		replace estimate=estimate*100*4.814611 if no==10
		replace min95=min95*100*4.814611 if no==10
		replace max95=max95*100*4.814611 if no==10
		
		*adjust numerical scheme
		gen maker1 = estimate
		format %3.2f maker1
		gen x = 6-(no-(group-1)*5)
		replace x=x+0.2 if group==1
		replace x=x-0.2 if group==2
		
			
	    graph twoway   (rcap min95 max95 x if no==1, horizontal lcolor(red*1.2) lwidth(medthick))	///
						(rcap min95 max95 x if no==6, horizontal lcolor(red*1.2) lwidth(medthick))	///
						(rcap min95 max95 x if no==2, horizontal lcolor(orange_red*1.2) lwidth(medthick))	///
						(rcap min95 max95 x if no==7, horizontal lcolor(orange_red*1.2) lwidth(medthick))	///
						(rcap min95 max95 x if no==3, horizontal lcolor(green*1.2) lwidth(medthick))	///
						(rcap min95 max95 x if no==8, horizontal lcolor(green*1.2) lwidth(medthick))	///
						(rcap min95 max95 x if no==4, horizontal lcolor(ebblue*1.2) lwidth(medthick))	///
						(rcap min95 max95 x if no==9, horizontal lcolor(ebblue*1.2) lwidth(medthick))	///
						(rcap min95 max95 x if no==5, horizontal lcolor(blue*1.2) lwidth(medthick))	///
						(rcap min95 max95 x if no==10, horizontal lcolor(blue*1.2) lwidth(medthick))	///
						(scatter x estimate if no==1, msymbol(O) mlcolor(red*1) mfcolor(red*0.6) msize(1.5) mlabel(maker1) mlabposition(5) mlabgap(*0.5) mlabsize(3)) ///
						(scatter x estimate if no==6, msymbol(O) mlcolor(red*1) mfcolor(red*0.6) msize(1.5) mlabel(maker1) mlabposition(5) mlabgap(*0.5) mlabsize(3)) ///
						(scatter x estimate if no==2, msymbol(O) mlcolor(orange_red*1) mfcolor(orange_red*0.6) msize(1.5) mlabel(maker1) mlabposition(5) mlabgap(*0.5) mlabsize(3)) ///
						(scatter x estimate if no==7, msymbol(O) mlcolor(orange_red*1) mfcolor(orange_red*0.6) msize(1.5) mlabel(maker1) mlabposition(5) mlabgap(*0.5) mlabsize(3)) ///
						(scatter x estimate if no==3, msymbol(O) mlcolor(green*1) mfcolor(green*0.6) msize(1.5) mlabel(maker1) mlabposition(5) mlabgap(*0.5) mlabsize(3)) ///
						(scatter x estimate if no==8, msymbol(O) mlcolor(green*1) mfcolor(green*0.6) msize(1.5) mlabel(maker1) mlabposition(5) mlabgap(*0.5) mlabsize(3)) ///
						(scatter x estimate if no==4, msymbol(O) mlcolor(ebblue*1) mfcolor(ebblue*0.6) msize(1.5) mlabel(maker1) mlabposition(5) mlabgap(*0.5) mlabsize(3)) ///
						(scatter x estimate if no==9, msymbol(O) mlcolor(ebblue*1) mfcolor(ebblue*0.6) msize(1.5) mlabel(maker1) mlabposition(5) mlabgap(*0.5) mlabsize(3)) ///
						(scatter x estimate if no==5, msymbol(O) mlcolor(blue*1) mfcolor(blue*0.6) msize(1.5) mlabel(maker1) mlabposition(5) mlabgap(*0.5) mlabsize(3)) ///
						(scatter x estimate if no==10, msymbol(O) mlcolor(blue*1) mfcolor(blue*0.6) msize(1.5) mlabel(maker1) mlabposition(5) mlabgap(*0.5) mlabsize(3)) ///
						,scheme(plotplainblind) ///
						legend(off) ///
						ysize(6) xsize(8) ///
						xline(0, lp(dash) lc(yellow*1.3) lwidth(thin)) ///
						ylabel(0.3 " " 0.8 "City or town" 1.2 "{it:Highest income},Rural" 1.8 "City or town" 2.2 "{it:High income},Rural" 2.8 "City or town" 3.2 "{it:Middle income},Rural" 3.8 "City or town" 4.2 "{it:Low income},Rural" 4.8 "City or town" 5.2 "{it:Lowest income},Rural" 5.7 " ",labcolor(black) axis(1) nogrid labsize(3.5)) ///
						yscale(range(0.3 5.7)) ///
						ytitle("") ///
						title("Annual mean temperature""index", pos(12) size(3.2) color(black)) ///
						fysize(100) fxsize(116) ///
						yline(0.8, lp(shortdash) lc(gray*0.7) lwidth(thin)) ///
						yline(1.8, lp(shortdash) lc(gray*0.7) lwidth(thin)) ///
						yline(2.8, lp(shortdash) lc(gray*0.7) lwidth(thin)) ///
						yline(3.8, lp(shortdash) lc(gray*0.7) lwidth(thin)) ///
						yline(4.8, lp(shortdash) lc(gray*0.7) lwidth(thin)) ///
						yline(1.2, lp(shortdash) lc(gray*0.7) lwidth(thin)) ///
						yline(2.2, lp(shortdash) lc(gray*0.7) lwidth(thin)) ///
						yline(3.2, lp(shortdash) lc(gray*0.7) lwidth(thin)) ///
						yline(4.2, lp(shortdash) lc(gray*0.7) lwidth(thin)) ///
						yline(5.2, lp(shortdash) lc(gray*0.7) lwidth(thin)) ///
						xlabel(-2 (2) 6, labsize(3.15) nogrid)  
		graph save "$figure/fig4/fig4_9", replace


		
********************************************************************************

	* fig4_10
	
		cd $figure/fig4
		openall, storefilename(fn)
		keep if fn=="fig4_sd_inn.dta"
		
		* group
		split parm, p(".")
		gen no=real(parm1)
		replace no=1 if parm1=="1b"
		drop if no==.
		sort no  
		gen group=1 if no<6
		replace group=2 if no>5
		
		replace estimate=estimate*100*0.4455216 if no==1
		replace min95=min95*100*0.4455216 if no==1
		replace max95=max95*100*0.4455216 if no==1
		
		replace estimate=estimate*100*0.4377332 if no==2
		replace min95=min95*100*0.4377332 if no==2
		replace max95=max95*100*0.4377332 if no==2
		
		replace estimate=estimate*100*0.4426851 if no==3
		replace min95=min95*100*0.4426851 if no==3
		replace max95=max95*100*0.4426851 if no==3
		
		replace estimate=estimate*100*0.4461262 if no==4
		replace min95=min95*100*0.4461262 if no==4
		replace max95=max95*100*0.4461262 if no==4
		
		replace estimate=estimate*100*0.3968151 if no==5
		replace min95=min95*100*0.3968151 if no==5
		replace max95=max95*100*0.3968151 if no==5
		
		replace estimate=estimate*100*0.4791877 if no==6
		replace min95=min95*100*0.4791877 if no==6
		replace max95=max95*100*0.4791877 if no==6
		
		replace estimate=estimate*100*0.4791897 if no==7
		replace min95=min95*100*0.4791897 if no==7
		replace max95=max95*100*0.4791897 if no==7
		
		replace estimate=estimate*100*0.4732706 if no==8
		replace min95=min95*100*0.4732706 if no==8
		replace max95=max95*100*0.4732706 if no==8
		
		replace estimate=estimate*100*0.5025305 if no==9
		replace min95=min95*100*0.5025305 if no==9
		replace max95=max95*100*0.5025305 if no==9
		
		replace estimate=estimate*100*0.4435905 if no==10
		replace min95=min95*100*0.4435905 if no==10
		replace max95=max95*100*0.4435905 if no==10
		
		*adjust numerical scheme
		gen maker1 = estimate
		format %3.2f maker1
		gen x = 6-(no-(group-1)*5)
		replace x=x+0.2 if group==1
		replace x=x-0.2 if group==2
		
			
	    graph twoway   (rcap min95 max95 x if no==1, horizontal lcolor(red*1.2) lwidth(medthick))	///
						(rcap min95 max95 x if no==6, horizontal lcolor(red*1.2) lwidth(medthick))	///
						(rcap min95 max95 x if no==2, horizontal lcolor(orange_red*1.2) lwidth(medthick))	///
						(rcap min95 max95 x if no==7, horizontal lcolor(orange_red*1.2) lwidth(medthick))	///
						(rcap min95 max95 x if no==3, horizontal lcolor(green*1.2) lwidth(medthick))	///
						(rcap min95 max95 x if no==8, horizontal lcolor(green*1.2) lwidth(medthick))	///
						(rcap min95 max95 x if no==4, horizontal lcolor(ebblue*1.2) lwidth(medthick))	///
						(rcap min95 max95 x if no==9, horizontal lcolor(ebblue*1.2) lwidth(medthick))	///
						(rcap min95 max95 x if no==5, horizontal lcolor(blue*1.2) lwidth(medthick))	///
						(rcap min95 max95 x if no==10, horizontal lcolor(blue*1.2) lwidth(medthick))	///
						(scatter x estimate if no==1, msymbol(O) mlcolor(red*1) mfcolor(red*0.6) msize(1.5) mlabel(maker1) mlabposition(5) mlabgap(*0.5) mlabsize(3)) ///
						(scatter x estimate if no==6, msymbol(O) mlcolor(red*1) mfcolor(red*0.6) msize(1.5) mlabel(maker1) mlabposition(5) mlabgap(*0.5) mlabsize(3)) ///
						(scatter x estimate if no==2, msymbol(O) mlcolor(orange_red*1) mfcolor(orange_red*0.6) msize(1.5) mlabel(maker1) mlabposition(5) mlabgap(*0.5) mlabsize(3)) ///
						(scatter x estimate if no==7, msymbol(O) mlcolor(orange_red*1) mfcolor(orange_red*0.6) msize(1.5) mlabel(maker1) mlabposition(5) mlabgap(*0.5) mlabsize(3)) ///
						(scatter x estimate if no==3, msymbol(O) mlcolor(green*1) mfcolor(green*0.6) msize(1.5) mlabel(maker1) mlabposition(5) mlabgap(*0.5) mlabsize(3)) ///
						(scatter x estimate if no==8, msymbol(O) mlcolor(green*1) mfcolor(green*0.6) msize(1.5) mlabel(maker1) mlabposition(5) mlabgap(*0.5) mlabsize(3)) ///
						(scatter x estimate if no==4, msymbol(O) mlcolor(ebblue*1) mfcolor(ebblue*0.6) msize(1.5) mlabel(maker1) mlabposition(5) mlabgap(*0.5) mlabsize(3)) ///
						(scatter x estimate if no==9, msymbol(O) mlcolor(ebblue*1) mfcolor(ebblue*0.6) msize(1.5) mlabel(maker1) mlabposition(5) mlabgap(*0.5) mlabsize(3)) ///
						(scatter x estimate if no==5, msymbol(O) mlcolor(blue*1) mfcolor(blue*0.6) msize(1.5) mlabel(maker1) mlabposition(5) mlabgap(*0.5) mlabsize(3)) ///
						(scatter x estimate if no==10, msymbol(O) mlcolor(blue*1) mfcolor(blue*0.6) msize(1.5) mlabel(maker1) mlabposition(5) mlabgap(*0.5) mlabsize(3)) ///
						,scheme(plotplain) ///
						legend(off) ///
						ysize(6.2) xsize(6.5) ///
						xline(0, lp(dash) lc(yellow*1.3) lwidth(thin)) ///
						ylabel("", valuelabel) ///
						yscale(range(0.3 5.7)) ///
						ytitle("") ///
						title("Day-to-day temperature""index variability", pos(12) size(3.2) color(black)) ///
						fysize(100) fxsize(65) ///
						yline(0.8, lp(shortdash) lc(gray*0.7) lwidth(thin)) ///
						yline(1.8, lp(shortdash) lc(gray*0.7) lwidth(thin)) ///
						yline(2.8, lp(shortdash) lc(gray*0.7) lwidth(thin)) ///
						yline(3.8, lp(shortdash) lc(gray*0.7) lwidth(thin)) ///
						yline(4.8, lp(shortdash) lc(gray*0.7) lwidth(thin)) ///
						yline(1.2, lp(shortdash) lc(gray*0.7) lwidth(thin)) ///
						yline(2.2, lp(shortdash) lc(gray*0.7) lwidth(thin)) ///
						yline(3.2, lp(shortdash) lc(gray*0.7) lwidth(thin)) ///
						yline(4.2, lp(shortdash) lc(gray*0.7) lwidth(thin)) ///
						yline(5.2, lp(shortdash) lc(gray*0.7) lwidth(thin)) ///
						xlabel(-2 (2) 6, labsize(3.15) nogrid)  
						
						graph save "$figure/fig4/fig4_10", replace

********************************************************************************


	* fig4_11
	
		cd $figure/fig4
		openall, storefilename(fn)
		keep if fn=="fig4_tn_inn.dta"
		
		* group
		split parm, p(".")
		gen no=real(parm1)
		replace no=1 if parm1=="1b"
		drop if no==.
		sort no  
		gen group=1 if no<6
		replace group=2 if no>5
		
		replace estimate=estimate*100*3.286245 if no==1
		replace min95=min95*100*3.286245 if no==1
		replace max95=max95*100*3.286245 if no==1
		
		replace estimate=estimate*100*3.641999 if no==2
		replace min95=min95*100*3.641999 if no==2
		replace max95=max95*100*3.641999 if no==2
		
		replace estimate=estimate*100*3.664354 if no==3
		replace min95=min95*100*3.664354 if no==3
		replace max95=max95*100*3.664354 if no==3
		
		replace estimate=estimate*100*3.684233 if no==4
		replace min95=min95*100*3.684233 if no==4
		replace max95=max95*100*3.684233 if no==4
		
		replace estimate=estimate*100*3.345257 if no==5
		replace min95=min95*100*3.345257 if no==5
		replace max95=max95*100*3.345257 if no==5
		
		replace estimate=estimate*100*3.095664 if no==6
		replace min95=min95*100*3.095664 if no==6
		replace max95=max95*100*3.095664 if no==6
		
		replace estimate=estimate*100*4.362622 if no==7
		replace min95=min95*100*4.362622 if no==7
		replace max95=max95*100*4.362622 if no==7
		
		replace estimate=estimate*100*3.306642 if no==8
		replace min95=min95*100*3.306642 if no==8
		replace max95=max95*100*3.306642 if no==8
		
		replace estimate=estimate*100*3.200026 if no==9
		replace min95=min95*100*3.200026 if no==9
		replace max95=max95*100*3.200026 if no==9
		
		replace estimate=estimate*100*3.42118 if no==10
		replace min95=min95*100*3.42118 if no==10
		replace max95=max95*100*3.42118 if no==10
		
		*adjust numerical scheme
		gen maker1 = estimate
		format %3.2f maker1
		gen x = 6-(no-(group-1)*5)
		replace x=x+0.2 if group==1
		replace x=x-0.2 if group==2
		
			
	    graph twoway   (rcap min95 max95 x if no==1, horizontal lcolor(red*1.2) lwidth(medthick))	///
						(rcap min95 max95 x if no==6, horizontal lcolor(red*1.2) lwidth(medthick))	///
						(rcap min95 max95 x if no==2, horizontal lcolor(orange_red*1.2) lwidth(medthick))	///
						(rcap min95 max95 x if no==7, horizontal lcolor(orange_red*1.2) lwidth(medthick))	///
						(rcap min95 max95 x if no==3, horizontal lcolor(green*1.2) lwidth(medthick))	///
						(rcap min95 max95 x if no==8, horizontal lcolor(green*1.2) lwidth(medthick))	///
						(rcap min95 max95 x if no==4, horizontal lcolor(ebblue*1.2) lwidth(medthick))	///
						(rcap min95 max95 x if no==9, horizontal lcolor(ebblue*1.2) lwidth(medthick))	///
						(rcap min95 max95 x if no==5, horizontal lcolor(blue*1.2) lwidth(medthick))	///
						(rcap min95 max95 x if no==10, horizontal lcolor(blue*1.2) lwidth(medthick))	///
						(scatter x estimate if no==1, msymbol(O) mlcolor(red*1) mfcolor(red*0.6) msize(1.5) mlabel(maker1) mlabposition(5) mlabgap(*0.5) mlabsize(3)) ///
						(scatter x estimate if no==6, msymbol(O) mlcolor(red*1) mfcolor(red*0.6) msize(1.5) mlabel(maker1) mlabposition(5) mlabgap(*0.5) mlabsize(3)) ///
						(scatter x estimate if no==2, msymbol(O) mlcolor(orange_red*1) mfcolor(orange_red*0.6) msize(1.5) mlabel(maker1) mlabposition(5) mlabgap(*0.5) mlabsize(3)) ///
						(scatter x estimate if no==7, msymbol(O) mlcolor(orange_red*1) mfcolor(orange_red*0.6) msize(1.5) mlabel(maker1) mlabposition(5) mlabgap(*0.5) mlabsize(3)) ///
						(scatter x estimate if no==3, msymbol(O) mlcolor(green*1) mfcolor(green*0.6) msize(1.5) mlabel(maker1) mlabposition(5) mlabgap(*0.5) mlabsize(3)) ///
						(scatter x estimate if no==8, msymbol(O) mlcolor(green*1) mfcolor(green*0.6) msize(1.5) mlabel(maker1) mlabposition(5) mlabgap(*0.5) mlabsize(3)) ///
						(scatter x estimate if no==4, msymbol(O) mlcolor(ebblue*1) mfcolor(ebblue*0.6) msize(1.5) mlabel(maker1) mlabposition(5) mlabgap(*0.5) mlabsize(3)) ///
						(scatter x estimate if no==9, msymbol(O) mlcolor(ebblue*1) mfcolor(ebblue*0.6) msize(1.5) mlabel(maker1) mlabposition(5) mlabgap(*0.5) mlabsize(3)) ///
						(scatter x estimate if no==5, msymbol(O) mlcolor(blue*1) mfcolor(blue*0.6) msize(1.5) mlabel(maker1) mlabposition(5) mlabgap(*0.5) mlabsize(3)) ///
						(scatter x estimate if no==10, msymbol(O) mlcolor(blue*1) mfcolor(blue*0.6) msize(1.5) mlabel(maker1) mlabposition(5) mlabgap(*0.5) mlabsize(3)) ///
						,scheme(plotplain) ///
						legend(off) ///
						ysize(6.2) xsize(6.5) ///
						xline(0, lp(dash) lc(yellow*1.3) lwidth(thin)) ///
						ylabel("", valuelabel) ///
						yscale(range(0.3 5.7)) ///
						ytitle("") ///
						title("Annual mean EHF"" ", pos(12) size(3.2) color(black)) ///
						fysize(100) fxsize(65) ///
						yline(0.8, lp(shortdash) lc(gray*0.7) lwidth(thin)) ///
						yline(1.8, lp(shortdash) lc(gray*0.7) lwidth(thin)) ///
						yline(2.8, lp(shortdash) lc(gray*0.7) lwidth(thin)) ///
						yline(3.8, lp(shortdash) lc(gray*0.7) lwidth(thin)) ///
						yline(4.8, lp(shortdash) lc(gray*0.7) lwidth(thin)) ///
						yline(1.2, lp(shortdash) lc(gray*0.7) lwidth(thin)) ///
						yline(2.2, lp(shortdash) lc(gray*0.7) lwidth(thin)) ///
						yline(3.2, lp(shortdash) lc(gray*0.7) lwidth(thin)) ///
						yline(4.2, lp(shortdash) lc(gray*0.7) lwidth(thin)) ///
						yline(5.2, lp(shortdash) lc(gray*0.7) lwidth(thin)) ///
						xlabel(-2 (2) 6, labsize(3.15) nogrid)  
						
						graph save "$figure/fig4/fig4_11", replace

********************************************************************************


	* fig4_12
	
		cd $figure/fig4
		openall, storefilename(fn)
		keep if fn=="fig4_td_inn.dta"
		
		* group
		split parm, p(".")
		gen no=real(parm1)
		replace no=1 if parm1=="1b"
		drop if no==.
		sort no  
		gen group=1 if no<6
		replace group=2 if no>5
		
		replace estimate=estimate*100*6.54791 if no==1
		replace min95=min95*100*6.54791 if no==1
		replace max95=max95*100*6.54791 if no==1
		
		replace estimate=estimate*100*7.087975 if no==2
		replace min95=min95*100*7.087975 if no==2
		replace max95=max95*100*7.087975 if no==2
		
		replace estimate=estimate*100*7.538245 if no==3
		replace min95=min95*100*7.538245 if no==3
		replace max95=max95*100*7.538245 if no==3
		
		replace estimate=estimate*100*7.746528 if no==4
		replace min95=min95*100*7.746528 if no==4
		replace max95=max95*100*7.746528 if no==4
		
		replace estimate=estimate*100*7.142036 if no==5
		replace min95=min95*100*7.142036 if no==5
		replace max95=max95*100*7.142036 if no==5
		
		replace estimate=estimate*100*6.351492 if no==6
		replace min95=min95*100*6.351492 if no==6
		replace max95=max95*100*6.351492 if no==6
		
		replace estimate=estimate*100*6.510437 if no==7
		replace min95=min95*100*6.510437 if no==7
		replace max95=max95*100*6.510437 if no==7
		
		replace estimate=estimate*100*6.467514 if no==8
		replace min95=min95*100*6.467514 if no==8
		replace max95=max95*100*6.467514 if no==8
		
		replace estimate=estimate*100*6.827972 if no==9
		replace min95=min95*100*6.827972 if no==9
		replace max95=max95*100*6.827972 if no==9
		
		replace estimate=estimate*100*6.959673 if no==10
		replace min95=min95*100*6.959673 if no==10
		replace max95=max95*100*6.959673 if no==10
		
		*adjust numerical scheme
		gen maker1 = estimate
		format %3.2f maker1
		gen x = 6-(no-(group-1)*5)
		replace x=x+0.2 if group==1
		replace x=x-0.2 if group==2
		
			
	    graph twoway   (rcap min95 max95 x if no==1, horizontal lcolor(red*1.2) lwidth(medthick))	///
						(rcap min95 max95 x if no==6, horizontal lcolor(red*1.2) lwidth(medthick))	///
						(rcap min95 max95 x if no==2, horizontal lcolor(orange_red*1.2) lwidth(medthick))	///
						(rcap min95 max95 x if no==7, horizontal lcolor(orange_red*1.2) lwidth(medthick))	///
						(rcap min95 max95 x if no==3, horizontal lcolor(green*1.2) lwidth(medthick))	///
						(rcap min95 max95 x if no==8, horizontal lcolor(green*1.2) lwidth(medthick))	///
						(rcap min95 max95 x if no==4, horizontal lcolor(ebblue*1.2) lwidth(medthick))	///
						(rcap min95 max95 x if no==9, horizontal lcolor(ebblue*1.2) lwidth(medthick))	///
						(rcap min95 max95 x if no==5, horizontal lcolor(blue*1.2) lwidth(medthick))	///
						(rcap min95 max95 x if no==10, horizontal lcolor(blue*1.2) lwidth(medthick))	///
						(scatter x estimate if no==1, msymbol(O) mlcolor(red*1) mfcolor(red*0.6) msize(1.5) mlabel(maker1) mlabposition(5) mlabgap(*0.5) mlabsize(3)) ///
						(scatter x estimate if no==6, msymbol(O) mlcolor(red*1) mfcolor(red*0.6) msize(1.5) mlabel(maker1) mlabposition(5) mlabgap(*0.5) mlabsize(3)) ///
						(scatter x estimate if no==2, msymbol(O) mlcolor(orange_red*1) mfcolor(orange_red*0.6) msize(1.5) mlabel(maker1) mlabposition(5) mlabgap(*0.5) mlabsize(3)) ///
						(scatter x estimate if no==7, msymbol(O) mlcolor(orange_red*1) mfcolor(orange_red*0.6) msize(1.5) mlabel(maker1) mlabposition(5) mlabgap(*0.5) mlabsize(3)) ///
						(scatter x estimate if no==3, msymbol(O) mlcolor(green*1) mfcolor(green*0.6) msize(1.5) mlabel(maker1) mlabposition(5) mlabgap(*0.5) mlabsize(3)) ///
						(scatter x estimate if no==8, msymbol(O) mlcolor(green*1) mfcolor(green*0.6) msize(1.5) mlabel(maker1) mlabposition(5) mlabgap(*0.5) mlabsize(3)) ///
						(scatter x estimate if no==4, msymbol(O) mlcolor(ebblue*1) mfcolor(ebblue*0.6) msize(1.5) mlabel(maker1) mlabposition(5) mlabgap(*0.5) mlabsize(3)) ///
						(scatter x estimate if no==9, msymbol(O) mlcolor(ebblue*1) mfcolor(ebblue*0.6) msize(1.5) mlabel(maker1) mlabposition(5) mlabgap(*0.5) mlabsize(3)) ///
						(scatter x estimate if no==5, msymbol(O) mlcolor(blue*1) mfcolor(blue*0.6) msize(1.5) mlabel(maker1) mlabposition(5) mlabgap(*0.5) mlabsize(3)) ///
						(scatter x estimate if no==10, msymbol(O) mlcolor(blue*1) mfcolor(blue*0.6) msize(1.5) mlabel(maker1) mlabposition(5) mlabgap(*0.5) mlabsize(3)) ///
						,scheme(plotplain) ///
						legend(off) ///
						ysize(6.2) xsize(6.5) ///
						xline(0, lp(dash) lc(yellow*1.3) lwidth(thin)) ///
						ylabel("", valuelabel) ///
						yscale(range(0.3 5.7)) ///
						ytitle("") ///
						title("Number of days with EHF>0"" ", pos(12) size(3.2) color(black)) ///
						fysize(100) fxsize(65) ///
						yline(0.8, lp(shortdash) lc(gray*0.7) lwidth(thin)) ///
						yline(1.8, lp(shortdash) lc(gray*0.7) lwidth(thin)) ///
						yline(2.8, lp(shortdash) lc(gray*0.7) lwidth(thin)) ///
						yline(3.8, lp(shortdash) lc(gray*0.7) lwidth(thin)) ///
						yline(4.8, lp(shortdash) lc(gray*0.7) lwidth(thin)) ///
						yline(1.2, lp(shortdash) lc(gray*0.7) lwidth(thin)) ///
						yline(2.2, lp(shortdash) lc(gray*0.7) lwidth(thin)) ///
						yline(3.2, lp(shortdash) lc(gray*0.7) lwidth(thin)) ///
						yline(4.2, lp(shortdash) lc(gray*0.7) lwidth(thin)) ///
						yline(5.2, lp(shortdash) lc(gray*0.7) lwidth(thin)) ///
						xlabel(-2 (2) 6, labsize(3.15) nogrid)  
						
						graph save "$figure/fig4/fig4_12", replace

********************************************************************************


		graph combine "$figure/fig4/fig4_9" "$figure/fig4/fig4_10" "$figure/fig4/fig4_11""$figure/fig4/fig4_12", ///
				graphregion(fcolor(white) lcolor(white)) imargin(small) col(4) iscale(1) fysize(150) fxsize(240) xsize(15) ysize(6)  title("            		     	             Effect on mortality risk of a 1-s.d. increase (%points)"" ", pos(6) size(3.2) color(black))
							
		graph save "$figure/fig4/fig4_s3", replace
		graph export "$figure/fig4/fig4_s3.png", replace width(10000)