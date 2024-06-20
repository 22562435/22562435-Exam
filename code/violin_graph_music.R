violin_graph_music<-function(df){
    library(dplyr)
    g<-df %>%  group_by(album_name) %>%
        filter(n() >= 2) %>%
        ungroup() %>%
        ggplot() +
        aes(x = album_name, y = popularity, colour = artist, fill = artist) + # Map fill to artist
        geom_violin() +
        geom_jitter(aes(size = tempo), width = 0.1, alpha = 0.2) + # Map size to tempo and set alpha
        coord_flip() +
        theme_bw() +
        theme(legend.position = "right") +
        labs(
            title = "Song Popularity by Album for Coldplay and Metallica",
            colour = "Artist",
            fill = "Artist",
            size = "Tempo of Song:"
        ) +
        xlab("") +
        ylab("Popularity Score (out of 100)")
    return(g)
}