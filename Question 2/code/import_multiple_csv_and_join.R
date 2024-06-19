import_multiple_csv_and_join_identifier<-function(pathway = "data/."){
    library(dplyr)

    # Fetching the CSV file names
    temp <- list.files(path = pathway, pattern = "\\.csv$", full.names = TRUE)

    # Importing CSV files into a list and apply second function that labels route
    data_list <- lapply(temp, read_and_label_csv)

    # Merging all data frames by common column names
    merged_data <- Reduce(function(x, y) {
        common_cols <- intersect(names(x), names(y))
        full_join(x, y, by = common_cols)
    }, data_list)

    return(merged_data)
}
