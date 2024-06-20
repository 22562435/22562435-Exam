library(ggplot2)
library(dplyr)

plot_olympics_points <- function(df) {
    south_america_codes <- c("ARG", "BOL", "BRA", "CHL", "COL", "ECU", "GUY", "PRY", "PER", "SUR", "URY", "VEN")
    custom_colors <- c("India" = "blue", "South America" = "#FF8C00", "Rest of the World" = "grey")

    p <- df %>%
        # Add region variable for graphing purposes
        mutate(region = case_when(
            Country == "IND" ~ "India",
            Country %in% south_america_codes ~ "South America",
            TRUE ~ "Rest of the World"
        )) %>%
        ggplot() +
        aes(x = log(`GDP per Capita`), y = log(Medals), size = Population, colour = region, label = Country) +
        geom_point(alpha = 0.5) +
        geom_text(
            data = . %>% filter(log(Medals) > 3.2 & log(`GDP per Capita`) < 9.5),  # punching above weight criteria
            hjust = -0.1, vjust = 0.5, size = 3, nudge_x = 0.1, check_overlap = TRUE
        ) +  # Adjusting text placement and size to not be on top
        theme_bw() +
        guides(size = "none") +
        facet_wrap(vars(Season), scales = "free") +
        scale_colour_manual(
            values = custom_colors,
            labels = c("India", "South America", "Rest of the World")  #
        ) +  #
        theme(
            legend.position = "bottom",
            legend.title = element_blank(),
            plot.title = element_text(size = 14, face = "bold"),
            plot.subtitle = element_text(size = 12)
        ) +
        labs(
            title = "Olympic Medals vs GDP per Capita",
            subtitle = "Comparison by Country and Season\n(Size of points corresponds to population size)",
            x = "Log of GDP per Capita",
            y = "Log of Medals",
            colour = "Region"
        )

    return(p)
}

