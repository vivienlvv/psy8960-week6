# Script Settings and Resources
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
library(stringi)
library(stringr)



# Data Import 
citations = stri_read_lines("../data/citations.txt", encoding = "WINDOWS-1252") # Need to double check
citations_txt = citations[!stri_isempty(citations)]
length(citations) - length(citations_txt)
mean(str_length(citations_txt))