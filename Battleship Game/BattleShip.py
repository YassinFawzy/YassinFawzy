# import random for all computer moves like choosing ship locations and shooting at the player
import random as r

# initializing boards one for the pc to hide its ships, one for the player to shoot on
# and finally a board for the player to place his ships and for the computer to shoot on
PC_board = [[" "]*10 for x in range(10)]
player_guessing = [[" "]*10 for x in range(10)]
player_ships = [[" "]*10 for x in range(10)]
letters=["a", "b", "c", "d", "e", "f", "g", "h", "i", "j"]
convert= {"a": 1, "b": 2, "c": 3, "d": 4, "e": 5, "f": 6, "g": 7, "h": 8, "i": 9, "j": 10}

# the show_board function joins the lists in the board to display it in a grid like fashion
def show_board(board) :
    print()
    print("  1 2 3 4 5 6 7 8 9 10")
    row = 0
    for i in board:
        x = "|".join(i)
        print(f"{letters[row]}|{x}|")
        row += 1
    print()
    return ""
    

# this for loop is used for the computer to place its ships
# a while loop is used inside to make sure the computer doesnt place 2 oe more ships in one grid space
for i in range(10):
    PC_board[r.randint(1, 10)-1][r.randint(1, 10)-1] = "x"
    while PC_board[r.randint(1, 10)-1][r.randint(1, 10)-1] == "x":
        PC_board[r.randint(1, 10) - 1][r.randint(1, 10) - 1] = "x"


# this for loop is used to let the player place his ships
# a while loop is used to make sure the player doesnt place 2 or more ships in the same grid space
for i in range(10):
    while True:
        ship_row = input(f"please input ship row for ship number {i+1} from a to j: ").lower()
        if ship_row in letters:
            break
        else:
            print(f"Must input a letter from a to j")
            continue

    while True:
        try:
            ship_column = int(input(f"please input ship column for ship number {i+1}: "))
            if 1<=ship_column<=10:
                break
            else:
                print(f"The number has to be between 1 and 10!!\n")
                continue
            
        except ValueError:
            print(f"Input for column must be a number")
            continue

    while player_ships[convert[ship_row] - 1][ship_column - 1] == "x":
        print("you have already placed a ship here, choose another grid space")
        while True:
            ship_row = input(f"please input ship row for ship number {i + 1} from a to j: ").lower()
            if ship_row in letters:
                break
            else:
                continue

        while True:
            try:
                ship_column = int(input(f"please input ship column for ship number {i + 1}:"))
                if 1<=ship_column<=10:
                    break
                else:
                    print(f"The number has to be between 1 and 10!!\n")
                    continue
            except ValueError:
                print(f"Input for column must be a number")
                continue

    player_ships[convert[ship_row] - 1][ship_column - 1] = "x"
    show_board(player_ships)

# initializing the hits and misses counter for both the player and the computer
computer_hit = 0
player_hit = 0
player_misses = 0
computer_misses = 0

print("\n------------------------")
print("the game will now start!")
print("------------------------\n")

# every iteration of this while loop is a turn for the player and then a turn for the computer
while computer_hit < 10 and player_hit < 10:

    # the player chooses where to shoot
    while True:
        shot_row = input(f"please input shot row from a to j:").lower()
        if shot_row in letters:
            break
        else:
            print(f"You need to choose a letter between a and j!!\n")
            continue

    while True:    
        try:
            shot_column = int(input("please input the shot column: "))
            if 1<=shot_column<=10:
                break  
            else:
                print(f"The number has to be between 1 and 10!!\n")
                continue
        except ValueError:
            print(f"The input must be a number!!\n")
            continue

    # while loop to make sure player hasn't shot this grid space before
    while player_guessing[convert[shot_row] - 1][shot_column - 1] == "-" or player_guessing[convert[shot_row] - 1][shot_column - 1] == "x":
        print("you have already shot this grid space. shoot again")
        show_board(player_guessing)

        while True:
            shot_row = input(f"please input shot row from a to j:").lower()
            if shot_row in letters:
                break
            else:
                print(f"You need to choose a letter between a and j!!\n")
                continue
            
        while True:    
                try:
                    shot_column = int(input("please input the shot column: "))
                    if 1<=shot_column<=10:
                        break
                    else:
                        print(f"The number has to be between 1 and 10!!\n")
                        continue
                except ValueError:
                    print(f"The input must be a number!!\n")
                    continue

    # if statement to determine if user has hit or has missed
    if PC_board[convert[shot_row] - 1][shot_column - 1] == "x":
        player_hit += 1
        print(f"you have hit a battleship there are {10-player_hit} battleships left ")
        player_guessing[convert[shot_row] - 1][shot_column - 1] = "x"
        PC_board[convert[shot_row] - 1][shot_column - 1] = "0"
        show_board(player_guessing)
    else:
        print(f"you have missed your shot! there are {10-player_hit} battleships left")
        player_misses += 1
        player_guessing[convert[shot_row] - 1][shot_column - 1] = "-"
        show_board(player_guessing)

    # if statement to check if user has sunk all 10 of the computers ships
    if player_hit == 10:
        print("you have sunk all the battleships! YOU WIN!")
        print(f"Player shots hit: {player_hit}, Player shots missed: {player_misses}\nComputer shots hit: {computer_hit}, Computer shots missed: {computer_misses}")
        print(f"Player Ships: ")
        show_board(player_ships)
        print(f"PLayer Guesses: ")
        show_board(player_guessing)
        print(f"Computer Board: ")
        show_board(PC_board)
        break

    # computer's turn starts
    print("\nthe computer will now shoot")
    PC_shot_row = r.randint(1, 10)
    PC_shot_column = r.randint(1, 10)

    # while loop to check if computer has shot this grid space before
    while player_ships[PC_shot_row - 1][PC_shot_column - 1] == "-" or player_ships[PC_shot_row - 1][PC_shot_column - 1] == "0":
        PC_shot_row = r.randint(1, 10)
        PC_shot_column = r.randint(1, 10)

    # if statement to determine if the computer has hit one of the user's ships
    if player_ships[PC_shot_row - 1][PC_shot_column - 1] == "x":
        computer_hit += 1
        print(f"the computer has sunk one of your ships! you have {10-computer_hit} ships left")
        player_ships[PC_shot_row - 1][PC_shot_column - 1] = "0"
        show_board(player_ships)
    else:
        print(f"the computer has missed it's shot! you have {10-computer_hit} ships left")
        computer_misses += 1
        player_ships[PC_shot_row - 1][PC_shot_column - 1] = "-"
        show_board(player_ships)

    # if statement to determine if the computer has sunk all of the users ships
    if computer_hit == 10 :
        print(f"all your battleships have been sunk! YOU HAVE LOST!")
        print(f"Player shots hit: {player_hit}, Player shots missed: {player_misses}\nComputer shots hit: {computer_hit}, Computer shots missed: {computer_misses}")
        print(f"Computer Board: ")
        show_board(PC_board)
        print(f"Player Board: ")
        show_board(player_ships)
