calculate_growth_rate <- function(total_count_current, lagged_total_count_current) {
    growth_rate <- ((total_count_current - lagged_total_count_current) / lagged_total_count_current) * 100
    return(growth_rate)
}