# Function to read a CSV and add an "artist" column
read_and_label_csv <- function(file_path) {
    df <- read.csv(file_path)
    artist_name <- tools::file_path_sans_ext(basename(file_path))
    df$artist <- artist_name
    return(df)
}