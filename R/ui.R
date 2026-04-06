#library(shiny)
#library(shinyMatrix)

# UI
ui <- fluidPage(
  
  
  # Sitio
  titlePanel("Comparación de riqueza de líquenes entre árboles
               nativos y exóticos"),
  sidebarLayout(
    sidebarPanel(
      width = 4,
      tags$h4("Datos de riqueza"),
      matrixInput(
        "sample",
        value = m,
        rows = list(
          extend = F,
          names = T
        ),
        cols = list(
          names = T
        )
      )
    ),
    mainPanel(
      width = 6,
      plotOutput("barplot"),
      hr(style = "border-top: 2px solid black;"),
      h3("Análisis estadístico", style = "text-align: center;"),
      hr(style = "border-top: 2px solid black;"),
      verbatimTextOutput("welch"),
      #uiOutput("welch_html")
      #tableOutput("welch_table")
    )
  )
)