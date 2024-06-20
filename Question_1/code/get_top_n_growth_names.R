get_top_n_growth_names <- function(data, N, TOP = 500) {
    library(dplyr)

    # Filter the data based on the provided TOP rank
    filtered_data <- data %>%
        filter(Rank_current <= TOP)

    # Select the top N names with the highest growth rates
    top_n_names <- filtered_data %>%
        arrange(desc(Growth_Rate)) %>%  # Sort by Growth_Rate in descending order
        distinct(Name, .keep_all = TRUE) %>%  # Ensure names are unique
        slice_head(n = N)  # Get the top N rows

    df<-data %>%
        semi_join(top_n_names, by = c("Name", "Gender"))
    # Return the result
    return(df)
}
