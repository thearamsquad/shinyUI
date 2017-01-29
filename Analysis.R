##
#
# Analyse the transformed gameData table to find trends
# and explore potential ways to efficiently calculate winrates
#
# First iteration will be using a naive estimation
# that assumes champions are completely independent
#
##
rm(list = ls())

source('RerollFunctions.R')

games = readRDS("gamesTransformed.rds")
champs = fread("champlist.csv")

# Remove incomplete data, some games may not have 10 entries
numChamps = games[, list(numchamps = length(champId)),
                  by = c("gameId")]
completeGames = numChamps[(numchamps == 10), gameId]
games = games[(gameId %in% completeGames), ]

# Simple naive winrate table
winrates = games[, .(winrate = sum(won)/length(won)), by = "champName"]

saveRDS(winrates, "winrates.rds")


# Pairwise interaction
champPairs = data.table(champ1 = rep(champs$champion_id, times = nrow(champs)),
                        champ2 = rep(champs$champion_id, each = nrow(champs)))
setorder(champPairs, champ1, champ2)


pairWinrates = numeric(length = nrow(champPairs))
for (i in 1:nrow(champPairs)) {
   currChamps = champPairs[i, ]
   
   # Games involving these champions
   champGames = games[(champId %in% currChamps),
                      list(bothIn = ifelse(all(currChamps %in% champId), TRUE, FALSE),
                           teamWon = unique(teamWin)),
                      by = c("gameId", "teamId")]
   
   # Find the games when these 2 champs were on the same team
   validGames = champGames[(bothIn == TRUE), ]
   validGames[, pairWon := ifelse(teamId == teamWon, TRUE, FALSE)]
   
   pairWinrates[i] = sum(validGames$pairWon)/nrow(validGames)
   
   # Report progress
   cat("\rProgress: ", i, "/", nrow(champPairs))
}
champPairs[, pairWinrates := pairWinrates]
