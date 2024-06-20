library(glue)

plot_time_trend_of_similar_artist <- function(database, artist, variable) {
    df <- filter_artist_and_tags(database, artist)
    g <- ggplot(df, aes(x = year, y = .data[[variable]], colour = Artist)) +
        geom_point(alpha = ifelse(df$Artist == artist, 1, 0.1)) +
        geom_smooth(formula = y~x,
                    method = "loess",
                    se = TRUE) +
        scale_color_hue(direction = 1) +
        theme_bw()+
        theme(legend.position = "bottom") +
        labs(
            title = glue("Trend of {variable} for {artist} and similar artists"),
            colour = "Artist",
        ) +
        xlab("Year")+
        ylab(variable)

    suppressWarnings(return(g))
}