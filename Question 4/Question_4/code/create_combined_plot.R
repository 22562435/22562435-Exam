library(dplyr)
library(ggplot2)
library(patchwork)
source("code/metal_weightings_summation_sans_season.R")
# Main function to create and return the combined plot
create_combined_plot <- function(summer_data, winter_data) {
    # Process summer data
    summer_medals <- metal_weightings_summation_sans_season(summer_data)

    summer_heatmap_data <- summer_medals %>%
        group_by(Country, Year) %>%
        summarise(Total_Medals = sum(Medals), .groups = 'drop') %>%
        ungroup() %>%
        filter(Country %in% (summer_medals %>%
                                 group_by(Country) %>%
                                 summarise(Total_Medals = sum(Medals), .groups = 'drop') %>%
                                 top_n(10, Total_Medals))$Country)

    plot1 <- ggplot(summer_heatmap_data, aes(x = Year, y = Country, fill = Total_Medals)) +
        geom_tile(color = "white") +  # Use geom_tile for heatmap
        scale_fill_gradient(low = "lightpink", high = "darkred") +  # Color gradient
        labs(title = "Dominance of Top Countries in Summer Olympics",
             subtitle = "Total Medals Won over Time",
             x = "", y = "", fill = "Total Medals") +
        theme_bw() +  # Minimal theme
        theme(axis.text.x = element_text(angle = 45, hjust = 1))  # Rotate x-axis labels for better readability

    # Process winter data
    winter_medals <- metal_weightings_summation_sans_season(winter_data)

    winter_heatmap_data <- winter_medals %>%
        group_by(Country, Year) %>%
        summarise(Total_Medals = sum(Medals), .groups = 'drop') %>%
        ungroup() %>%
        mutate(Year = if_else(Year >= 1994, Year + 2, Year)) %>%
        filter(Country %in% (winter_medals %>%
                                 group_by(Country) %>%
                                 summarise(Total_Medals = sum(Medals), .groups = 'drop') %>%
                                 top_n(10, Total_Medals))$Country)

    plot2 <- ggplot(winter_heatmap_data, aes(x = Year, y = Country, fill = Total_Medals)) +
        geom_tile(color = "white") +  # Use geom_tile for heatmap
        scale_fill_gradient(low = "lightblue", high = "blue") +  # Color gradient
        labs(title = "Dominance of Top Countries in Winter Olympics",
             subtitle = "Total Medals Won over Time",
             x = "", y = "", fill = "Total Medals") +
        theme_bw() +  # Minimal theme
        theme(axis.text.x = element_text(angle = 45, hjust = 1))  # Rotate x-axis labels for better readability

    # Combine plots using patchwork
    combined_plot <- plot1 + plot2 + plot_layout(ncol = 1)
    return(combined_plot)
}

