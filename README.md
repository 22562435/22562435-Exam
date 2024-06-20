# Purpose

The purpose of this file is to discuss and give a walk through my
thinking when tackling the Data Science exam, and to explain the
functions created so that I have a reference point to go back against
when reviewing the functions in the future.

Setup includes all functions used in the exam.

``` r
rm(list = ls()) # Clean your environment:
gc() # garbage collection - It can be useful to call gc after a large object has been removed, as this may prompt R to return memory to the operating system.
```

    ##          used (Mb) gc trigger (Mb) max used (Mb)
    ## Ncells 469303 25.1    1010664   54   660402 35.3
    ## Vcells 870102  6.7    8388608   64  1770104 13.6

``` r
library(tidyverse)
```

    ## Warning: package 'ggplot2' was built under R version 4.3.3

    ## ── Attaching core tidyverse packages ──────────────────────── tidyverse 2.0.0 ──
    ## ✔ dplyr     1.1.4     ✔ readr     2.1.5
    ## ✔ forcats   1.0.0     ✔ stringr   1.5.1
    ## ✔ ggplot2   3.5.1     ✔ tibble    3.2.1
    ## ✔ lubridate 1.9.3     ✔ tidyr     1.3.1
    ## ✔ purrr     1.0.2     
    ## ── Conflicts ────────────────────────────────────────── tidyverse_conflicts() ──
    ## ✖ dplyr::filter() masks stats::filter()
    ## ✖ dplyr::lag()    masks stats::lag()
    ## ℹ Use the conflicted package (<http://conflicted.r-lib.org/>) to force all conflicts to become errors

``` r
list.files('code/', full.names = T, recursive = T) %>% .[grepl('.R', .)] %>% as.list() %>% walk(~source(.))
```

    ## Warning: package 'patchwork' was built under R version 4.3.3

    ## Warning: package 'rnaturalearth' was built under R version 4.3.3

    ## Warning: package 'sf' was built under R version 4.3.3

    ## Linking to GEOS 3.11.2, GDAL 3.8.2, PROJ 9.3.1; sf_use_s2() is TRUE

    ## Warning: package 'leaflet' was built under R version 4.3.3

#Question 1

Question 1 dealt with baby name popularity and how correlated baby names
today are with baby names of tomorrow. Additionally the question
investigated the route causes of baby name innovation, notably pop
culture.

The first function called was import_multiple_rds(). This is a function
that takes in a pathway, and looks at the folder inside that pathway and
imports all rds files into the global environment. It is initialised to
path = “data/.”

``` r
import_multiple_rds("data/US_Baby_names")
```

The second sets of functions deal with data wrangling.
get_name_rank_per_gender_n_year() is a function ranks names by year and
gender based on their total counts and tracks their ranks three years
later. It groups and summarizes the data, assigns ranks, and then merges
the data to include future ranks, arranging the final output by year,
gender, and current rank.

add_growth_of_name_variable() is a function that calculates the growth
rate of name popularity over time within a given dataset. It takes in a
database and then sorts the data by name, gender, and year, then
computes the growth rate based on the current and previous counts for
each name and gender. The resulting dataset includes this new growth
rate variable and is arranged by year, gender, and current rank.

``` r
rankednames <- Baby_Names_By_US_State %>% 
    get_name_rank_per_gender_n_year() %>% 
    add_growth_of_name_variable() 
```

The question called for a plotting of the Spearman rank-correlation.
plot_spearman_graph() is a function that creates a Spearman rank
correlation plot over time, separated by gender, based on the top 25
baby names each year. The function begins by filtering the data for
males and females, calculates the Spearman rank correlation for each
year, combines the results, and plots the correlations over time with a
vertical line marking the year 1990, which is a year significant to the
question. The resulting plot is returned. Its input “x” is the data
frame.

``` r
rankednames %>%    plot_spearman_graph()
```

    ## Warning: There was 1 warning in `summarize()`.
    ## ℹ In argument: `Spearman = calculate_spearman(cur_data())`.
    ## ℹ In group 1: `Year_current = 1910`.
    ## Caused by warning:
    ## ! `cur_data()` was deprecated in dplyr 1.1.0.
    ## ℹ Please use `pick()` instead.

![](README_files/figure-markdown_github/q1%20plot%201-1.png)

The get_top_n_growth_names function takes three inputs: the database,
the amount of unique names it wants returned, and criteria for
selection. It filters and processes a dataset to identify the top N
names with the highest growth rates within a specified top ranking. It
first filters the data to include only entries with a rank less than or
equal to the provided TOP rank value. This is to account for the fact
that growth rates are higher for uncommon names, as its easier to go
from 2 to 4, than 200 to 400. The function then selects the top N names
with the highest growth rates, ensuring each name is unique. Finally, it
returns a data frame containing entries for these top N names.

This is passed onto the function fill_missing_years() which takes a
dataset of names with their counts over various years and fills in any
missing years with zero counts. This ensures that for each name and
gender combination, the dataset includes entries for all years from the
earliest year in the dataset to the latest year in the dataset, with
zero counts for years where data is missing. To do this, the function
groups the data by Name and Gender, and then for each group, it adds
rows for missing years before the first recorded year and after the last
recorded year, setting Total_Count_current to zero for these added
years. Finally, it combines these rows with the original data and
returns the completed dataset.

Eventually this is passed onto plot_ridge_names(), which takes in the
data and returns a ridge plot over the years for each names popularity.

``` r
rankednames %>%
    get_top_n_growth_names(15,TOP = 120) %>% 
    fill_missing_years() %>% 
    plot_ridge_names()
```

    ## Warning: package 'ggridges' was built under R version 4.3.3

![](README_files/figure-markdown_github/q1%20plot2-1.png)

Find_top_names() is given a list of names it should search for in a data
base of music charts. It is also given a data base to help complete its
search. The function identifies and retrieves top-ranked songs or
artists from the charts dataset that match names with the highest growth
rates in the rankednames dataset. For each name provided in, it first
determines the year prior to the year with the highest growth rate. It
then searches through charts to find instances where the name appears in
either the song or artist columns for that specific year. If matches are
found, it selects the top-ranked entry based on peak Billboard 100 rank,
therefore ensuring the most popular song. The function continues this
process for each name it is given, appending the results into a final
table which includes the name, song or artist, and corresponding details
like peak-rank.

``` r
unique((rankednames %>% get_top_n_growth_names(15,TOP = 120))$Name) %>% 
    find_top_names(rankednames,charts) %>% 
    knitr::kable()
```

| date       | rank | song                             | artist                    | last-week | peak-rank | weeks-on-board | Name    |
|:------|---:|:------------------|:--------------|------:|------:|---------:|:-----|
| 2009-12-26 |   52 | I Wanna Make You Close Your Eyes | Dierks Bentley            |        52 |        52 |             11 | Bentley |
| 2001-12-29 |    7 | Always On Time                   | Ja Rule Featuring Ashanti |         9 |         7 |              7 | Ashanti |

#Question 2

Again my data is called in using the function import_multiple_rds()

``` r
import_multiple_rds("data/Coldplay_vs_Metallica")
```

The rest of the data is called in and merged together using the function
import_multiple_csv_and_join(). This function automates the process of
importing multiple CSV files from a specified directory and merges them
into a single data frame. It begins by fetching the names of all CSV
files in the directory that match the pattern .csv. Each CSV file is
then read into a list using lapply and read.csv. The function proceeds
to merge all data frames in data_list iteratively using full_join,
ensuring that columns with common names across data frames are used as
keys for merging. Finally, it returns the merged data frame containing
combined data from all CSV files.

However not all variables had overlapping variable names, therefore I
created a function called merge_na_coloumns() that merged the two column
variables where NA’s were present in rows. Additionally the function
deleted the duplicate column.

The music analysis required that certain albums or songs were filtered
out. This pertained to live albums or demo songs. Naturally I created a
function that removed the rows that contained mention fo these trigger
words. The function worked by providing a data frame, a column to look
at, and a list of trigger words. Using grepl the function checks each
value in the specified column against the pattern, filtering out rows
that match. If an error occurs during the process, it outputs a message
detailing the error. Finally, the function returns the modified data
frame with rows containing the trigger words removed.

This data frame is now passed onto the function violin_graph_music().

``` r
data %>% violin_graph_music()
```

<figure>
<img src="README_files/figure-markdown_github/q2%20violin%20graph-1.png"
alt="Song Popularity by Album for Coldplay and Metallica" />
<figcaption aria-hidden="true">Song Popularity by Album for Coldplay and
Metallica</figcaption>
</figure>

This function creates a violin plot using ggplot2 to visualize song
popularity across albums in a given data frame. It groups the data by
album_name, filters out albums with less than two entries, and then
plots the distribution of popularity scores. The plot also includes
jittered points to show the distribution of tempo values within each
album. The colour and fill aesthetics are mapped to artist.

plot_time_trend_of_similar_artist() is the ploting function of question
2.

``` r
Broader_Spotify_Info %>%  plot_time_trend_of_similar_artist("Coldplay","tempo")
```

<figure>
<img
src="README_files/figure-markdown_github/q2%20timetrend%20coldplay%20tempo%20-1.png"
alt="Time trend of tempo for Coldplay and similar artists" />
<figcaption aria-hidden="true">Time trend of tempo for Coldplay and
similar artists</figcaption>
</figure>

It takes on three inputs, a database, an artists name, and a Spotify
attribute. It then graphs all points of that attribute through time for
that artist and for artists similar to that artist. It then plots a
regression line for the spotify attribute through time for that artist
and for similar artists. More importantly, for the
plot_time_trend_of_similar_artist() to get information regarding similar
artists, it calls on the function filter_artists_and_tags() within
plot_time_trend_of_similar_artist().

The filter_artist_and_tags() function processes the given music database
to analyse a specific artist’s data. It filters the database for the
given artist_name, determines the artist’s active years, and identifies
the top three most frequent tags from their tracks. It then filters the
entire database for entries with these tags within the artist’s active
years. A new column, ‘Artist,’ differentiates between the specified
artist’s tracks and those of similar artists.

``` r
Broader_Spotify_Info %>%  plot_time_trend_of_similar_artist("Blur","danceability")
```

<figure>
<img
src="README_files/figure-markdown_github/timetrend%20Blur%20danceability%20-1.png"
alt="Time trend of danceability for Blur and similar artists" />
<figcaption aria-hidden="true">Time trend of danceability for Blur and
similar artists</figcaption>
</figure>

# Question 3

Again question 3 begins by importing data using the function
import_multiple_csv_and_join().

``` r
data<-import_multiple_csv_and_join("data/Ukraine_Aid/.") %>%
  rename(TotalBilateralAllocations = `Total.bilateral.allocations...billion.`) %>% 
  rename(TotalBilateralCommitments = `Total.bilateral.commitments...billion.`)   
map_data <- ne_countries(scale = "medium", returnclass = "sf") %>%
  left_join(data, by = c("name" = "Country"))
```

generate_interactive_map() is a function made that takes advantage of
the output for question 3 being in HTMP format, as it generates an
interactive map using the leaflet library. The function takes on four
variables, notably a data frame with geospatial information data, a
numeric variable to graph, a title for the graph, and a colour scale. It
sets up a colour palette, adds polygons representing geographical
regions, applies colour fills based on the variable values, and includes
interactivity features such as highlighting and labelling. Additionally,
it adds a legend to the map to indicate the scale of the variable

<!-- ```{r map bilateral allocations,include=TRUE,fig.cap="World Map of Total Bilateral Allocations to Ukraine\\label{allmap"} -->
<!-- generate_interactive_map(map_data,map_data$TotalBilateralAllocations,title="Total Bilateral Allocations (billion)") -->
<!-- ``` -->

commented out because not able to knit because file is not html. Please
look at README for question 3

The generate_interactive_map function creates an interactive map using
the Leaflet library in R. It takes a geospatial database and a variable
to map, then generates a coloured, interactive map based on the
specified variable. The function uses dplyr, rnaturalearth, sf, and
leaflet libraries. It sets up a colour palette, adds polygons
representing geographical regions, applies colour fills based on the
variable values, and includes interactivity features such as
highlighting and labelling. Additionally, it adds a legend to the map to
indicate the scale of the variable.

The plot_boxplot_totals_eu_vs_non() function generates a boxplot
comparing total bilateral allocations and commitments between EU and
non-EU member countries. The function reshapes the data into a long
format, recodes the EU.member variable, and creates a log-scaled boxplot
with flipped coordinates to compare the financial totals by EU
membership status.

``` r
data %>% plot_boxplot_totals_eu_vs_non()
```

    ## Warning: Removed 2 rows containing non-finite outside the scale range
    ## (`stat_boxplot()`).

<figure>
<img src="README_files/figure-markdown_github/q3%20boxplot-1.png"
alt="Total Bilateral Allocations and Commitments by EU Membership" />
<figcaption aria-hidden="true">Total Bilateral Allocations and
Commitments by EU Membership</figcaption>
</figure>

# Question 4

join_olympics() takes the winter and summer Olympics data frame and
joins them together, while adding a season indicator.

This is then past onto metal_weightings_summation() which is a function
that aims to accomplish two tasks. Firstly it weights medals down to how
many people achieved them per event. Therefore a medal in a team sport
like hockey is worth less than a medal in the 100m sprint. To do this I
group by Year, Sport, Discipline, Event, Medal, Gender,Season. From
there I count how many people have got a medal with n() and use that as
a weighting parameter. Something to note: the code is not perfect as it
make assumptions that mixed gender team events are not possible. This
short cut needed to be made because no information was given regarding
the gender of the event, and therefore if we did not group by gender,
then medals with an gender counter factual would be weighted half as
much. The second thing this function does is weight up gold compared to
silver and bronze. Gold is assumed to be worth 4 bronzes, and silver is
worth 2 bronzes.

I then piped this data into a left join, to obtain GDP information and
Olympic information together.

The plot_olympic_points() function generates a scatter plot graph that
is simple in construction but incredibly information dense when viewing.
The plot visualises the relationship between GDP per capita, Olympic
medals won (both logged), and population size for different countries.
It categorizes countries into three regions (“India”, “South America”,
and “Rest of the World”). The function also includes text annotations
for countries that exceed specified medal and GDP thresholds. The plot
is faceted by season, providing insights into how these variables vary
across different Olympic events.

``` r
data %>% plot_olympics_points()
```

    ## Warning: Removed 40 rows containing missing values or values outside the scale range
    ## (`geom_point()`).

<figure>
<img src="README_files/figure-markdown_github/q4%20plot%201-1.png"
alt="Olympic Medals vs GDP per Capita" />
<figcaption aria-hidden="true">Olympic Medals vs GDP per
Capita</figcaption>
</figure>

``` r
sports<-c("Boxing","Skating","Roque","Rackets","Golf","Ice Hockey") #these are the sports to compare

summer %>% attach_simple_metal_weightings() %>%
    group_by(Country, Sport) %>%
    summarise(Medals = sum(medal_weighting, na.rm = TRUE),
              .groups = 'drop') %>%
    left_join(GDP, by = c("Country" = "Code")) %>%
    filter(Sport %in% sports) %>%
    plot_sport_points_gdpandmedals()
```

    ## Warning: Removed 17 rows containing missing values or values outside the scale range
    ## (`geom_point()`).

<figure>
<img src="README_files/figure-markdown_github/q4%20plot%202-1.png"
alt="Boxing winners GDP per Captia versus wealthier sports " />
<figcaption aria-hidden="true">Boxing winners GDP per Captia versus
wealthier sports </figcaption>
</figure>

``` r
create_combined_plot(summer, winter)
```

<figure>
<img src="README_files/figure-markdown_github/q4%20plot%203-1.png"
alt="Heat Map of Olympic Dominance: Summer and Winter" />
<figcaption aria-hidden="true">Heat Map of Olympic Dominance: Summer and
Winter</figcaption>
</figure>
