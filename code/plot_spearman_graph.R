plot_spearman_graph<-function(x){
    library(ggplot2)
    spearman_results_male <- x %>%
        filter(Rank_current <= 25) %>%
        filter(Year_current <= 2011) %>%
        filter(Gender == "M") %>%
        group_by(Year_current) %>%
        summarize(Spearman = calculate_spearman(cur_data()), .groups = 'drop')


    spearman_results_female <- x %>%
        filter(Rank_current <= 25) %>%
        filter(Year_current <= 2011) %>% #3 years since the latest date (because spearmen is between three year lags)
        filter(Gender == "F") %>%
        group_by(Year_current) %>%
        summarize(Spearman = calculate_spearman(cur_data()), .groups = 'drop')


    spearman_results <- bind_rows(
        spearman_results_male %>% mutate(Gender = "M"),
        spearman_results_female %>% mutate(Gender = "F")
    )

    g<-ggplot(spearman_results, aes(x = Year_current, y = Spearman, color = Gender)) +
        geom_line() +
        geom_point() +
        labs(title = "Spearman Rank Correlation of Baby Names Over Time",
             subtitle = "Analysis based on the top 25 names each year, categorised by gender",
             caption="Source: Social Security records",
             x = "",
             y = "Spearman Rank Correlation") +
        geom_vline(xintercept = 1990, linetype = "dashed", color = "#4a2c2a") +
        geom_smooth(formula = y ~ x, method = loess, se = FALSE, alpha = 0.5) +
        annotate("text", x = 1990, y = max(spearman_results$Spearman, na.rm = TRUE), label = "1990", vjust = -0.5, color = "#4a2c2a") +

        theme_bw()
    return(g)
}