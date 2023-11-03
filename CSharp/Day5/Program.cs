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

        public static bool isVowel(char chr)
        {
            return chr == 'a' || chr == 'e' || chr == 'i' || chr == 'o' || chr == 'u';
        }

        public static bool IsBadPair(char last, char curr)
        {
            return
                (last == 'a' ||
                last == 'c' ||
                last == 'p' ||
                last == 'x')

                && curr == last + 1;
        }

        // is it naughty or nice string?
        public bool IsNiceString(string str)
        {
            int vowelCount = 0;
            bool pairExists = false;

            char last_char = ' ';
            char[] chars = str.ToCharArray();
            for (int i = 0; i < chars.Length; i++)
            {
                char current_char = chars[i];
                if (isVowel(current_char))
                {
                    vowelCount++;
                }

                if (i > 0 && current_char == last_char)
                {
                    pairExists = true;
                }

                if (i > 0 && IsBadPair(last_char, current_char))
                {
                    return false;
                }
                last_char = current_char;
            }

            return vowelCount >= 3 && pairExists;
        }

        public void ParseInput(string[] lines_)
        {
            foreach (string line in lines_)
            {
                if (this.IsNiceString(line))
                {
                    this.nice_ones++;
                    Console.WriteLine("NICE =>                          {0}", line);
                    Console.WriteLine("    contains 3 vowels =>            {0}", this.containsThreeVowels);
                    Console.WriteLine("    contains has double letters =>  {0}", this.oneLetterTwiceInARow);
                    Console.WriteLine("    contains does not match list => {0}", this.doesNotMatchAListOfStrings);
                    foreach (string str in this.matchingList)
                    {
                        Console.Write("{0}, ", str);
                    }
                    Console.WriteLine("");
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
