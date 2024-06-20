import_multiple_csv_and_join_identifier <- function(pathway = "data/") {
    library(dplyr)
    library(stringr)

    # Fetching the CSV file names
    temp <- list.files(path = pathway, pattern = "\\.csv$", full.names = TRUE, recursive = TRUE)

    # Importing CSV files into a list with an additional 'artist' column
    data_list <- lapply(temp, function(file) {
        df <- read.csv(file)
        df$artist <- tools::file_path_sans_ext(basename(file))  # Set 'artist' to the name of the CSV file without the .csv extension
        return(df)
    })

    # Merging all data frames by common column names
    merged_data <- Reduce(function(x, y) {
        common_cols <- intersect(names(x), names(y))
        full_join(x, y, by = common_cols)
    }, data_list)

    return(merged_data)
}
