##
#
# Shiny server
#
##

shinyServer(function(input, output) {
   # All 5 champs on the team
   champsUnion = reactive({
      return(union(input$teammatesInput, input$champInput))
   })
   
   currWinrate = reactive({
      tmpData = winrates[(champName %in% input$champInput), ]
      return(tmpData$winrate)
   })
   
   winPostReroll = reactive({
      tmpData = winrates[(champName %notin% champsUnion()), ]
      tmpData[, winGain := winrate - currWinrate()]

      tmp.t = t.test(x = tmpData$winGain, alternative = "greater")  # Want the reroll to increase winrate

      return(tmp.t)
   })
   
   # Parse the results of a t-test into a viewer friendly string
   # (to work with 'cat')
   parseResults = reactive({
      tmpT = winPostReroll()
      decision = ifelse(tmpT$estimate > 0 && tmpT$p.value < 0.05, "Reroll", "Don't bother")
      res = paste0("Gain in winrate: ", round(as.numeric(tmpT$estimate)*100, 2), "%\n",
                   "P-value: ", round(as.numeric(tmpT$p.value), 2), "\n",
                   decision, "\n")
   })
   
   output$mainResults = renderText({
      input$goButton
      isolate(parseResults())
   })

   # output$mainResults = renderText({"ayyLmao"})
})