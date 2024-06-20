attach_simple_metal_weightings<-function(df,goldweight=4,silverweight=2,bronzeweight=1){
    newdf<-df %>%
        mutate(medal_weighting = case_when(
            Medal == "Gold" ~ goldweight ,
            Medal == "Silver" ~ silverweight ,
            TRUE ~ bronzeweight ))
return(newdf)}