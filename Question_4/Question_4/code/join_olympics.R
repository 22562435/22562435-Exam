join_olympics<-function(winterdf,summerdf){
    library(dplyr)
winter <- winterdf %>%
    mutate(Season = "Winter")

summer <- summerdf %>%
    mutate(Season = "Summer")

# Combine the datasets
combined <- bind_rows(winter, summer)
combined}