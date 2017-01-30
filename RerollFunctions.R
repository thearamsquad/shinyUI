# Common libraries and functions for the reroll UI project

if (!require('data.table'))
   install.packages('data.table')
if (!require('shiny'))
   install.packages('shiny')
if (!require('stringr'))
   install.packages('stringr')
if (!require('devtools'))
   install.packages('devtools')
if (!require('shinysky'))
   devtools::install_github("AnalytixWare/ShinySky")

library('data.table')
library('shiny')
library('stringr')
library('shinysky')  # Install by running   devtools::install_github("AnalytixWare/ShinySky")

`%notin%` = function(x, y) {
   return(!(x %in% y))
}
