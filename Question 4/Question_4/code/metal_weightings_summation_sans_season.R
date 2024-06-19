metal_weightings_summation_sans_season <- function(df) {
    summariseddf <- df %>%
        group_by(Year, Sport, Discipline, Event, Medal, Gender) %>%
        mutate(
            n_medals = n(),  # Calculate the number of medals in each group
            medal_weighting = case_when(
                Medal == "Gold" ~ 4 / n_medals,
                Medal == "Silver" ~ 2 / n_medals,
                TRUE ~ 1 / n_medals
            )
        ) %>%
        ungroup() %>%
        select(-n_medals) %>%
        group_by(Country, Year) %>%  # Include Year
        summarise(Medals = sum(medal_weighting, na.rm = TRUE), .groups = 'drop')

    return(summariseddf)}