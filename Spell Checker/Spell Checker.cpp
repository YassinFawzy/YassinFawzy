#include <fstream>
#include <string>
#include <vector>
#include <sstream>
#include <algorithm>
#include <unordered_map>
#include <queue>
#include <stack>
#include <iostream>
using namespace std;

void printMap(unordered_map<int, string> d)
{
  for (const auto &key_value : d)
  {
    int key = key_value.first;
    string value = key_value.second;

    cout << key << " - " << value << endl;
  }
}

vector<string> tokenize(const string &filename)
{
  ifstream file(filename);
  vector<string> tokens;
  string line;

  while (getline(file, line))
  {
    stringstream lineStream(line);
    string token;
    while (lineStream >> token)
    {
      // Transform the token to lower case
      transform(token.begin(), token.end(), token.begin(), ::tolower);
      tokens.push_back(token);
    }
  }

  return tokens;
}

int levenshteinDistance(const std::string &s1, const std::string &s2)
{
  // Create a table to store results of sub-problems
  int dp[s1.size() + 1][s2.size() + 1];

  // Initialize the distance for empty strings
  for (int i = 0; i <= s1.size(); i++)
  {
    dp[i][0] = i;
  }
  for (int j = 0; j <= s2.size(); j++)
  {
    dp[0][j] = j;
  }

  // Fill the table
  for (int i = 1; i <= s1.size(); i++)
  {
    for (int j = 1; j <= s2.size(); j++)
    {
      if (s1[i - 1] == s2[j - 1])
      {
        dp[i][j] = dp[i - 1][j - 1];
      }
      else
      {
        dp[i][j] = std::min({dp[i - 1][j], dp[i][j - 1], dp[i - 1][j - 1]}) + 1;
      }
    }
  }

  // Return the distance
  return dp[s1.size()][s2.size()];
}

int main()
{
  // Output File
  ofstream opFile("output.txt");

  // Stores dictionary and sample text into vectors
  vector<string> dictWords = tokenize("dict.txt");
  vector<string> textWords = tokenize("input.txt");

  // Hashmap initialization
  unordered_map<string, string> dictionary;

  // Final Stack Initialisation
  stack<string> checkedWords;
  stack<string> FinalStack;

  // Queue Initialization
  queue<string> wordQueue;
  for (string i : textWords)
    wordQueue.push(i);

  // Stores dictionary words into 'dictionary' hashmap
  for (const string &token : dictWords)
  {
    dictionary[token] = token;
  }

  // Check to see whether word is in the dicitonary or not
  while (!wordQueue.empty())
  {
    string i = wordQueue.front();
    wordQueue.pop();
    // Remove . if there is one
    string oldI= i;
    string newI;
    if (i.find('.') != std::string::npos)
      i.pop_back();
    newI = i;

    // If the word is not in the dictionary give suggestions then place chosen suggestion into the file
    if (dictionary.find(newI) == dictionary.end())
    {
      unordered_map<int, string> top3 = {{0, newI}};
      int chosenWord;
      int key = 1;

      for (string j : dictWords)
      {
        int distance = levenshteinDistance(newI, dictionary[j]);
        if (distance == 1)
        {
          top3[key] = dictionary[j];
          key++;
        }
        if(key==4)
          break;
      }

      printMap(top3);
      cout << "Which word would you like to use(insert number, 0 is keep same): ";
      cin >> chosenWord;

      checkedWords.push(top3[chosenWord]);
      if (oldI.find('.') != std::string::npos)
      {
        checkedWords.push(".");
        checkedWords.push("\n");
      }
    }
    // If the word is in the dictionary it will be pasted as is
    else
    {
      checkedWords.push(newI);
    }
  }

  while(!checkedWords.empty()){
    FinalStack.push(checkedWords.top());
    checkedWords.pop();
  }

  while (!FinalStack.empty())
  {
    string word = FinalStack.top();
    opFile << word << " ";
    FinalStack.pop();
  }

  opFile.close();
}
