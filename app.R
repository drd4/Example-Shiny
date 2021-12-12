setwd("~/Desktop/Columbia Fall 2021/Capstone/capstone_wd/final")


library(shiny)
library(DT)
library(data.table)
library(shinythemes)
library(shinyWidgets)
#dat <- fread("dat.csv")



#Data manipulation

#df with just show name
df<- unique(dat[, c("show_name", "show_description", "episode_uri")])

#Create Cluster
df$cluster <- sample(5, size = nrow(df), replace = TRUE)

#constants
show.name <- "show_name"
cluster.name <- "cluster"


df$episode_uri <- paste0("<a href= ", df$episode_uri)
#$`GC Profile` <- paste0("<a href='","https://dbgc.astros.com/IntlScout/Player?player_guid=", intl_df$`GC Profile`,"' target='_blank'>", "GC Profile","</a>")

#shiny app

#add show description, show_urinam


ui = fluidPage(theme = shinytheme("cerulean"),
               titlePanel("Podcast Recommender"),
               sidebarPanel(
                 selectizeInput("show", "Select Podcast", choices = sort(df$show_name), selected = "Kream in your Koffee"),
                 actionButton('refresh', 'Refresh Recommendations', icon = icon('refresh')),
                 h6("Instructions: Select a podcast to view 10 podcast recommendations. Hit the 'Refresh Button' to view new recommendations!")),
               
               mainPanel(
                 DT::dataTableOutput('table')
               )
)

server = function(input, output, session) {
  dat <- df
  dat <- setDT(dat)
  proxyData = reactive({
    input$refresh
    dat1 <- dat[get(show.name) %in% input$show]
    
    dat2 <- dat[get(cluster.name) == dat1$cluster]
    
    rows<- sample(nrow(dat2))
    
    dat3 <- dat2[rows,]
    
    dat3[1:10,]
    
  })
  
  output$table = DT::renderDataTable(isolate(proxyData()), options = list(dom = 't'))
  
  proxy = dataTableProxy('table')
  
  observe({
    replaceData(proxy, proxyData(), resetPaging = FALSE)
  })
}
shinyApp(ui, server)







#dt <- unique(dat[, c( "show_name", "show_description")])

