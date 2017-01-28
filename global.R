##
#
# Shiny global variables
#
##

source('RerollFunctions.R')

winrates = readRDS("winrates.rds")
setorder(winrates, "champName")
