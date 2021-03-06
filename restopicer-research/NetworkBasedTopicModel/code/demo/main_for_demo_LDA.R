rm(list = ls(envir = globalenv()))
# not forget setwd("F:/Desktop/restopicer/restopicer-research/NetworkBasedTopicModel")
#####
# required library
#####
library(topicmodels)
load(file = "rdata/demo.RData")
source(file = "code/functions.R")
##############
# LDA on abstract demo
# http://yuedu.baidu.com/ebook/d0b441a8ccbff121dd36839a
# http://blog.csdn.net/pirage/article/details/9467547
##############
# preprocessing
data <- unique(demoPapers)
corpus <- VCorpus(VectorSource(data$abstract))
l_ply(.data = 1:length(corpus),.fun = function(i){
  meta(corpus[[i]],tag = "id") <<- data$item_ut[i]
  meta(corpus[[i]],tag = "title") <<- data$article_title[i]
  meta(corpus[[i]],tag = "cited_count") <<- data$cited_count[i]
  meta(corpus[[i]],tag = "document_type") <<- data$document_type[i]
  meta(corpus[[i]],tag = "publisher") <<- data$full_source_title[i]
  meta(corpus[[i]],tag = "publication_type") <<- data$publication_type[i]
  meta(corpus[[i]],tag = "year") <<- data$publication_year[i]
})
# fpattern <- content_transformer(function(x, pattern) gsub(pattern, "", x))
# complainCorpus <- tm_map(complainCorpus, fpattern, "z*")
corpus <- tm_map(corpus, removePunctuation)
corpus <- tm_map(corpus, removeNumbers)
corpus <- tm_map(corpus, content_transformer(tolower))
corpus <- tm_map(corpus, removeWords, stopwords("SMART"))
corpus <- tm_map(corpus, removeWords, stopwords("en"))
corpus <- tm_map(corpus, stripWhitespace)
strsplit_space_tokenizer <- function(x){
  unlist(strsplit(as.character(x), "[[:space:]]+"))
}
# control <- list(weighting = weightTf, tokenize= strsplit_space_tokenizer,
#                 tolower = TRUE, removePunctuation = TRUE, removeNumbers = TRUE, stopwords = TRUE, stemming = TRUE,
#                 dictionary = NULL, bounds = list(local = c(1, Inf)), wordLengths = c(3, Inf))
control <- list(weighting = weightTf, tokenize= words,
                tolower = TRUE, removePunctuation = TRUE, removeNumbers = TRUE, stopwords = TRUE, stemming = FALSE,
                dictionary = NULL, bounds = list(local = c(1, Inf)), wordLengths = c(3, Inf))
corpus_dtm <- DocumentTermMatrix(corpus,control)
# run LDA
k <- 10
SEED <- 2015
corpus_topic <- list(VEM = LDA(corpus_dtm, k = k, control = list(seed = SEED)),
                     Gibbs = LDA(corpus_dtm, k = k, method = "Gibbs", control = list(seed = SEED, burnin = 1000, thin = 100, iter = 1000)))
#熵值越高说明主题分布更均匀
sapply(corpus_topic,  function(x)  mean(apply(posterior(x)$topics,1,  function(z) -sum(z*log(z)))))
topic_posterior <- posterior(corpus_topic[["Gibbs"]])
# document tagging test
doc_topic <- topic_posterior$topics
taggingtest_doc_topic <- cbind(item_ut=rownames(doc_topic),as.data.frame(doc_topic))
taggingtest_doc_sc <- unique(demoPapersSubjectCategory[,c("item_ut","subject_category")])
taggingtest_data <- merge(taggingtest_doc_topic, taggingtest_doc_sc)
# plot report
doc.tagging.test(taggingtest_data = taggingtest_data,filename = "demo_LDA_abstract",path = "output/demo_LDA_abstract/document_topic",LeaveOneOut = FALSE)
# transpose = FALSE
plotBipartiteMatrixReport(filename = "demo_LDA_abstract",bi_matrix = corpus_dtm,path = "output/demo_LDA_abstract/document_term",showNamesInPlot = FALSE, weightType = "tfidf", plotRowWordCloud = TRUE, plotWordCloud = TRUE, plotRowComparison = TRUE, plotRowDist = TRUE, plotModules = FALSE)
plotBipartiteMatrixReport(filename = "demo_LDA_abstract",bi_matrix = topic_posterior$terms,path = "output/demo_LDA_abstract/topic_term",showNamesInPlot = FALSE, weightType = "tf", plotRowWordCloud = TRUE, plotWordCloud = TRUE, plotRowComparison = TRUE, plotRowDist = TRUE, plotModules = FALSE)
plotBipartiteMatrixReport(filename = "demo_LDA_abstract",bi_matrix = topic_posterior$topics,path = "output/demo_LDA_abstract/document_topic",showNamesInPlot = FALSE, weightType = "tf", plotRowWordCloud = TRUE, plotWordCloud = TRUE, plotRowComparison = TRUE, plotRowDist = TRUE, plotModules = FALSE)
# transpose = TRUE
plotBipartiteMatrixReport(filename = "demo_LDA_abstract",bi_matrix = corpus_dtm,transpose = TRUE,path = "output/demo_LDA_abstract/document_term",showNamesInPlot = FALSE, weightType = "tfidf", plotRowWordCloud = FALSE, plotWordCloud = FALSE, plotRowComparison = FALSE, plotRowDist = TRUE, plotModules = FALSE)
plotBipartiteMatrixReport(filename = "demo_LDA_abstract",bi_matrix = topic_posterior$terms,transpose = TRUE,path = "output/demo_LDA_abstract/topic_term",showNamesInPlot = FALSE, weightType = "tf", plotRowWordCloud = FALSE, plotWordCloud = FALSE, plotRowComparison = FALSE, plotRowDist = TRUE, plotModules = FALSE)
plotBipartiteMatrixReport(filename = "demo_LDA_abstract",bi_matrix = topic_posterior$topics,transpose = TRUE,path = "output/demo_LDA_abstract/document_topic",showNamesInPlot = FALSE, weightType = "tf", plotRowWordCloud = FALSE, plotWordCloud = FALSE, plotRowComparison = FALSE, plotRowDist = TRUE, plotModules = FALSE)
##############
# LDA on keywords demo
##############
# preprocessing
data <- unique(demoPapersKeywords)
bi_matrix <- table(data$item_ut,tolower(data$author_keyword))
corpus_dtm <- as.DocumentTermMatrix(bi_matrix,weighting = weightTf)
# run LDA
k <- 10
SEED <- 2015
corpus_topic <- list(VEM = LDA(corpus_dtm, k = k, control = list(seed = SEED)),
                     Gibbs = LDA(corpus_dtm, k = k, method = "Gibbs", control = list(seed = SEED, burnin = 1000, thin = 100, iter = 1000)))
#熵值越高说明主题分布更均匀
sapply(corpus_topic,  function(x)  mean(apply(posterior(x)$topics,1,  function(z) -sum(z*log(z)))))
topic_posterior <- posterior(corpus_topic[["Gibbs"]])
# document tagging test
doc_topic <- topic_posterior$topics
taggingtest_doc_topic <- cbind(item_ut=rownames(doc_topic),as.data.frame(doc_topic))
taggingtest_doc_sc <- unique(demoPapersSubjectCategory[,c("item_ut","subject_category")])
taggingtest_data <- merge(taggingtest_doc_topic, taggingtest_doc_sc)
# plot report
doc.tagging.test(taggingtest_data = taggingtest_data,filename = "demo_LDA_keyword",path = "output/demo_LDA_keyword/document_topic",LeaveOneOut = FALSE)
# transpose = FALSE
plotBipartiteMatrixReport(filename = "demo_LDA_keyword",bi_matrix = corpus_dtm,path = "output/demo_LDA_keyword/document_term",showNamesInPlot = FALSE, weightType = "tfidf", plotRowWordCloud = TRUE, plotWordCloud = TRUE, plotRowComparison = TRUE, plotRowDist = TRUE, plotModules = FALSE)
plotBipartiteMatrixReport(filename = "demo_LDA_keyword",bi_matrix = topic_posterior$terms,path = "output/demo_LDA_keyword/topic_term",showNamesInPlot = FALSE, weightType = "tf", plotRowWordCloud = TRUE, plotWordCloud = TRUE, plotRowComparison = TRUE, plotRowDist = TRUE, plotModules = FALSE)
plotBipartiteMatrixReport(filename = "demo_LDA_keyword",bi_matrix = topic_posterior$topics,path = "output/demo_LDA_keyword/document_topic",showNamesInPlot = FALSE, weightType = "tf", plotRowWordCloud = TRUE, plotWordCloud = TRUE, plotRowComparison = TRUE, plotRowDist = TRUE, plotModules = FALSE)
# transpose = TRUE
plotBipartiteMatrixReport(filename = "demo_LDA_keyword",bi_matrix = corpus_dtm,transpose = TRUE,path = "output/demo_LDA_keyword/document_term",showNamesInPlot = FALSE, weightType = "tfidf", plotRowWordCloud = FALSE, plotWordCloud = FALSE, plotRowComparison = FALSE, plotRowDist = TRUE, plotModules = FALSE)
plotBipartiteMatrixReport(filename = "demo_LDA_keyword",bi_matrix = topic_posterior$terms,transpose = TRUE,path = "output/demo_LDA_keyword/topic_term",showNamesInPlot = FALSE, weightType = "tf", plotRowWordCloud = FALSE, plotWordCloud = FALSE, plotRowComparison = FALSE, plotRowDist = TRUE, plotModules = FALSE)
plotBipartiteMatrixReport(filename = "demo_LDA_keyword",bi_matrix = topic_posterior$topics,transpose = TRUE,path = "output/demo_LDA_keyword/document_topic",showNamesInPlot = FALSE, weightType = "tf", plotRowWordCloud = FALSE, plotWordCloud = FALSE, plotRowComparison = FALSE, plotRowDist = TRUE, plotModules = FALSE)
##############
# END LDA on demo
##############