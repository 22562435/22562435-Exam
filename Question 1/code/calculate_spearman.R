calculate_spearman <- function(data) {
    # Calculate Spearman rank correlation
    spearman_corr <- cor(data$Rank_current, data$Rank_future, method = "spearman", use = "complete.obs")
    return(spearman_corr)
} #use="complete.obs" takes into account that the last three years will return NA's, so removes them