if (!require(purrr)) {
    install.packages("purrr")
}
library(purrr)

remove_rows_containing <- function(df, column, trigger_words) {
    # Combine trigger words with |, this makes the user experence better by only having to input concatinated list
    pattern <- paste(trigger_words, collapse = "|")


    # Make a safe function, needed since the special characters in the database columns
    safe_grepl <- safely(function(x) {
        # Convert strings to UTF-8 encoding to handle special characters
        x <- iconv(x, to = "UTF-8", sub = "byte")
        grepl(pattern, x, ignore.case = TRUE)
    }, otherwise = NULL, quiet = TRUE)

    # Apply the safe_grepl function to the specified column
    result <- safe_grepl(df[[column]])

    # Check if an error occurred
    if (!is.null(result$error)) {
        message("An error occurred while processing the column: ",
                result$error$message)
        return(df)
    }

    rows_to_remove <- result$result


    df <- df[!rows_to_remove, ] # Filter out the rows containing the trigger words

    return(df)
}

