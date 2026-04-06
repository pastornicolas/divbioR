library(shiny)
library(shinyMatrix)

m_empty <- matrix(0, 10, 5, dimnames = list(
  #m <- matrix(0, 10, 5, dimnames = list(
  c("Nativo 1", "Nativo 2", "Nativo 3", "Nativo 4", "Nativo 5",
    "Exótico 1", "Exótico 2", "Exótico 3", "Exótico 4", "Exótico 5"),
  c("Grupo 1", "Grupo 2", "Grupo 3", "Grupo 4", "Grupo 5")))

# servidor
server <- function(input, output, session) {

  observeEvent(input$reset_btn, {
    updateMatrixInput(session, "sample", m_empty)
  })
  
  observeEvent(input$random_btn, {
    
    m_rand <- matrix(round(runif(50, 0, 3)), 10, 5, dimnames = list(
      #m <- matrix(0, 10, 5, dimnames = list(
      c("Nativo 1", "Nativo 2", "Nativo 3", "Nativo 4", "Nativo 5",
        "Exótico 1", "Exótico 2", "Exótico 3", "Exótico 4", "Exótico 5"),
      c("Grupo 1", "Grupo 2", "Grupo 3", "Grupo 4", "Grupo 5")))
    
    updateMatrixInput(session, "sample", m_rand)
  })
  
  
  calc <- reactive({
    req(input$sample)
    mat <- apply(input$sample, 2, as.numeric)
    
    list(
      # agregado por grupo
      natbygr = colSums(mat[1:5, ])/5,
      exobygr = colSums(mat[6:10, ])/5,
      # replicas para test estadístico
      nat = as.vector(mat[1:5, ]),
      exo = as.vector(mat[6:10, ])
    )
  })
  
  output$barplot <- renderPlot({
    c <- calc()
    
    df <- rbind(c$natbygr,c$exobygr)
    row.names(df) <- c("Nativo", "Exótico")
    
    barplot(df, beside = T,
            col= c("forestgreen", "red"),
            legend.text = rownames(df),
            args.legend = list(x = "bottom", horiz = TRUE, inset = c(0, -0.25),
                               bty="n", xpd = T),
            main = "Riqueza por grupo")
    abline(h = c(mean(c$natbygr), mean(c$exobygr)), col = c("darkgreen", "darkred")
           , lty = "dashed", lwd=5)
    legend("bottom", legend = c("Riq. Media Nativo", "Riq. Media Exótico"),
           horiz=T, inset = c(0, -0.3), xpd = T, bty="n",
           col = c("darkgreen", "darkred"),
           lty = 2, lwd = 2)
    
  })
  
  output$welch <- renderPrint({
    
    c <- calc()
    test <- t.test(c$nat, c$exo, var.equal = FALSE)
    
    # Extract key elements
    t_stat <- test$statistic
    p_val <- test$p.value
    mean_nat <- mean(c$nat)
    sd_nat <- sd(c$nat)
    mean_exo <- mean(c$exo)
    sd_exo <- sd(c$exo)
    if (p_val < 0.05) {
      res <- "HAY DIFERENCIAS SIGNIFICATIVAS"
    } else {
      res <- "NO HAY DIFERENCIAS SIGNIFICATIVAS"
    }
    
    # Print nicely
    cat("Prueba t de Welch (Adaptacion de t de Student\nsin asunción de igualdad de varianzas)\n")
    cat("---------------------------------------------\n")
    cat(sprintf("t = %.3f\tp-valor = %.4f\n", t_stat, p_val))
    cat(sprintf("Media NATIVOS = %.3f (d.e. = %.2f)\nMedia EXÓTICOS = %.3f (de = %.2f)\n",
                mean_nat, sd_nat, mean_exo, sd_exo))
    cat("---------------------------------------------\n")
    cat("Resultado:", res)
    
  })
  
}
