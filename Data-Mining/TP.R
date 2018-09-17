#Packages
rm(list = ls(all = TRUE))
library(rpart)
library(MASS)

#Cushings data
data(Cushings)
cush <- Cushings[Cushings$Type!="u",]
cush[,3] <- factor(cush[,3],levels=c("a","b","c"))
cush.type<-cush[,3]


boxplot(cush[,1:2])
cush[,1] <- log(cush[,1])
cush[,2] <- log(cush[,2])
boxplot(cush[,1:2])


#plot the data on the lda’s
cush.lda<-lda(cush[,1:2], cush.type)
cush.pred<-predict(cush.lda, dimen=2)
plot(cush.pred$x, type="n", xlab="premier discriminant line ́aire", ylab="second discriminant line ́aire", main="LDA")
text(cush.pred$x, labels=as.character(cush.type), cex=0.8)
plot(cush[,1:2],pch=as.character(cush.type))

#tracer les fornti`eres de de ́cision
#prendre un treillis de points
#treillis de 100 par 100 - augmenter `a 200 x 200 pour des lignes plus fines L<-100
L<-100
x<-seq(1,4,3/L)
y<-seq(-3,2,5/L)
z<-as.matrix(expand.grid(Tetrahydrocortisone=x,Pregnanetriol=y))
m<-length(x)
n<-length(y)
cush.ldp<-predict(cush.lda,z)$class
#les classes sont a,b,c =1,2,3 donc on met les contours `a 1.5 et 2.5 
contour(x,y,matrix(as.numeric(cush.ldp),m,n),levels=c(1.5,2.5), add=T,d=F,lty=1,col=2)

#En quadratique
cush.qda <- qda(cush[,1:2], cush.type)
cush.qdp<-predict(cush.qda,z)$class
contour(x,y,matrix(as.numeric(cush.qdp),m,n),levels=c(1.5,2.5),
        add=T,lty=1,col=3)



##Fonction manuelle##
lda.fit <- function(y,X,prior,qda=FALSE,tol=1e-6) {
  N <- dim(X)[1]
  n <- c(table(y))
  p <- dim(X)[2]
  K <- length(unique(y))  # nombre de classes
  # taille de l’ ́echantillon
  # nombre de cas par classe
  # dimension (nombre de variables)
  # `a priori
  if(missing(prior)) prior <- n/N
  logpi <- log(prior)
  # faire une liste des donn ́ees df’apprentissage pour chaque class
  G <- split(X,y)
  for (k in 1:K) G[[k]] <- matrix(G[[k]],ncol=p)
  # statistiques pour chaque classe (moyenne et variance)
  G.mean <- as.list(as.data.frame(sapply(G,apply,2,mean)))
  G.var <- as.list(as.data.frame(sapply(G,var)))
  for (k in 1:K) G.var[[k]] <- matrix(G.var[[k]],ncol=p)*(n[k]/(n[k]-1))
  
  if(!qda) {
    T.var <- G.var[[1]]*(n[1]-1)
    for (k in 2:K) T.var <- T.var + G.var[[k]]*(n[k]-1)
    T.var <- T.var/(N-K)
    for (k in 1:K) G.var[[k]] <- T.var
  }

  logdet <- rep(NA,length=K)
  G.U <- G.var
  G.D2i <- G.var
  for (k in 1:K) {
    sv <- svd(G.var[[k]],nu=p,nv=0)
    rnk <- sum(sv$d>tol)
    if (rnk<p) {
      cat("Collin ́earite ́ dans le groupe",k,"...\n")
      stop("lda/qda ne peut pas continuer en raison de la collin ́earite ́.") }
    logdet[k] <- sum(log(sv$d))
    G.U[[k]] <- sv$u
    G.D2i[[k]] <- diag(1/sqrt(sv$d))
  }
  return(list(logpi=logpi,logdet=logdet,mu=G.mean,D2i=G.D2i,U=G.U))
}


lda.pred <- function(X,ldaf) {
  offset <- -ldaf$logdet/2 + ldaf$logpi
  mu <- ldaf$mu
  D2i <- ldaf$D2i
  U <- ldaf$U
  p <- length(mu[[1]])
  X <- matrix(c(X),ncol=p)
  N <- dim(X)[1]
  K <- length(offset)
  delta <- matrix(NA,nrow=N,ncol=K)
  for (k in 1:K) {
    Xs <- sweep(X,2,mu[[k]])%*%U[[k]]%*%D2i[[k]]
    delta[,k] <- offset[k] - diag(Xs%*%t(Xs))/2
  }
  return(list(delta=delta,class=apply(-delta,1,order)[1,]))
}

##Jeu de donnees artificielles##
par(mfrow=c(1,1))
x1 <- rnorm(100,1,.5)
x2 <- rnorm(100,2,.25)
y1 <- rnorm(100,1,.5)
y2 <- rnorm(100,2,.25)
y <- c(rep(-1,100),rep(1,100))
X <- cbind(c(x1,x2),c(y1,y2))
minx <- min(X[,1])
maxx <- max(X[,1])
miny <- min(X[,2])
maxy <- max(X[,2])
xx <- seq(minx,maxx,length=50)
yy <- seq(miny,maxy,length=length(xx))
plot(X,col=(y+1)/2+2)

X.fit <- lda.fit(y,X,prior=c(1,1)/2)
print((X.pred <- lda.pred(X,X.fit))$class)
print(sum((y+1)/2+1 != X.pred$class)/length(y))


plot(X,col=(y+1)/2+2,xlab="",ylab="",pch=15,main="lda, orig features")
title(xlab=paste("err rate =",sum((y+1)/2+1 != X.pred$class)/length(y)))
for (i in 1:length(xx)) {
  for (j in 1:length(yy)) {
    class <- lda.pred(c(xx[i],yy[j]),X.fit)$class
    points(xx[i],yy[j],col=class+1,pch="+")
  }
}

#QDA

Xq.fit <- lda.fit(y,X,prior=c(1,1)/2,qda=T)
print((Xq.pred <- lda.pred(X,Xq.fit))$class)
print(sum((y+1)/2+1 != Xq.pred$class)/length(y))
plot(X,col=(y+1)/2+2,xlab="",ylab="",pch=15,main="qda, orig features")
title(xlab=paste("err rate =",sum((y+1)/2+1 != Xq.pred$class)/length(y)))
for (i in 1:length(xx)) {
  for (j in 1:length(yy)) {
    class <- lda.pred(c(xx[i],yy[j]),Xq.fit)$class
    points(xx[i],yy[j],col=class+1,pch="+")
  }
}