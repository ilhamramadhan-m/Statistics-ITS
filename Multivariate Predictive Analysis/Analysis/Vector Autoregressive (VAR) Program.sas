/*Import Dataset*/
proc import datafile='/home/u63990176/Dataset.xlsx'
    out=data
    dbms=xlsx
    replace;
    getnames=yes;
run;

/*Time Series plot US Dollar Index (DXY)*/
proc sgplot data=data;
   title "Time Series Plot of DXY";
   series x=Date y=DXY / lineattrs=(color=blue thickness=2);
   xaxis label="Date";
   yaxis label="US Dollar Index (DXY)";
run;

/*Time Series plot EUR/USD Exchange Rate*/
proc sgplot data=data;
   title "Time Series Plot of EUR/USD";
   series x=Date y=EUR_USD / lineattrs=(color=green thickness=2);
   xaxis label="Date";
   yaxis label="EUR/USD Exchange Rate";
run;

/*MACF MPACF*/
proc statespace data=data;
   var T_DXY T_EUR_USD;
run;

/*MACF MPACF Differencing*/
proc statespace data=data;
   var T_DXY(1) T_EUR_USD(1);
run;

/*Vector Autoregressive modelling*/
proc varmax data=data;
  model T_DXY T_EUR_USD/ p=3 dftest dify(1) noint 
  	method=ls print=(corry parcoef pcorr);
  causal group1=(T_DXY) group2=(T_EUR_USD);
  causal group1=(T_EUR_USD) group2=(T_DXY);
  restrict AR(1,1,2)=0,AR(2,2,2)=0,AR(2,2,1)=0,AR(2,1,1)=0,AR(1,2,2)=0,AR(1,2,1)=0,AR(1,1,1)=0,AR(2,1,2)=0;
	output lead = 6 out = hasil;
run;

/*Print Fitting VAR Model*/
proc print data = hasil;                                                                                                                
run;

/*White Noise Residual Checking*/
proc arima data=hasil;
   identify var=RES1 nlag=24;
run;

proc arima data=hasil;
   identify var=RES2 nlag=24;
run;

/*ARCH Evaluation*/
proc autoreg data=hasil;
   model RES1 = / archtest;
   model RES2 = / archtest;
run;

/*MAPE RMSE Evaluation*/
data eval;
   set hasil;
   abs_err1 = abs(RES1);
   abs_err2 = abs(RES2);
   sq_err1  = RES1**2;
   sq_err2  = RES2**2;
   ape1 = abs(RES1) / FOR1;
   ape2 = abs(RES2) / FOR2;
run;

proc means data=eval noprint;
   var sq_err1 sq_err2 ape1 ape2;
   output out=metrics 
     mean= mse1 mse2 mape1 mape2;
run;

data metrics_final;
   set metrics;
   RMSE_DXY = sqrt(mse1);
   RMSE_EUR = sqrt(mse2);
   MAPE_DXY = mape1 * 100;
   MAPE_EUR = mape2 * 100;
   keep RMSE_DXY RMSE_EUR MAPE_DXY MAPE_EUR;
run;

proc print data=metrics_final label;
   label RMSE_DXY = 'RMSE DXY'
         RMSE_EUR = 'RMSE EUR/USD'
         MAPE_DXY = 'MAPE DXY (%)'
         MAPE_EUR = 'MAPE EUR/USD (%)';
run;

/*Inverse Transform*/
data hasil_inverse;
   set hasil;
   merge hasil data(keep=Date);
   DXY_hat = sqrt(10000 / FOR1);
   EUR_USD_hat = sqrt(FOR2);
run;

data plot_asli;
   merge data(keep=Date DXY EUR_USD) hasil_inverse;
run;

/*Plot Data Actual & Fit*/
proc sgplot data=plot_asli;
   title "Comparison: Actual vs Inverse-Fitted DXY";
   series x=Date y=DXY / lineattrs=(color=blue) legendlabel="Actual DXY";
   series x=Date y=DXY_hat / lineattrs=(color=red pattern=shortdash) legendlabel="Inverse-Fitted DXY";
   xaxis label="Date";
   yaxis label="US Dollar Index";
   keylegend / position=bottomright across=1;
run;

proc sgplot data=plot_asli;
   title "Comparison: Actual vs Inverse-Fitted EUR/USD";
   series x=Date y=EUR_USD / lineattrs=(color=green) legendlabel="Actual EUR/USD";
   series x=Date y=EUR_USD_hat / lineattrs=(color=red pattern=shortdash) legendlabel="Inverse-Fitted EUR/USD";
   xaxis label="Date";
   yaxis label="EUR/USD Exchange Rate";
   keylegend / position=bottomright across=1;
run;

/*Plot Forecast 6 period*/
data hasil_fore;
   set plot_asli;
   obs = _N_;
run;

proc sgplot data=hasil_fore;
   title "Actual, Fitted, and Forecast Plot - DXY (Original Scale)";
   series x=obs y=DXY / lineattrs=(color=blue) legendlabel="Actual DXY";
   series x=obs y=DXY_hat / lineattrs=(color=red) legendlabel="Fitted & Forecast DXY";
   xaxis label="Observation Number";
   yaxis label="US Dollar Index";
   keylegend / position=bottomright across=1;
run;

proc sgplot data=hasil_fore;
   title "Actual, Fitted, and Forecast Plot - EUR/USD (Original Scale)";
   series x=obs y=EUR_USD / lineattrs=(color=green) legendlabel="Actual EUR/USD";
   series x=obs y=EUR_USD_hat / lineattrs=(color=red) legendlabel="Fitted & Forecast EUR/USD";
   xaxis label="Observation Number";
   yaxis label="EUR/USD Exchange Rate";
   keylegend / position=bottomright across=1;
run;

/*Export*/
proc export data=hasil_inverse
    outfile='/home/u63990176/Hasil_VAR.csv'
    dbms=csv
    replace;
run;
