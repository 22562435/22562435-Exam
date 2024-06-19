library(dplyr)
library(stringr)
library(lubridate)

# Define the function
find_top_names <- function(namestogo, rankednames, charts) {

    results <- data.frame()

    # Iterate through each name in namestogo
    for (name in namestogo) {

        # Find the Year_current-1 in rankednames where Growth_Rate is max for that name
        max_growth_year <- rankednames %>%
            filter(Name == name) %>%
            filter(Growth_Rate == max(Growth_Rate, na.rm = TRUE)) %>%
            pull(Year_current) %>%
            max() -1  # Subtract 1 to get the year prior to max Growth_Rate year

        # If no max growth year found, skip to next name
        if (is.na(max_growth_year)) {
            next
        }

        # Find instances of the name in charts for the year prior
        charts_match <- charts %>%
            filter(year(date) == max_growth_year) %>%  # Filter for the year prior to max Growth_Rate year
            filter(str_detect(tolower(song), tolower(name)) |
                       str_detect(tolower(artist), tolower(name))) %>%
            arrange("peak-rank") %>%
            slice_head(n = 1)  # Take the top-ranked song/artist

        # If no match found in charts, skip to next name
        if (nrow(charts_match) == 0) {
            next
        }

        # Add name to the results
        charts_match <- charts_match %>%
            mutate(Name = name)

        results <- bind_rows(results, charts_match)
    }

    # Return the final table
    return(results)
}



