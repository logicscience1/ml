#ver1.0 17/2/2019 #https://eight2late.wordpress.com/2015/05/27/a-gentle-introduction-to-text-mining-using-r/
#ver2.0 /// update i to output plots to file automatically
#ver3.0 /// uodate ii to loop and name variable identifiers on plots to show difference in plots by month for example
#ver4.0 /// update iii to output relationship frequency between high ranking words for 2, 3 and 4 word phrases.

#setup your environment

getwd()
setwd("C:/Users/progr/OneDrive/AIML/textanalysis")
#this contains worklogs for q4 2018
library(tm)


#Create Corpus
docs <- Corpus(DirSource("C:/Users/progr/OneDrive/AIML/textanalysis"))

#uncomment
#docs
#summary(docs)


#inspect a particular document (number 4) and transform it
#writeLines(as.character(docs[[4]]))
#getTransformations()

#create the toSpace content transformer
toSpace <- content_transformer(function(x, pattern) {return (gsub(pattern, " ", x))})
docs <- tm_map(docs, toSpace, "-")
#Remove punctuation - replace punctuation marks with " "
docs <- tm_map(docs, removePunctuation)
#Transform to lower case (need to wrap in content_transformer)
docs <- tm_map(docs,content_transformer(tolower))
#Strip digits (std transformation, so no need for content_transformer)
docs <- tm_map(docs, removeNumbers)
#remove stopwords using the standard list in tm
docs <- tm_map(docs, removeWords, stopwords("english"))
#Strip whitespace (cosmetic?)
docs <- tm_map(docs, stripWhitespace)
dtm <- DocumentTermMatrix(docs)
#dtm
#inspect(dtm[1:1,1000:1005])
freqr <- colSums(as.matrix(dtm))
#length should be total number of terms
length(freqr)
ord <- order(freqr,decreasing=TRUE)
#inspect most frequently occurring terms
#freqr[head(ord)]
#inspect least frequently occurring terms
#freqr[tail(ord)]
#reduces down to words between 4 and 20 letters (can be expanded to include a range of documents 
dtmr <-DocumentTermMatrix(docs, control=list(wordLengths=c(4, 20)))
#dtmr

#ver4.0 /// update iii to output relationship frequency between high ranking words for 2, 3 and 4 word phrases.
#findFreqTerms(dtmr,lowfreq=80)
#findAssocs(dtmr,"engineer",0.6) doesnt seem to work

wf=data.frame(term=names(freqr),occurrences=freqr)
library(ggplot2)
p <- ggplot(subset(wf, freqr>700), aes(term, occurrences))
p <- p + geom_bar(stat="identity")
p <- p + theme(axis.text.x=element_text(angle=45, hjust=1))
p
#wordcloud
library(wordcloud)
#setting the same seed each time ensures consistent look across clouds
set.seed(12)
#limit words by specifying min frequency
wordcloud(names(freqr),freqr, min.freq=800)
#.add color
wordcloud(names(freqr),freqr,min.freq=800,colors=brewer.pal(6,"Dark2"))

#clear memory and restart R
rm(list = ls())
.rs.restartR()
