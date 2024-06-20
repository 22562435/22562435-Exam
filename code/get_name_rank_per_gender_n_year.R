get_name_rank_per_gender_n_year <- function(x) {
    library(dplyr)
    # Compute total counts and ranks for each year, gender, and name
    name_df <- x %>%
        group_by(Year, Gender, Name) %>%
        summarize(Total_Count = sum(Count), .groups = 'drop') %>%  # get total instances per year per gender
        arrange(Year, Gender, desc(Total_Count)) %>% #setting up rank order
        group_by(Year, Gender) %>%
        mutate(Rank = row_number(desc(Total_Count))) %>% # Adding the rank of the year
        ungroup()

    # Join the data with itself to get the rank three years later
    name_df_with_future_rank <- name_df %>%
        rename(Rank_current = Rank, Year_current = Year, Total_Count_current = Total_Count) %>%
        left_join(
            name_df %>%
                rename(Rank_future = Rank, Year_future = Year, Total_Count_future = Total_Count) %>%
                mutate(Year_future = Year_future - 3),
            by = c("Name", "Gender", "Year_current" = "Year_future")
        ) %>%
        select(Year_current, Gender, Name, Total_Count_current, Rank_current, Rank_future)

    # Arrange the final database and return
    final_database <- name_df_with_future_rank %>%
        arrange(Year_current, Gender, Rank_current)
    final_database
}

