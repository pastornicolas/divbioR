ui <- fluidPage(
  useShinyjs(),
  use_gotop(src="fas fa-chevron-circle-up",
            opacity = 0.8, scrolltime = 100,
            use_cdn = FALSE),
  theme = bs_theme(version = 5),  # Bootstrap 5 theme
  # # Custom CSS for layout improvements
  tags$head(
    tags$style(HTML("
      body {
        overflow-x: hidden;
      }
      .container-fluid, .row, .col {
        width: 100%;
      }
      .card-body {
        padding: 20px;  /* Adding padding to card body */
      }
      img {
        max-width: 100%; /* Ensure images are responsive */
        height: auto;
        display: block;
        margin: 20px auto;
        border-radius: 8px;
      }
    "))
  ),
  
  titlePanel(
    h1("Cuestionario de frecuencia de consumo de alimentos\nPoblAr - Nodo Centro",
       style = 'background-color:lightblue;padding: 15px',
       align = 'center')
  ),
  navbarPage(
    tabsetPanel(
      Amod_ui("A"),
      Bmod_ui("B"),
      Cmod_ui("C"),
      Dmod_ui("D"),
      Emod_ui("E"),
      Fmod_ui("F"),
      Gmod_ui("G"),
      Hmod_ui("H"),
      Imod_ui("I"),
      Jmod_ui("J"),
      Kmod_ui("K"),
      Lmod_ui("L"),
      tabPanel("Resultados", br(), p("Parámetros a calcular\n(",
                                     span("resta ser implementado...",
                                          style = "font-style: italic;"), ")",
                                     tags$img(
                                       src = "z_res.png",
                                     ),
      ),
      br(), tableOutput('table')
      )
    )
  ))
