add_growth_of_name_variable <- function(data) {
    library(dplyr)

    # Arrange and group by Name and Gender, calculate lagged Total_Count_current and growth rate
    df <- data %>%
        arrange(Name, Gender, Year_current) %>%  # Ensuring data is sorted for lag calculation
        group_by(Name, Gender) %>%
        mutate(Growth_Rate = calculate_growth_rate(
            Total_Count_current,
            lag(Total_Count_current, default = first(Total_Count_current))
        )) %>%
        ungroup() %>%
        arrange(Year_current, Gender, Rank_current) %>%


    # Return the updated dataframe
    return(df)
}
