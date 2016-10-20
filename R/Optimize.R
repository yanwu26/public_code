
##install packages if running for the first time
##
##
#options(repos='http://cran.rstudio.com/')
#install.packages(c("dplyr", "reshape2", "ggplot2", "leaps", "lubridate"))
#install.packages(c("glmnet", "mgcv", "hexbin", "maps", "ggthemes"))
#install.packages(c("mapproj", "RColorBrewer", "scales","IBrokers"))
#install.packages(c("quantmod","PerformanceAnalytics"))
#install.packages("lubridate")
#install.packages("stockPortfolio")
#install.packages("quandprog")
##update packages
update.packages(checkBuilt = TRUE, ask=FALSE)

##open librarieslibrary("ggplot2")
library("maps")
library("RColorBrewer")
library("ggthemes")
library("quantmod")
library("stockPortfolio")
library("PerformanceAnalytics")
library("plyr")
library("dplyr")
library("lubridate")
library("xts")
library("reshape2")
library("stringr")
library("magrittr")
library("grid")
library("quantprog")

ticker_ls<-readLines('C:/Users/ywu/Google Drive/Future/Sample/Optimizer/tickers.csv')

n<-length(ticker_ls)
start_dt<-today()-365

##download data
for(ticker in ticker_ls)
{
  print(ticker) 
  # get data from yahoo finance
  # get from xts format to frame to data table format for easier useage
  px_tbl_1<-as.data.frame(getSymbols(ticker,from=start_dt, auto.assign=F))
  px_tbl_1$ticker<-ticker
  px_tbl_1$asof_dt<-ymd(rownames(px_tbl_1))
  names(px_tbl_1)<-c("px_open","px_high","px_low","px_last","volume","px_adj","ticker","asof_dt")
  px_tbl_1<-px_tbl_1[c("asof_dt","ticker","px_open","px_high","px_low","px_last","volume","px_adj")]
  ##combine tables
  px_tbl<-rbind(px_tbl,px_tbl_1)
}


##calculate return
px_tbl_ret<-px_tbl
  px_tbl_ret<-ddply(px_tbl_ret, "ticker", transform,  DeltaCol = Delt(px_adj))    
names(px_tbl_ret)[names(px_tbl_ret) == 'Delt.1.arithmetic'] <- 'ret'
ret<-px_tbl_ret[c("asof_dt","ticker","ret")]
ret<-na.omit(ret) #remove NA
ret_mat<-dcast(ret, asof_dt~ ticker, value.var = "ret")

mu.vec<-colMeans(ret_mat[-1]) ##return averages
sigma.mat<-cov(ret_mat[-1])   ##covariance matrix
names(mu.vec) = asset.names 
dimnames(sigma.mat) = list(ticker_ls, ticker_ls)

#Equal Weighted Portfolio
x.vec = rep(1,n)/n                       #weights
  names(x.vec) = ticker_ls                 #names
  mu.p.x = crossprod(x.vec,mu.vec)         #weights times average return
  sig2.p.x = t(x.vec)%*%sigma.mat%*%x.vec  #weights times the covariance matrix times weights
  sig.p.x = sqrt(sig2.p.x)
  mu.p.x
  sig.p.x

  
#solving a mean variance portfolio:
top.mat = cbind(2*sigma.mat, rep(1, n))
  bot.vec = c(rep(1, n), 0)
  Am.mat = rbind(top.mat, bot.vec)
  b.vec = c(rep(0, n), 1)
  z.m.mat = solve(Am.mat)%*%b.vec
  m.vec = z.m.mat[1:n,1]
  m.vec

#return of portfolio:  
mu.gmin = as.numeric(crossprod(m.vec, mu.vec))
sig2.gmin=t(m.vec)%*%sigma.mat%*%m.vec
sig.gmin = sqrt(sig2.gmin)

mu.gmin
sig2.gmin

a = seq(from=1, to=-1, by=-0.1)
n.a = length(a)
z.mat = matrix(0, n.a, 3)
mu.z = rep(0, n.a)
sig2.z = rep(0, n.a)
sig.mx = t(m)%*%sigma.mat%*%x.vec
for (i in 1:n.a) {
   z.mat[i, ] = a[i]*m + (1-a[i])*x.vec
   mu.z[i] = a[i]*mu.gmin + (1-a[i])*mu.px
   sig2.z[i] = a[i]^2 * sig2.gmin + (1-a[i])^2 * sig2.px + 2*a[i]*(1-a[i])*sig.mx
   }
plot(sqrt(sig2.z), mu.z, type="b", ylim=c(0, 0.06), xlim=c(0, 0.17),
        pch=16, col="blue", ylab=expression(mu[p]),
        xlab=expression(sigma[p]))
text(sig.gmin, mu.gmin, labels="Global min", pos=4)
text(sd.vec, mu.vec, labels=asset.names, pos=4)


