# Create SDOH Composite Index

library(tidyverse)
library(here)
library(glue)
library(readxl)
library(janitor)
library(hrbrthemes)

sdoh_file <- 
    here("data/ahrq-sdoh/SDOH_ZCTA_2018 (1).xlsx") %>% 
    readxl::read_xlsx() %>% 
    clean_names() %>% 
    as_tibble()

composite_vars <- c("acs_pct_medicaid_any64","acs_pct_uninsured64","acs_pct_work_no_car","acs_pct_hh_pub_assist",
                    "acs_pct_lt_hs")

sdoh_file %>% 
    select_at(vars(composite_vars)) %>% 
    na.omit() %>% 
    cor(.) %>% 
    data.frame() %>% 
    rownames_to_column(var = "measure") %>% 
    gather(measure2,corr,-measure) %>% 
    ggplot(aes(x=measure, y = measure2, fill = corr)) + 
    geom_tile() +
    scale_fill_gradient2(low = "black", mid = "white", high="red") + 
    scale_y_discrete(limits = rev) +
    theme_ipsum()
