plot_boxplot_totals_eu_vs_non<-function(df){

    data_long <- df %>%
        select(Country, EU.member, TotalBilateralAllocations, TotalBilateralCommitments) %>%
        pivot_longer(cols = c(TotalBilateralAllocations, TotalBilateralCommitments),
                     names_to = "Type", values_to = "Value") %>%
        mutate(EU.member = case_when(
            EU.member == 0 ~ "Non-EU member",
            EU.member == 1 ~ "EU member"
        ))


    # Create the boxplot
    g<-ggplot(data_long, aes(x = Type, y = Value, fill = factor(EU.member))) +
        geom_boxplot() +
        scale_y_log10(labels = scales::comma_format()) +
        labs(
            title = "Total Bilateral Allocations and Commitments by EU Membership",
            x = "",
            y = "Value (billion)",
            fill = ""
        ) +
        theme_bw()+
        coord_flip()+
        theme(legend.position = "bottom")

    return(g)}