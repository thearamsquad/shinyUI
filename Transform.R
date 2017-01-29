##
#
# Transforming the gameData table for use in shiny server
#
##
rm(list = ls())

source('RerollFunctions.R')

gameData = fread('gamedataAram.csv') # 570,621 unique games
champList = fread('champlist.csv')

# Remove unnecessary columns
gameData[, `:=`(gameMode = NULL,
                gameType = NULL,
                subType = NULL,
                mapId = NULL,
                createDate = NULL,
                s1summonerId = NULL,
                s2summonerId = NULL,
                s3summonerId = NULL,
                s4summonerId = NULL,
                s5summonerId = NULL,
                s6summonerId = NULL,
                s7summonerId = NULL,
                s8summonerId = NULL,
                s9summonerId = NULL,
                s10summonerId = NULL)]

# Unpivot the gameData table to get each champ on a separate row
champs = melt(gameData,
              measure.vars = c("s1championId", "s2championId", "s3championId", "s4championId", "s5championId",
                               "s6championId", "s7championId", "s8championId", "s9championId", "s10championId"),
              id.vars = c("gameId", "teamWin"),
              value.name = "champId")
champs[, summonerNum := str_match(variable, "\\d+")]
champs[, variable := NULL]

# Unpivot the gameData table to get each teamID on a separate row
# This will be merged with champs to identify which champ is on which team in each game
teams = melt(gameData,
             measure.vars = c("s1teamId", "s2teamId", "s3teamId", "s4teamId", "s5teamId",
                              "s6teamId", "s7teamId", "s8teamId", "s9teamId", "s10teamId"),
             id.vars = c("gameId"),
             value.name = "teamId")
teams[, summonerNum := str_match(variable, "\\d+")]
teams[, variable := NULL]

games = merge(champs, teams,
              by = c("gameId", "summonerNum"))
games = merge(games, champList,
              by.x = c("champId"),
              by.y = c("champion_id"))
setnames(games, c("champId", "gameId", "summonerNum", "teamWin", "teamId", "champName"))
setorder(games, "gameId")

games[, won := (teamId == teamWin)]  # Did the champ win that game

saveRDS(games, file = "gamesTransformed.rds")
