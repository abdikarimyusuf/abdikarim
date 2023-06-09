import random
from words import words
import string

def get_valid_word(words):
    word = random.choice(words)
    while '-' in word or '' in word:
        word = random.choice(words)

        return word.upper()
    
def hangman():
    word =get_valid_word(words)
    word_letters = set(word)
    alphabet = set(string.ascii_uppercase)
    used_letters = set()
    lives =7

    while len(word_letters) > 0 and lives>0:
      print('you have used these letters: ','' .join(used_letters))

      word_list = [letter if letter in used_letters else '-' for letter in word]

      print ('current word: ', ''.join(word_list))
      user_letter = input ('guess a letter:' ).upper()
      if user_letter in alphabet - used_letters:
        used_letters.add(user_letter)
        if user_letter in word_letters:
            word_letters.remove(user_letter)
        if user_letter not in word_letters:
            lives -= 1
            

        if lives == 0:
           print ('game over!! the right word is: ' + word)
           return
        else:
           print ('you haved gaussed the word')
        
        


      elif user_letter in used_letters:
        print('you have already used that character please try again! ')
      else:
        print('invalid character. please try again!')

hangman()

         






 




