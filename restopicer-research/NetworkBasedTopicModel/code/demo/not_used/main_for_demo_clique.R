rm(list = ls(envir = globalenv()))
setwd("F:/Desktop/restopicer/restopicer-research/CoTermNetworkLinkTopicModel")
#####
# required library
#####
load(file = "rdata/demo.RData")
source(file = "code/functions.R")
##############
# Traditional Network Topic Model demo
# too slow, not used
# clique.community
##############
# preprocessing
data <- unique(demoPapersKeywords)
bi_matrix <- table(data$item_ut,tolower(data$author_keyword))
# bipartite network max compart
#bi_MaxCompart <- runMaxCompartOfMatrix(bi_matrix)
bi_MaxCompart <- bi_matrix
# bipartite from incidence matrix
bi_g <- graph_from_incidence_matrix(bi_MaxCompart)
# projecting of two side
proj_g <- bipartite_projection(bi_g, types = NULL, multiplicity = TRUE,probe1 = NULL, which = "both", remove.type = TRUE)
# run CLIQUE community
coterm_g <- proj_g[[2]]
coterm_g <- simplify(coterm_g)
cc <- clique.community(coterm_g,k = 10)
# generate topic-term matrix through community
topic_term <- getTopicMemberBipartiteMatrix(member = cc$names,community = cc$membership,weight = "binary")
# calculate similarity to get doc-topic matrix
doc_topic <- getDocTopicBipartiteMatrix(doc_member = bi_MaxCompart,topic_member = topic_term,method = "similarity.cos")
# document tagging test
taggingtest_doc_topic <- cbind(item_ut=rownames(doc_topic),as.data.frame(doc_topic))
taggingtest_doc_sc <- unique(demoPapersSubjectCategory[,c("item_ut","subject_category")])
taggingtest_data <- merge(taggingtest_doc_topic, taggingtest_doc_sc)
# plot report
doc.tagging.test(taggingtest_data = taggingtest_data,filename = "demo_CLIQUE_keyword",path = "output/demo_CLIQUE_keyword/document_topic",LeaveOneOut = FALSE)
# transpose = FALSE
plotBipartiteMatrixReport(filename = "demo_CLIQUE_keyword",bi_matrix = bi_MaxCompart,path = "output/demo_CLIQUE_keyword/document_term",showNamesInPlot = FALSE, weightType = "tfidf", plotRowWordCloud = TRUE, plotWordCloud = TRUE, plotRowComparison = TRUE, plotRowDist = TRUE, plotModules = FALSE)
plotBipartiteMatrixReport(filename = "demo_CLIQUE_keyword",bi_matrix = topic_term,path = "output/demo_CLIQUE_keyword/topic_term",showNamesInPlot = FALSE, weightType = "tf", plotRowWordCloud = TRUE, plotWordCloud = TRUE, plotRowComparison = TRUE, plotRowDist = TRUE, plotModules = FALSE)
plotBipartiteMatrixReport(filename = "demo_CLIQUE_keyword",bi_matrix = doc_topic,path = "output/demo_CLIQUE_keyword/document_topic",showNamesInPlot = FALSE, weightType = "tf", plotRowWordCloud = TRUE, plotWordCloud = TRUE, plotRowComparison = TRUE, plotRowDist = TRUE, plotModules = FALSE)
# transpose = TRUE
plotBipartiteMatrixReport(filename = "demo_CLIQUE_keyword",bi_matrix = bi_MaxCompart,transpose = TRUE,path = "output/demo_CLIQUE_keyword/document_term",showNamesInPlot = FALSE, weightType = "tfidf", plotRowWordCloud = FALSE, plotWordCloud = FALSE, plotRowComparison = FALSE, plotRowDist = TRUE, plotModules = FALSE)
plotBipartiteMatrixReport(filename = "demo_CLIQUE_keyword",bi_matrix = topic_term,transpose = TRUE,path = "output/demo_CLIQUE_keyword/topic_term",showNamesInPlot = FALSE, weightType = "tf", plotRowWordCloud = FALSE, plotWordCloud = FALSE, plotRowComparison = FALSE, plotRowDist = TRUE, plotModules = FALSE)
plotBipartiteMatrixReport(filename = "demo_CLIQUE_keyword",bi_matrix = doc_topic,transpose = TRUE,path = "output/demo_CLIQUE_keyword/document_topic",showNamesInPlot = FALSE, weightType = "tf", plotRowWordCloud = FALSE, plotWordCloud = FALSE, plotRowComparison = FALSE, plotRowDist = TRUE, plotModules = FALSE)
##############
# END TNTM-CLIQUE demo
##############
