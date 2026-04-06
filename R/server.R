library(shiny)
library(shinyMatrix)

# servidor
server <- function(input, output) {

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
            args.legend = list(x = "bottomleft", horiz = TRUE, inset = c(0, -0.25),
                               bty="n", xpd = T),
            main = "Riqueza por grupo")
    abline(h = c(mean(c$natbygr), mean(c$exobygr)), col = c("darkgreen", "darkred")
                 , lty = "dashed", lwd=5)
    legend("bottomright", legend = c("Riq. Media Nativo", "Riq. Media Exótico"),
           horiz=T, inset = c(0, -0.25), xpd = T, bty="n",
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
    
    # Print nicely
    cat("Prueba t de Welch (Adaptacion de t de Student sin asunción de igualdad de varianzas)\n")
    cat("-----------------\n")
    cat(sprintf("t = %.3f\tp-valor = %.4f\n", t_stat, p_val))
    cat(sprintf("Media NATIVOS = %.3f (d.e. = %.2f)\tMedia EXÓTICOS = %.3f (de = %.2f)",
                mean_nat, sd_nat, mean_exo, sd_exo))
  })
  
  
  output$welch_html <- renderUI({
    c <- calc()
    test <- t.test(c$nat, c$exo, var.equal = FALSE)
    
    # Extract key elements
    t_stat <- test$statistic
    p_val <- test$p.value
    mean_nat <- mean(c$nat)
    sd_nat <- sd(c$nat)
    mean_exo <- mean(c$exo)
    sd_exo <- sd(c$exo)
    
    HTML(paste0(
      "<b><i>Welch Two Sample t-test</i></b><br>",
      "-----------------------<br>",
      sprintf("<b>t statistic</b>: %.3f<br>", t_stat),
      sprintf("<b>p-value</b>: %.4f<br>", p_val),
      sprintf("<b>Mean nat</b>: %.3f<br>", mean_nat),
      sprintf("<b>Mean exo</b>: %.3f<br>", mean_exo)
    ))
  })
  
  # output$welch_table <- renderTable({
  #   
  #   c <- calc()
  #   test <- t.test(c$nat, c$exo, var.equal = FALSE)
  #   
  #   # Create a small summary table
  #   data.frame(
  #     Statistic = test$statistic,
  #     DF = test$parameter,
  #     `p-value` = test$p.value,
  #     `CI Lower` = test$conf.int[1],
  #     `CI Upper` = test$conf.int[2],
  #     `Mean nat` = mean(c$nat),
  #     `Mean exo` = mean(c$exo)
  #   )
  # }, digits = 3)
  
}
