# Script Settings and Resources
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
library(stringi)
library(stringr)
library(tidyverse)


# Data Import 
citations = stri_read_lines("../data/citations.txt", encoding = "WINDOWS-1252") # Need to double check
citations_txt = citations[!stri_isempty(citations)]
length(citations) - length(citations_txt)
mean(str_length(citations_txt))

# Data Cleaning 
sample(citations_txt, 10) # citations or citations_txt?

citations_tbl = tibble(line = 1:length(citations_txt), cite = citations_txt) %>%
  mutate(cite = str_replace_all(cite, pattern = "\"|\'", replacement = "")) %>% # Question: why don't we need double escape
  mutate(year = str_match(cite, pattern = "\\((\\d{4})\\)\\.")[,2]) %>% # Question: Return NA if doesn't follow APA format?
  mutate(page_start = str_match(cite, pattern = "(\\d+)\\-\\d+")[,2]) %>% 
  mutate(perf_ref = str_detect(cite, fixed("performance", ignore = TRUE))) %>% 
  mutate(title = str_match(cite, pattern = "\\(\\d{4}\\)\\.\\s*([A-Z](?:\\(.*\\)|[^.])*)")[,2]) %>% # Old pattern: "\\(\\d{4}\\)\\.\\s*([A-Z][^.]*)"; still need to deal with non-period endings
  mutate(first_author = str_match(cite, pattern = "^([\\w|\\-]+,\\s(?:[A-Z]\\.\\s*)+)[,|\\s\\(\\d{4}\\)]+")[,2]) # explore non-capture and char class next time; first author old pattern = "^(\\w+,\\s(?:[A-Z]\\.\\s*)+)[,|\\s\\(\\d{4}\\)]+", new pattern matched additional 452 people
sum(!is.na(citations_tbl$first_author))