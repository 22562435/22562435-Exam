merge_na_coloumns<-function(df,column1,column2){
    # Replace NA values in column1 with values from column2
    df[[column1]][is.na(df[[column1]])] <- df[[column2]][is.na(df[[column1]])]

    # Remove column2
    df[[column2]] <- NULL

    return(df)
}
