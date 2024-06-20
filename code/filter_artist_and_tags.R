library(dplyr)
library(tidyr)
library(stringr)

filter_artist_and_tags <- function(database, artist_name) {
    # Filter the database for the given artist
    artist_data <- database %>% filter(artist == artist_name)

    # Determine the min and max year for the artist, this helps for ggplot so we are
    min_year <- min(artist_data$year, na.rm = TRUE) #not comparing dates way before or
    max_year <- max(artist_data$year, na.rm = TRUE)# way after artist

    # Split the tags into individual tags and count the frequency of each tag
    tag_counts <- artist_data %>%
        separate_rows(tags, sep = ",\\s*") %>%
        count(tags, sort = TRUE)

    # Get the top 3 most frequent tags
    top_tags <- tag_counts %>%
        top_n(3, wt = n) %>%
        pull(tags)

    # Filter the entire database for rows containing any of the top 3 tags
    filtered_data <- database %>%
        filter(str_detect(tags, paste(top_tags, collapse = "|")))%>%
        filter(year >= min_year & year <= max_year) #filter out years

    # Add a new variable 'Artist'
    filtered_data <- filtered_data %>%
        mutate(Artist = ifelse(artist == artist_name, artist_name, paste("Similar to", artist_name)))

    return(filtered_data)
}
