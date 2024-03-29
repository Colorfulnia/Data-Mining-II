
*-------------------------------------------------------------------------;
* Project        : Homework 01                                            ;
* Developer(s)   : Yueyang Tao,10458455                                   ;
* Comments       : PCA Iris dataset                                       ;
*-------------------------------------------------------------------------;

* initalize the data ;
proc copy in=sashelp out=work;
   select iris ;
run;

title "Principal Component Analysis"; 
title2 " Univariate Analysis"; 
proc univariate data=iris;
   var PetalWidth PetalLength;
run;
title " "; 
title2 " ";
proc sgplot data= iris ;
  scatter     x=PetalWidth   y=PetalLength; 
run;

*** Normalize the data ***;
PROC STANDARD DATA=iris(keep= species  SepalLength  SepalWidth PetalLength PetalWidth)
              MEAN=0 STD=1 
             OUT=iris_z(rename=(SepalLength=SepalLength_z SepalWidth=SepalWidth_z  
                      PetalLength=PetalLength_z PetalWidth=PetalWidth_z));
  VAR  SepalLength  SepalWidth PetalWidth PetalLength ;
RUN;


*** calculate corrolations between variables ***;
title "Principal Component Analysis"; 
title2 " corrolation between variables"; 
proc corr data=iris_z cov; 
var SepalLength_z SepalWidth_z PetalLength_z PetalWidth_z;
run;

title "Principal Component Analysis"; 
title2 " Plot of the normalized data"; 
proc sgplot data=iris_z ;
  scatter     x= PetalWidth_z y=PetalLength_z;
  ellipse     x= PetalWidth_z y=PetalLength_z; ;
   
run;
title " "; 
title2 " "; 




proc princomp   data=iris_z  out=iris_pca_out;
   var  PetalWidth_z  PetalLength_z  ;
run;

data iris_z2;
  set iris_z;
     compz_1=0.707107*PetalWidth_z+0.707107*PetalLength_z;
     compz_2=0.707107*PetalWidth_z-0.707107*PetalLength_z;
run;



title "Principal Component Analysis"; 
title2 " corrolation between components"; 
proc corr data=iris_z2; 
var  compz_1  compz_2;
run;
title "Principal Component Analysis"; 
title2 " Plot of the normalized data"; 
proc sgplot data=iris_z2 ;
  scatter     x=compz_1   y=compz_2 ;
  ellipse     x=compz_1  y=compz_2 ;
   
run;

** creat an output dataset with scores **;

proc princomp   data=iris_z  out=pca_petal;
   var  PetalWidth_z  PetalLength_z  ;
run;


title "Principal Component Analysis"; 
title2 " corrolation between components"; 
proc corr data=pca_petal ; 
var      prin1 prin2;
run;


proc sgplot data=pca_petal  ;
  scatter     x= Prin1  y=SepalLength ;  
run;
proc sgplot data= pca_petal;
  hbox  Prin1   / category=species  ;
run;


title "Principal Component Analysis"; 
title2 " corrolation between components"; 
proc corr data=pca_petal; 
var    Prin1  Prin2 ;
run;
ods graphics on;
proc corr data=pca_petal; 
var    Prin1  Prin2 ;
run;
ods graphics off;


libname sasdata "O:\CS-593\mysasdata";
run;

proc copy in=work out=sasdata;
  select  pca_petal ;
run;

