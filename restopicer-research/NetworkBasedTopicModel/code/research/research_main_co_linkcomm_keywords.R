rm(list = ls(envir = globalenv()))
# not forget setwd("F:/Desktop/restopicer/restopicer-research/NetworkBasedTopicModel")
#####
# required data
#####
load(file = "rdata/research_2011_2013.RData")
# if no data, pls run
# fetchdata(from_year = 2009,to_year = 2013)
#####
# required methods
#####
source("code/methods.R")
foldername <- "research_2011_2013"
plotPath=paste("output",foldername,sep="/")
addPersistentObjects("plotPath")
addPersistentObjects("foldername")
#####
# method:co_linkcomm
# parameter:
## datatype: keywords
## topic_term_weight: evcent
## doc_topic_method: cos/ginv
#####
rmTempObject()
result_linkcomm_evcent_cos <- topicDiscovery.linkcomm(data = researchPapersKeywords,datatype = "keywords",MST_Threshold = 0,cutat = NULL,topic_term_weight = "evcent",doc_topic_method = "similarity.cos",plotPath,plotReport = F,papers_tags_df = researchPapersSubjectCategory,link_similarity_method="original")
save(result_linkcomm_evcent_cos,file = paste("rdata/",foldername,"/result_linkcomm.RData",sep=""))
#####
# method:co_linkcomm.percolation
# parameter:
## datatype: keywords
## percolation_threshold: 
## topic_term_weight: evcent
## doc_topic_method: cos/ginv
#####
rmTempObject()
for(th in seq(from = 0.05,to = 1.00,by = 0.05)){
  result_linkcomm.percolation_evcent_cos <- topicDiscovery.linkcomm.percolation(data = researchPapersKeywords,datatype = "keywords",MST_Threshold = 0,percolation_threshold=th,cutat = NULL,topic_term_weight = "evcent",doc_topic_method = "similarity.cos",plotPath,plotReport = F,papers_tags_df = researchPapersSubjectCategory,link_similarity_method="original")
  save(result_linkcomm.percolation_evcent_cos,
       file = paste("rdata/",foldername,"/result_linkcomm_th=",th,"_percolation.RData",sep=""))
}
# rmTempObject()
# for(cutat in c(20,40,60,80,100)){
#   result_linkcomm.percolation_evcent_cos <- topicDiscovery.linkcomm.percolation(data = researchPapersKeywords,datatype = "keywords",MST_Threshold = 0,percolation_threshold=0,cutat = cutat,topic_term_weight = "evcent",doc_topic_method = "similarity.cos",plotPath,plotReport = F,papers_tags_df = researchPapersSubjectCategory,link_similarity_method="original")
#   result_linkcomm.percolation_evcent_ginv <- topicDiscovery.linkcomm.percolation(data = researchPapersKeywords,datatype = "keywords",MST_Threshold = 0,percolation_threshold=0,cutat = cutat,topic_term_weight = "evcent",doc_topic_method = "Moore-Penrose",plotPath,plotReport = F,papers_tags_df = researchPapersSubjectCategory,link_similarity_method="original")
#   save(result_linkcomm.percolation_evcent_cos,result_linkcomm.percolation_evcent_ginv,
#        file = paste("rdata/",foldername,"/result_linkcomm_cutat=",cutat,"_percolation.RData",sep=""))
# }
#####
# END
#####