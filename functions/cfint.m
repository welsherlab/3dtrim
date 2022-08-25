function C=cfint(N,alpha)
%this function caclulates the confidence interval for changepoint
%analysis

b=2*log(log(N))+log(log(log(N)));
a=sqrt(2*log(log(N)));
C=(b-log(-0.5*log(alpha)))/a;




