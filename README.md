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
  
Input-
```
4

0.32,0.32,0.12,0.04,0.07,0.13
3,7
32,62 42,68 12,98
95,13 97,25 93,37 79,27 75,19 49,47 67,17

0.39,0.05,0.14,0.05,0.12,0.25
5,8
32,62 44,66 22,58 34,60 2,90
85,7 63,31 87,13 75,11 89,33 57,5 71,15 55,25

0.54,0.02,0.02,0.01,0.3,0.11
4,9
8,52 6,80 26,42 2,72
51,19 39,11 37,29 81,3 59,5 79,23 53,7 43,33 77,21

0.24,0.12,0.18,0.11,0.30,0.05
4,1
8,52 6,80 26,42 2,72
51,19
```
  - First line contains the number of tests, T. 
  - There are 4 lines per test configuration and in each test: 
  - The first line is a list of six comma-separated probabilities with which different faces of the die appear. 
  - The second line contains the number of ladders and snakes, separated by a comma. 
  - The third is a list of comma separated pairs indicating the starting and ending squares of the ladders. 
  - The fourth is a list of comma separated pairs indicating the starting and ending (mouth and tail) squares of the snakes.


Output-
Average number of steps taken to complete the game for 4 boards configuration respectively
```
  [1] 156.3404
  [1] 97.09044
  [1] 165.7229
  [1] 19.2846
  
  [1] "Summary for the 4 simulations:"
    Board AverageSteps UpperMargin LowerMargin
1 Board_1    156.34036   171.97440   140.70632
2 Board_2     97.09044   106.79948    87.38139
3 Board_3    165.72287   182.29516   149.15058
4 Board_4     19.28460    21.21306    17.35614
```
UpperMargin and LowerMargin and +/- 10% of the AverageSteps
