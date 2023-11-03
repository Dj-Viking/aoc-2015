using System.Diagnostics.Contracts;
using System.Text.RegularExpressions;

namespace Day5
{
    class MainClass
    {
        bool part2 = false;
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
            this.part2 = true;
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

        public static bool IsVowel(char chr)
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

        public static bool IsNiceString2(string str)
        {
            // cheated...this problem fucking sucks!
            var appearsTwice = Enumerable.Range(0, str.Length - 1).Any(i => str.IndexOf(str.Substring(i, 2), i + 2) >= 0);
            var repeats = Enumerable.Range(0, str.Length - 2).Any(i => str[i] == str[i + 2]);
            return appearsTwice && repeats;

        }

        // is it naughty or nice string?
        public static bool IsNiceString(string str)
        {
            int vowelCount = 0;
            bool pairExists = false;

            char last_char = ' ';
            char[] chars = str.ToCharArray();
            for (int i = 0; i < chars.Length; i++)
            {
                char current_char = chars[i];
                if (IsVowel(current_char))
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
                if (!part2)
                {
                    if (IsNiceString(line))
                    {
                        this.nice_ones++;
                    }

                }
                else
                {
                    if (IsNiceString2(line))
                    {
                        this.nice_ones++;
                        Console.WriteLine("nice {0}", line);
                    }
                    else
                    {
                        Console.WriteLine("not nice {0}", line);
                    }
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
            this.ParseInput(this._lines);
            Console.WriteLine("Part 2: {0}", this.nice_ones);
        }
    }
}
