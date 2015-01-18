shiny_app_example <- function(){
        
    shinyApp(
        
        
        ui = fluidPage(    
            numericInput("n", label="Sample size:", min=1, max=100000000, value=1000, step=1),
            plotOutput("outputHIST")
            ),
        
        server = function(input,output){
            output$outputHIST <- renderPlot({
                hist(rpois(input$n,lambda=3))
            })
        
        }, 
        
            options = list(height=500)
        
        )
    
}