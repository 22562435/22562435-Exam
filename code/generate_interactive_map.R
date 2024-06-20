library(dplyr)
library(rnaturalearth)
library(sf)
library(leaflet)

generate_interactive_map<-function(database,variable,title="",colour="YlOrRd")    {
    pal <- colorNumeric(palette = colour, domain = database$variable, na.color = "transparent")


    g<-leaflet(database) %>%
        addTiles() %>%
        addPolygons(
            fillColor = ~pal(variable),
            weight = 1,
            opacity = 1,
            color = "white",
            dashArray = "3",
            fillOpacity = 0.7,
            highlightOptions = highlightOptions(
                weight = 5,
                color = "#666",
                dashArray = "",
                fillOpacity = 0.7,
                bringToFront = TRUE), #format(round(x, 2), nsmall = 2)
            label = ~paste(name, ": ", format(round(variable, 2), nsmall = 2), " billion"),
            labelOptions = labelOptions(
                style = list("font-weight" = "normal", padding = "3px 8px"),
                textsize = "15px",
                direction = "auto")
        ) %>%
        addLegend(pal = pal, values = ~variable, opacity = 1, title = title,
                  position = "bottomright")

    return(g)}