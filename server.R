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
   
   rerollWinrates = reactive({
     tmpData = winrates[(champName %notin% champsUnion()), ]
     return(tmpData)
   })
   
   winPostReroll = reactive({
      tmpData = rerollWinrates()
      tmpData[, winGain := winrate - currWinrate()]

      tmp.t = t.test(x = tmpData$winGain, alternative = "greater")  # Want the reroll to increase winrate

      return(tmp.t)
   })
   
   # Parse the results of a t-test into a viewer friendly string
   # (to work with 'cat')
   parseResults = reactive({
      # If both input boxes are empty, print a useful message
      if (is.null(champsUnion()))
         return("<font color=\"#FF0000\"><font size=2>Please enter your team composition.</font></font>")
      
      cat(file = stderr(), champsUnion())
      tmpT = winPostReroll()
      decision = ifelse(tmpT$estimate > 0 && tmpT$p.value < 0.05, "Reroll", "Don't bother")
      res = paste0("Gain in winrate: <b>", round(as.numeric(tmpT$estimate)*100, 2), "%</b>\n",
                   "P-value: <i>", round(as.numeric(tmpT$p.value), 2), "</i>\n",
                   decision, "\n")
      return(paste0("<font size=2>", res, "</font>"))
   })
   
   winnerWinrates = reactive({
      allWinrates = rerollWinrates()
      setorder(allWinrates, -winrate)
      allWinrates[, winrate := round(winrate, 2)]
      return(head(allWinrates, 5))
   })
   
   loserWinrates = reactive({
      allWinrates = rerollWinrates()
      setorder(allWinrates, winrate)
      allWinrates[, winrate := round(winrate, 2)]
      return(head(allWinrates, 5))
   })
   
   output$mainResults = renderText({
      input$goButton
      isolate(parseResults())
   })
   
   output$winnerWinrates = renderDataTable({
      input$goButton
      isolate(winnerWinrates())
   })
   
   output$loserWinrates = renderDataTable({
      input$goButton
      isolate(loserWinrates())
   })

   # output$mainResults = renderText({"ayyLmao"})
})