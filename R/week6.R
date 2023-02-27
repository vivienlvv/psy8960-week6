# Script Settings and Resources
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
library(stringi)
library(stringr)
library(tidyverse)


# Data Import 
citations = stri_read_lines("../data/citations.txt", encoding = "WINDOWS-1252") 
citations_txt = citations[!stri_isempty(citations)]
length(citations) - length(citations_txt)
mean(str_length(citations_txt))

# Data Cleaning 
sample(citations_txt, 10) 

citations_tbl = tibble(line = 1:length(citations_txt), cite = citations_txt) %>%
  mutate(cite = str_replace_all(cite, pattern = "\"|\'", replacement = "")) %>% 
  mutate(year = str_match(cite, pattern = "\\((\\d{4})\\)\\.")[,2]) %>% 
  mutate(page_start = str_match(cite, pattern = "(\\d+)\\-\\d+")[,2]) %>% 
  mutate(perf_ref = str_detect(cite, fixed("performance", ignore = TRUE))) %>% 
  mutate(title = str_match(cite, pattern = "\\(\\d{4}\\)\\.\\s*([A-Z](?:\\(.*\\)|[^.])*)")[,2]) %>% 
  mutate(first_author = str_extract(cite, pattern = "^(?:([A-Z][\\w\\-]+,\\s[A-Z\\.\\s*]+)|([A-Z][\\w\\s]+)\\.)(?=,|\\s\\(\\d{4}\\))")) 

sum(!is.na(citations_tbl$first_author))