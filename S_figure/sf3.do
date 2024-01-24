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
global graph_opts1 ///
  title(, justification(left) color(black) span position(11)) ///
  graphregion(color(white) lcolor(white) lalign(center)) ///
  ylabel(,angle(0) nogrid labsize(3.2))  ///
  yscale(noline) legend(region(lcolor(none) fcolor(none)))

********************************************************************************
*
* SF3: The distribution of average daily temperature
*
********************************************************************************

	* figure sf3_1
		use "$data/example.dta", clear
		 
			superscatter mean_day1 mean_day2 ///
				,scheme(plotplain) ///
				percent means color(eltblue*0.6) lcolor(eltblue*0.9) fi(30) ///
				msize(0.8) color(red*0.5) ///
				legend(off) ///
				xtitle("Daily mean temperature in Hebei (℃)") ///
				ytitle("Daily mean temperature in Yunnan (℃)") ///
				title(" ") ///
				xscale(range(-30 30))  xlabel(-30 (10) 30) ///
				yscale(range(-20 20))  ylabel(-20 (10) 20) ///
				text(-19 -27.5 "2815", size(3.5)) ///
				text(-19  27.5 "356", size(3.5)) ///
				text(19 27.5 "3148", size(3.5)) ///
				text(19 -27.5 "254", size(3.5)) ///
				text(-19 11 "7.44",color(red) size(3.5) ) ///
				text(9 -27.5 "7.42",color(red) size(3.5) ) 

				
				graph save "$figure/sf3/sf3_1", replace
				graph export "$figure/sf3/sf3_1.png", replace width(16000)
				
********************************************************************************

	* figure sf3_2
		use "$data/example.dta", clear
		 
			superscatter max_day1 max_day2 ///
				,scheme(plotplain) ///
				percent means color(eltblue*0.6) lcolor(eltblue*0.9) fi(30) ///
				msize(0.8) color(red*0.5) ///
				legend(off) ///
				xtitle("Daily max temperature in Hebei (℃)") ///
				ytitle("Daily max temperature in Yunnan (℃)") ///
				title(" ") ///
				xscale(range(-20 40))  xlabel(-20 (10) 40) ///
				yscale(range(-10 30))  ylabel(-10 (10) 30) ///
				text(-9 -20 "2606", size(3.5)) ///
				text(-9  37 "467", size(3.5)) ///
				text(29 37 "3079", size(3.5)) ///
				text(29 -20 "421", size(3.5)) ///
				text(-9 16.5 "12.76",color(red) size(3.5) ) ///
				text(13.5 -20 "12.03",color(red) size(3.5) ) 

				
				graph save "$figure/sf3/sf3_2", replace
				graph export "$figure/sf3/sf3_2.png", replace width(16000)
				
********************************************************************************

	* figure sf3_3
		use "$data/example.dta", clear
		 
			superscatter min_day1 min_day2 ///
				,scheme(plotplain) ///
				percent means color(eltblue*0.6) lcolor(eltblue*0.9) fi(30) ///
				msize(0.8) color(red*0.5) ///
				legend(off) ///
				xtitle("Daily min temperature in Hebei (℃)") ///
				ytitle("Daily min temperature in Yunnan (℃)") ///
				title(" ") ///
				xscale(range(-30 20))  xlabel(-30 (10) 20) ///
				yscale(range(-20 20))  ylabel(-20 (10) 20) ///
				text(-21 -28 "2879", size(3.5)) ///
				text(-21  21 "366", size(3.5)) ///
				text(19 21 "3131", size(3.5)) ///
				text(19 -28 "197", size(3.5)) ///
				text(-21 5 "2.24",color(red) size(3.5) ) ///
				text(4.5 -28 "3.04",color(red) size(3.5) ) 

				
				graph save "$figure/sf3/sf3_3", replace
				graph export "$figure/sf3/sf3_3.png", replace width(16000)
				
********************************************************************************

	
