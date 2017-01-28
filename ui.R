##
#
# Shiny UI
#
##

shinyUI(fluidPage(
   titlePanel("ARAM Reroll Calculator"),
   sidebarPanel(
      select2Input('teammatesInput', "Teammates", choices = winrates$champName),
      select2Input('champInput', 'Your champion', choices = winrates$champName),
      br(),
      actionButton('goButton', "Go!")
   ),
   mainPanel(
      textOutput('mainResults')
   )
))