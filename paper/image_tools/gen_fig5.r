# -- Figure 5 : compilation of different tests --

library(TDA)
library(scatterplot3d)
source('tools.r')
source('process_eagle.r')
source('euler.r')

# a) point cloud

res <- 0.5
perturb <- 1
N <- 10000
boxlim <- c(0, 20)

Xlim <- boxlim
Ylim <- boxlim
Zlim <- boxlim

vf<- voronoi3d(boxlim, 
               res, 
               perturb, 
               Ncells=64, 
               N, 
               percClutter=0, 
               percWall=1-0.02-percFil, 
               percFil=percFil, 
               percClust=0.02)

pdf(paste('figure_5_plot.pdf'))
scatterplot3d(data[i], 
              xlab='X Axis', 
              ylab='Y Axis', 
              zlab='Z Axis', 
              pch='.',
              color=rgb(0, 0, 0, 0.01),
              cex.axis=1.5,
              cex.lab=2)
dev.off()

# b) persistence diagram
diag <- gridDiag(vf, 
                 dtm, 
                 lim=cbind(Xlim,Ylim,Zlim), 
                 by=res, 
                 sublevel=T, 
                 printProgress=T, 
                 m0=0.001)
diag <- cleanDiag(diag)
X <- diag$diagram

pdf(paste('figure_5_pd.pdf'))
mar.default <- c(5,4,4,2) + 0.1
par(mar = mar.default + c(0, 1, 0, 0)) 
plot(X[,2], 
     X[,3], 
     pch = c(X[,1]+1), 
     col = c(X[,1]+1), 
     xlab = 'Death', 
     ylab = 'Birth', 
     main = '', 
     cex.lab=2.0, 
     cex.axis=2.0, 
     cex.main=2.0, 
     cex.sub=2.0, 
     cex=2.0, 
     xlim=c(0,0.30), 
     ylim=c(0,0.30))
abline(a = 0, b = 1)
legend('bottomright', 
       c('0','1','2'), 
       pch = c(1,2,3), 
       col = c(1,2,3), 
       cex=2.0)
dev.off()

# c) euler characteristics
diag <- gridDiag(vf, 
                 dtm, 
                 lim=cbind(Xlim,Ylim,Zlim), 
                 by=res, 
                 sublevel=T, 
                 printProgress=T, 
                 m0=0.001)
# no removal of extra pt
diagram <- diag$diagram
tseq <- seq(min(diagram[,2:3]),
            max(diagram[,2:3]),
            length=5000)

euler <- eulerChar(tseq, 
                   diagram, 
                   maxdimension=max(diagram[,1]), 
                   threshold=0)

pdf('figure_5_euler.pdf')
plot(euler,
     type="l", 
     lwd=3,
     col="cornflowerblue",
     xlab="Grid Sequence", 
     ylab="Euler Char.",
     cex.lab=2.0, 
     cex.axis=2.0, 
     cex.main=2.0, 
     cex.sub=2.0, 
     cex=2.0)
dev.off()

# d) silhouette function
tseq <- seq(min(diagram[,2:3]), 
            max(diagram[,2:3]), 
            length=1000)

silh <- silhouette(diagram, 
                   p=1, 
                   dimension=2, 
                   tseq)

pdf('figure_5_silhouette.pdf')
plot(abs(silh),
     type="l", 
     lwd=3,
     col="cornflowerblue",
     xlab="Grid Sequence", 
     ylab="Silhouette Func.",
     cex.lab=2.0, 
     cex.axis=2.0, 
     cex.main=2.0, 
     cex.sub=2.0, 
     cex=2.0)
dev.off()
