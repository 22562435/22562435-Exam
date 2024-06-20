plot_sport_points_gdpandmedals<-function(df){
    g<-df %>%
        ggplot() +
        aes(x = `GDP per Capita`, y = Medals, color = Sport) +
        geom_point(size=3,alpha=0.5) +
        labs(title = "Medals Won by logged GDP per Capita",
             x = "Logged GDP per Capita",
             y = "Number of Medals",
             subtitle="A visual analysis on the role wealth has on sport selection") +
        theme_bw()+
        theme(legend.position = "right")


    return(g)
}