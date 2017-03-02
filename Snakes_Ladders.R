
#####################################################################################
###############################   Sample input file   ###############################
#####################################################################################
##		```
##		3
##
##		0.32,0.32,0.12,0.04,0.07,0.13
##		3,7
##		32,62 42,68 12,98
##		95,13 97,25 93,37 79,27 75,19 49,47 67,17
##
##		0.39,0.05,0.14,0.05,0.12,0.25
##		5,8
##		32,62 44,66 22,58 34,60 2,90
##		85,7 63,31 87,13 75,11 89,33 57,5 71,15 55,25
##
##		0.54,0.02,0.02,0.01,0.3,0.11
##		4,9
##		8,52 6,80 26,42 2,72
##		51,19 39,11 37,29 81,3 59,5 79,23 53,7 43,33 77,21
##
##		0.24,0.12,0.18,0.11,0.30,0.05
##		6,11
##		8,52 6,80 26,42 2,72 5,55 82,99
##		51,19 39,11 37,29 81,3 59,5 79,23 53,7 43,33 77,21 99,1 91,3
##		```
#####################################################################################
#####################################################################################

## filename to read the input
fileName <- 'I:\\Tests\\Data-Scientist-master\\Snakes_Ladders_input.txt'

## reading the txt inpout file
input_file <- readChar(fileName, file.info(fileName)$size)
## splitting file line wise
input_file <- strsplit(input_file,"\n")


## defining lists to store board configurations
board_dice_prob = list()
board_snake_ladder = list()
board_ladders_start = list()
board_ladders_end = list()
board_snake_start = list()
board_snake_end = list()


## extracting the number of board configurations provided 
## input file format starts from 2nd line
input_start = 2
input_offset = 0
num_boards = as.numeric(strsplit(input_file[[1]][input_start],"\r"))

## iterate through file to read and store all configurations
for (i in 1:num_boards){
  ## probabilities of the different faces of the die showing up
  board_dice_prob[[i]] <- as.numeric(gsub(' ',',',gsub('\r', '',strsplit(input_file[[1]][input_start+input_offset+2],',')[[1]])))
  
  ## number of ladders and snakes
  board_snake_ladder[[i]] <- as.numeric(gsub(' ',',',gsub('\r', '',strsplit(input_file[[1]][input_start+input_offset+3],',')[[1]])))
  
  ## starting squares of ladders
  board_ladders_start[[i]] <- NA
  for (j in 1:board_snake_ladder[[i]][1]){
    board_ladders_start[[i]][j] <- as.numeric(strsplit(strsplit(gsub('\r', '',input_file[[1]][input_start+input_offset+4]),' ')[[1]][j],',')[[1]][1])
  }

  ## ending squares of ladders
  board_ladders_end[[i]] <- NA
  for (j in 1:board_snake_ladder[[i]][1]){
    board_ladders_end[[i]][j] <- as.numeric(strsplit(strsplit(gsub('\r', '',input_file[[1]][input_start+input_offset+4]),' ')[[1]][j],',')[[1]][2])
  }
  
  ## starting squares of snakes
  board_snake_start[[i]] <- NA
  for (j in 1:board_snake_ladder[[i]][2]){
    board_snake_start[[i]][j] <- as.numeric(strsplit(strsplit(gsub('\r', '',input_file[[1]][input_start+input_offset+5]),' ')[[1]][j],',')[[1]][1])
  }
  
  ## ending squares of snakes
  board_snake_end[[i]] <- NA
  for (j in 1:board_snake_ladder[[i]][2]){
    board_snake_end[[i]][j] <- as.numeric(strsplit(strsplit(gsub('\r', '',input_file[[1]][input_start+input_offset+5]),' ')[[1]][j],',')[[1]][2])
  }
  
  ## lines skip for next configurations
  input_offset = input_offset + 5
}  


## dice faces
dice_faces = c(1,2,3,4,5,6) 

## total number of game simulations for a given board configuration
total_sim = 5000

## max steps allowed to game get completed before terminating and ignoring
max_steps = 1000

## dataframe to store all the simulation steps for each board configuration
game_sim = data.frame(row.names = 1:total_sim)

## dataframe to store average steps and upper/lower margin for each board's simulation
average_steps = data.frame("Board"= numeric(num_boards), 
                           "AverageSteps"= numeric(num_boards), 
                           "UpperMargin" = numeric(num_boards),
                           "LowerMargin" = numeric(num_boards))

## keeps track of numbers of simulation not reaching end after max_steps(1000) steps
terminate = 0


#####################################################################################
## function to check if next position lands on ladder/snake
## returns the next position based on ladder/snake configuration
ladder_snake <- function(next_position,steps){
  
  ## ladder jump evaluation
  ladder_jump = laddersdf$end[which(laddersdf$start==next_position)]
  if (length(ladder_jump) != 0){
    next_position = ladder_jump
  }  
  
  ## snake drop evaluation
  snake_drop = snakesdf$end[which(snakesdf$start==next_position)]
  if (length(snake_drop) != 0){
    next_position = snake_drop
  } 
  
  return (next_position)
}


#####################################################################################

## runs the simulations for num_boards times
for (board in 1:num_boards){
  
  ## message to keep track of Simulations runs
  #print(paste0("Simulating for Board ",board," ..."))
  
  ## dice probabilities
  dice_prob = board_dice_prob[[board]] 
 
  ## ladder configurations
  ladders = board_snake_ladder[[board]][1]
  laddersdf = data.frame(row.names=1:ladders)
  laddersdf$start = board_ladders_start[[board]]
  laddersdf$end = board_ladders_end[[board]]
 
  
  ## snakes configurations
  snakes = board_snake_ladder[[board]][2]
  snakesdf = data.frame(row.names=1:snakes)
  snakesdf$start = board_snake_start[[board]]
  snakesdf$end = board_snake_end[[board]]
 
  ## configuration should not allow more than fifteen snakes and fifteen ladders
  if (snakes > 15 | ladders > 15){
    print(paste0("Snakes or Ladders can't be more than 15 on a Board: "),board)
    break;
  }
  
  ## dataframe to store current board's simulation step
  board_steps <- data.frame(row.names = 1:total_sim)
  
  ## reinitiate for current board's simulation
  terminate = 0
  
  ## run simulation for total_sim(5000) times
  for (sim_run in 1:total_sim){
    
    ## start from Square 1
    start_position = 1
    
    ## runs each simulation for max_steps(1000) before terminating 
    ## or game over whichever is earlier
    for (steps in 1:max_steps){
      
      ## assigns current position with next position 
      ## or start position if its the first step
      if (steps == 1){
        current_position = start_position
      } else{
        current_position = next_position
      }
      
      
      ## dice outcome based on probability
      dice_outcome = sample(dice_faces, size = 1, replace = T, prob = dice_prob)
 
      ## next proposed square position
      next_position = current_position + dice_outcome
      
      ## checking the snakes & ladders to finalise next position
      next_position = ladder_snake(next_position,steps)
      
      ## if proposed next position is a square greater than 100, 
      ## dice roll goes waste, and the player remains at his current position
      if (next_position > 100){
        next_position = current_position
      }
      
      ## game gets completed when next position is 100
      if (next_position == 100){
        break;
      }
    }
    
    ## if after max_steps(1000) game hasn't terminated (i.e. square #100 hasn't been reached) 
    ## the current simulations will be ignored
    ## steps count would be restore to 0 and terminate count increases
    if (next_position != 100){
      steps <- 0
      terminate = terminate + 1
    }
    
    ## store steps for simulation in dataframe
    Board_name = paste0('Board_',board)
    board_steps[[Board_name]][sim_run] <- steps
  }
  
  ## combine current simulations steps count with earlier ones
  game_sim <- cbind(game_sim,board_steps)
  
  ## store all results in dataframe
  average_steps$Board[board] <- Board_name
  average_steps$AverageSteps[board] <- sum(board_steps)/(total_sim-terminate)
  average_steps$UpperMargin[board] <- average_steps$AverageSteps[board]*1.1
  average_steps$LowerMargin[board] <- average_steps$AverageSteps[board]*0.9
  
  print(average_steps$AverageSteps[board])
}

## display all the boards results at once
print(paste0("Summary for the ",board," simulations:"))
print(average_steps)
View(average_steps)
#####################################################################
#####################################################################
