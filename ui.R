##
#
# Shiny UI
#
##

shinyUI(fluidPage(
   titlePanel("ARAM Reroll Calculator"),
   sidebarLayout(
      sidebarPanel(
         select2Input('teammatesInput', "Teammates", choices = winrates$champName),
         select2Input('champInput', 'Your champion', choices = winrates$champName),
         br(),
         actionButton('goButton', "Go!")
      ),
      mainPanel(
         textOutput('mainResults')
      )
   ),
   hr(),
   fluidRow("This ARAM Reroll Calculator isn't endorsed by Riot Games and doesn't reflect
            the views or opinions of Riot Games or anyone officially involved in producing
            or managing League of Legends. League of Legends and Riot Games are trademarks
            or registered trademarks of Riot Games, Inc. League of Legends © Riot Games, Inc.")
   
))