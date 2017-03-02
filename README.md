# Simulation-Snakes-Ladders
This problem is based on Markov Models and Simulation

The Snakes&Ladders game simulation is implemented in R.

For each board following configurations are given-
  - A 6-faced dice with some probability for each face.
  - Fixed number of snakes and ladders, should not exceed count 15.
  - Start and end points for each snake and ladders.
  
General rule for simulation-
  - For each board 5000 simulation runs.
  - Game ends when position reaches exact 100, if goes above 100, chance is ignored.
  - If game doesn't end after 1000 dice rolls, the game is ignored.
  
Input file description-
  - First line contains the number of tests, T. 
  - There are 4 lines per test configuration and in each test: 
  - The first line is a list of six comma-separated probabilities with which different faces of the die appear. 
  - The second line contains the number of ladders and snakes, separated by a comma. 
  - The third is a list of comma separated pairs indicating the starting and ending squares of the ladders. 
  - The fourth is a list of comma separated pairs indicating the starting and ending (mouth and tail) squares of the snakes.

Output-
