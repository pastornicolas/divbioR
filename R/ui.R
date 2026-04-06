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
        value = m_empty,
        rows = list(
          extend = F,
          names = T
        ),
        cols = list(
          names = T
        )
      ),
      #actionButton(inputId = "load_btn", label = "Cargar datos aleatorios")
      actionButton("reset_btn", "Vaciar los datos"),
      actionButton("random_btn", "Datos aleatorios")
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
