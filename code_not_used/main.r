library(igraph)
library(ggplot2)
year<-1994
pattern <- paste(year,'-*-*', sep = "")
group <- grep(pattern, Cit.HepPh.WithDates.WellCited[,2], 
              ignore.case = FALSE, perl = FALSE, value = FALSE, 
              fixed = FALSE, useBytes = FALSE, invert = FALSE)
graphDY<-Cit.HepPh.WithDates.WellCited[group,c(1,3)]
#graphDY<-rbind(graphD,Cit.HepPh.WithDates.WellCited[Cit.HepPh.WithDates.WellCited$V3==wellcited[1],c(1,3)])
gg <- graph.data.frame(d = graphDY, directed = T)
is.simple(gg)
gg <- simplify(gg)
par(mar = c(0, 0, 0, 0))
set.seed(23)
# plot(gg, layout = layout.fruchterman.reingold, 
#      vertex.size = 3,vertex.label.cex=0.5, vertex.label=NA,
#      edge.color = grey(0.5), edge.arrow.mode = "->",edge.arrow.size=0.2)

is.connected(gg, mode=c("weak"))
gc<-clusters(gg, mode=c("weak"))
V(gg)$sg = gc$membership
V(gg)$color = rainbow(max(V(gg)$sg))[V(gg)$sg]
plot(gg, layout = layout.fruchterman.reingold, 
     vertex.size = 3,vertex.label.cex=0.5, vertex.label=NA,
     edge.color = grey(0.5), edge.arrow.mode = "->",edge.arrow.size=0.2)

comps <- decompose.graph(gg,max.comps=1,min.vertices=max(gc$csize))
g<-comps[[1]]
plot(g, layout = layout.fruchterman.reingold, 
     vertex.size = 3,vertex.label.cex=0.5, vertex.label=NA,
     edge.color = grey(0.5), edge.arrow.mode = "->",edge.arrow.size=0.2)

