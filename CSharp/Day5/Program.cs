using System.Text.RegularExpressions;

namespace Day5
{
    class MainClass
    {
        public string input = "";
        public string[] _lines = new string[] { "" };
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
        }
        public void GetInput(string fileName)
        {
            this.input = File.ReadAllText(fileName);
            this._lines = input.Split(Environment.NewLine);
        }

        // is it naughty or nice string?
        public static bool IsNiceString(string str)
        {
            // contains atleast 3 vowels
            bool containsThreeVowels = false;
            bool oneLetterTwiceInARow = false;
            bool doesNotMatchAListOfStrings = false;
            List<string> matchingList = new()
            {
                "ab",
                "cd",
                "pq",
                "or",
                "xy"
            };

            // rule 1 contains three vowels
            char[] chars = str.ToCharArray();
            uint vowelsCount = 0;
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
            // rule 3 string contains any group of strings
            foreach (string match in matchingList)
            {
                if (str.Contains(match))
                {
                    doesNotMatchAListOfStrings = false;
                    break;
                }
            }
            //

            return containsThreeVowels && oneLetterTwiceInARow && doesNotMatchAListOfStrings;
        }

        public void ParseInput(string[] lines_)
        {
            foreach (string line in lines_)
            {
                Console.WriteLine("line => {0}", line);
                if (IsNiceString(line))
                {
                    this.nice_ones++;
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
