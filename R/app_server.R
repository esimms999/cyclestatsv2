#' Application server
#'
#' @param input,output,session Internal Shiny parameters.
#'
#' @import ggplot2
#' @importFrom DT renderDT
#' @rawNamespace import(plotly, except = last_plot)
app_server <- function(input, output, session) {
  number_of_rides <- reactive({
    as.character(dplyr::count(activities_selected()))
  })

  number_of_miles <- reactive({
    as.character(sum(activities_selected()$activity_distance))
  })

  activities_selected <- reactive({
    .cyclestats_data$activities |>
      dplyr::filter(activity_year %in% input$selected_years)
  })

  # Aggregate per year-month so the chart draws one solid bar per month.
  activities_selected_sum <- reactive({
    .cyclestats_data$activities |>
      dplyr::filter(activity_year %in% input$selected_years) |>
      dplyr::group_by(activity_year_month) |>
      dplyr::mutate(ride_count = 1) |>
      dplyr::summarise(
        total_distance = sum(activity_distance),
        total_rides = sum(ride_count)
      )
  })

  # Left-join with zero-value month template so months with no rides appear.
  activities_selected_graph <- reactive({
    .cyclestats_data$activity_year_month_zero |>
      dplyr::filter(activity_year %in% input$selected_years) |>
      dplyr::left_join(activities_selected_sum(), by = "activity_year_month") |>
      dplyr::mutate(
        total_distance = dplyr::if_else(is.na(total_distance), 0, total_distance),
        total_rides = dplyr::if_else(is.na(total_rides), 0, total_rides)
      )
  })

  gg_plot <- reactive({
    plotly::ggplotly(
      ggplot2::ggplot(
        data = activities_selected_graph(),
        aes(
          x = activity_year_month,
          y = total_distance,
          text = paste(
            "Year-Month: ", activity_year_month,
            "\nDistance: ", total_distance,
            "\nRides: ", total_rides
          )
        )
      ) +
        geom_col(fill = "blue") +
        ggtitle("Total Miles by Month") +
        xlab("\nMonth") +
        ylab("Miles") +
        theme(axis.text.x = element_text(angle = 90)) +
        theme(panel.border = element_rect(color = "blue", fill = NA, linewidth = 1)),
      tooltip = c("text")
    )
  })

  output$miles_graph <- plotly::renderPlotly(gg_plot())
  output$miles_table <- DT::renderDT(activities_selected())

  output$about_text <- renderUI({
    HTML(markdown::markdownToHTML(
      app_sys("app/www/about.md"),
      fragment.only = TRUE,
      options = "-embed_resources"
    ))
  })

  output$number_of_rides <- renderText(number_of_rides())
  output$number_of_miles <- renderText(number_of_miles())
}
