
library(dplyr)
# Function to fill in missing years with zeros
fill_missing_years <- function(data) {
    min_year <- min(data$Year_current) # Minimum year in the entire database
    max_year <- max(data$Year_current) # Maximum year we want to fill up to

    # Create a complete data frame for each name
    filled_data <- data %>%
        group_by(Name, Gender) %>%
        do({
            name_data <- .
            name_min_year <- min(name_data$Year_current)
            name_max_year <- max(name_data$Year_current)

            # Create a sequence of years from the global min year to the name's min year - 1
            if (name_min_year > min_year) {
                years_to_add <- tibble(
                    Year_current = seq(min_year, name_min_year - 1),
                    Name = unique(name_data$Name),
                    Gender = unique(name_data$Gender),
                    Total_Count_current = 0
                )
            } else {
                years_to_add <- tibble()
            }

            # Create a sequence of years from the name's max year + 1 to the global max year
            if (name_max_year < max_year) {
                years_to_append <- tibble(
                    Year_current = seq(name_max_year + 1, max_year),
                    Name = unique(name_data$Name),
                    Gender = unique(name_data$Gender),
                    Total_Count_current = 0
                )
            } else {
                years_to_append <- tibble()
            }

            # Combine the original data with the new rows
            bind_rows(years_to_add, name_data, years_to_append)
        }) %>%
        ungroup()

    return(filled_data)
}


