using System.Text.RegularExpressions;

namespace Day5
{
    class MainClass
    {
        public string input = "";
        public List<string> matchingList = new()
            {
                "ab",
                "cd",
                "pq",
                "xy"
            };
        public string[] _lines = new string[] { "" };
        public bool containsThreeVowels = false;
        public bool oneLetterTwiceInARow = false;
        public bool doesNotMatchAListOfStrings = true;
        public double nice_ones = 0;
        public static void Main(string[] args)
        {
            new MainClass().Run(args);
        }
        public void Run(string[] args)
        {
            this.Init();
            this.GetInput(args[0]);
            this.PartOne();

            this.Init();
            this.GetInput(args[0]);
            this.PartTwo();
        }
        public void Init()
        {
            this.input = "";
            this._lines = new string[] { "" };
            this.nice_ones = 0;
            this.containsThreeVowels = false;
            this.oneLetterTwiceInARow = false;
            this.doesNotMatchAListOfStrings = false;
        }
        public void GetInput(string fileName)
        {
            this.input = File.ReadAllText(fileName);
            this._lines = input.Split(Environment.NewLine, StringSplitOptions.RemoveEmptyEntries);
        }

        // is it naughty or nice string?
        public bool IsNiceString(string str)
        {
            // contains atleast 3 vowels
            this.containsThreeVowels = false;
            this.oneLetterTwiceInARow = false;
            this.doesNotMatchAListOfStrings = false;

            // rule 1 contains three vowels
            char[] chars = str.ToCharArray();
            int vowelsCount = 0;
            foreach (char chr in chars)
            {
                switch (chr)
                {
                    case 'a':
                        {
                            vowelsCount++;
                        }
                        break;
                    case 'e':
                        {
                            vowelsCount++;
                        }
                        break;
                    case 'i':
                        {
                            vowelsCount++;
                        }
                        break;
                    case 'o':
                        {
                            vowelsCount++;
                        }
                        break;
                    case 'u':
                        {
                            vowelsCount++;
                        }
                        break;
                }
            }

            if (vowelsCount >= 3)
            {
                containsThreeVowels = true;
            }
            //

            // rule 2 one letter twice in a row appears at least once
            int amountOfDoubleLetters = 0;
            for (int i = 1; i < chars.Length - 1; i++)
            {
                char prev = chars[i - 1];
                char curr = chars[i];
                if (prev == curr)
                {
                    amountOfDoubleLetters++;
                }
            }
            if (amountOfDoubleLetters >= 1)
            {
                oneLetterTwiceInARow = true;
            }
            //
            // rule 3 string does not contain any group of disallowed strings
            List<string> pairs = new();
            for (int i = 1; i < chars.Length - 1; i++)
            {
                char prev = chars[i - 1];
                char curr = chars[i];
                string pair = $"{prev}{curr}";
                pairs.Add(pair);
            }
            foreach (string pair in pairs)
            {
                foreach (string match in matchingList)
                {
                    if (pair != match)
                    {
                        doesNotMatchAListOfStrings = true;
                    }
                    else
                    {
                        doesNotMatchAListOfStrings = false;
                        goto exitloop;
                    }
                }
            }
        exitloop:
            //

            return containsThreeVowels && oneLetterTwiceInARow && doesNotMatchAListOfStrings;
        }

        public void ParseInput(string[] lines_)
        {
            foreach (string line in lines_)
            {
                if (IsNiceString(line))
                {
                    this.nice_ones++;
                    Console.WriteLine("NICE =>                          {0}", line);
                    Console.WriteLine("    contains 3 vowels =>            {0}", this.containsThreeVowels);
                    Console.WriteLine("    contains has double letters =>  {0}", this.oneLetterTwiceInARow);
                    Console.WriteLine("    contains does not match list => {0}", this.doesNotMatchAListOfStrings);
                }
                else
                {
                    Console.WriteLine("naughty =>              {0}", line);
                    Console.WriteLine("    contains 3 vowels =>            {0}", this.containsThreeVowels);
                    Console.WriteLine("    contains has double letters =>  {0}", this.oneLetterTwiceInARow);
                    Console.WriteLine("    contains does not match list => {0}", this.doesNotMatchAListOfStrings);
                    foreach (string str in this.matchingList)
                    {
                        Console.Write("{0}, ", str);
                    }
                    Console.WriteLine("");
                }
            }
        }
        public void PartOne()
        {
            this.ParseInput(this._lines);
            Console.WriteLine("Part 1: {0}", this.nice_ones);
        }
        public void PartTwo()
        {
            Console.WriteLine("Part 2: {0}", "answer goes here");
        }
    }
}
