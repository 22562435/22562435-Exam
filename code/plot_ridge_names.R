plot_ridge_names<-function(df){
    library(ggplot2)
    suppressMessages(library(ggridges))
    g<- df %>%  ggplot( aes(x = Year_current, y = Name, height = Total_Count_current, group = Name, fill = Name)) +
        geom_density_ridges(stat = "identity", scale =5 , rel_min_height = 0,, alpha = 0.5) +
        scale_fill_hue(direction = 1) +
        theme_bw() +
        guides(fill = "none") +
        labs(
            title = "Popularity of Names Over Time",
            x = "",
            y = "Total Instances",
            legend="none"
        )

    return(g)}