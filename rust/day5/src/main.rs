/*
        It contains at least three vowels (aeiou only), like aei, xazegov, or aeiouaeiouaeiou.
        It contains at least one letter that appears twice in a row, like xx, abcdde (dd), or aabbccdd (aa, bb, cc, or dd).
        It does not contain the strings ab, cd, pq, or xy, even if they are part of one of the other requirements.
    */
use std::collections::HashMap;
use std::collections::hash_map::Entry;
use std::string::String;
use std::io;

// find the "nice" strings 
// if the string follows the rules then it's considered "nice"

pub fn insert_or_inc(key: &String, hm: &mut HashMap::<String, i64>) -> () {
    if !hm.contains_key(key) {
        hm.insert(key.to_string(), 1);
    } else {
        hm.entry(key.to_string())
        .and_modify(|x| *x += 1);
    }
}

pub fn is_vowel(letter: &String) -> bool {
    if letter == "a" || letter == "e" || letter == "i" || letter == "o" || letter == "u" {
        // println!("got a vowel! {}", letter);
        return true;
    }
    return false;
}

pub fn has_enough_vowels(hm: &mut HashMap::<String, i64>) -> bool {
    let mut acc = 0;

    if let Entry::Occupied(a) = hm.entry("a".to_string()) {
        acc += a.get();
        // println!("{:?}, a occupied!", a.get())
    }
    if let Entry::Occupied(e) = hm.entry("e".to_string()) {
        acc += e.get();
        // println!("{:?}, e occupied!", e.get())
    }
    if let Entry::Occupied(i) = hm.entry("i".to_string()) {
        acc += i.get();
        // println!("{:?}, i occupied!", i.get())
    }
    if let Entry::Occupied(o) = hm.entry("o".to_string()) {
        acc += o.get();
        // println!("{:?}, o occupied!", o.get())
    }
    if let Entry::Occupied(u) = hm.entry("u".to_string()) {
        acc += u.get();
        // println!("{:?}, u occupied!", u.get())
    }

    if acc >= 3 { return true; }

    false
}

pub fn has_double_consec_letter(splitstr: &Vec<String>) -> bool {
    for i in 0..splitstr.len() {
        if i > 0 {
            let prev = &splitstr[i - 1];
            if *prev == splitstr[i] { return true; }
        }
    }
    false
}

pub fn doesnt_contain_ab_cd_pq_or_xy(splitstr: &Vec<String>) -> bool {
    for i in 0..splitstr.len() {
        if i > 0 {
            let curr = &splitstr[i];
            let prev = &splitstr[i - 1];

            let prevchar = prev.chars().collect::<Vec<char>>()[0];
            let currchar = curr.chars().collect::<Vec<char>>()[0];
            
            if (prevchar == 'a' ||
                prevchar == 'c' ||
                prevchar == 'p' ||
                prevchar == 'x')
                && 
                currchar == move_shift(&prevchar.to_string(), 1)
                    .chars().collect::<Vec<char>>()[0]
            {
                return false
            }

        }
    }
    true
}

// increments char by an amount basically like
// an operator overloaded csharp char which can use + operator
// i.e. 'a' + 1 => b
pub fn move_shift(d: &String, shift: usize) -> String {
    d.chars()
        .map(|c| (c as u8 + shift as u8) as char)
        .collect::<String>()
}

#[allow(dead_code)]
fn main1() {

    let strr: String = "fab".to_string();
    let strarr: Vec<String> = strr.split("")
        .filter_map(|x| if !x.to_string().is_empty() {
            Some(x.to_string())
        } else { None }).collect();

    println!("{:?}", strarr);
    let s = doesnt_contain_ab_cd_pq_or_xy(&strarr);
    let a = "a".to_string();
    println!("increment a to b {}",
        move_shift(&a, 1)
    );
    println!("{}", s);
}
pub fn part1() {

    // part 1

    let mut nice_strings = 0;

    let lines: Vec<String> = std::fs::read_to_string("input")
        .unwrap()
        .lines()
        .map(|x: &str| x.to_string())
        .collect::<Vec<String>>();
        // find the vowels

    for i in 0..lines.len() {

        let mut letter_dict = HashMap::<String, i64>::new();

        let splitstr: Vec<String> = lines[i].split("")
            // take out empty string entries
            .filter_map(|x| { 
                if !x.to_string().is_empty() { 
                    Some(x.to_string()) 
                } else { None } 
            })
            .collect();

        // println!("line {}", lines[i]);
        for i in 0..splitstr.len() {
            if is_vowel(&splitstr[i]) {
                insert_or_inc(&splitstr[i], &mut letter_dict);
            }
        }

        // passes all the validations?
        if has_enough_vowels(&mut letter_dict) 
            && has_double_consec_letter(&splitstr)
            && doesnt_contain_ab_cd_pq_or_xy(&splitstr)
        {
            nice_strings += 1;
        }


        // break;
    }
    // 269 is too high!!! what am i doing wrong??
    // 255 got it :))))
    println!("part 1: {:?}", nice_strings);
}

// cheated...this problem fucking sucks!
// kept getting 56 but some weren't making sense
// some seemed wrong but others may have been false
// positives somehow and I can't fucking figure it out
// i would literally have to sit through every single
// fucking line of text and fucking check rules on it
// to know where I went wrong
// fuck that!!!!!!!!!
//
//
//
//
// FUCK THIS PROBLEM!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
pub fn does_whatever_the_fuck_to_solve_this_fucking_shit(splitstr: &Vec<String>) -> bool {
    // var appearsTwice = Enumerable.Range(
    //         0, str.Length - 1
    // ).Any(i => str.IndexOf(
    //         str.Substring(i, 2), i + 2
    //      ) >= 0);
    // var repeats = Enumerable.Range(
    //         0, str.Length - 2
    // ).Any(i => str[i] == str[i + 2]);
    false
}
pub fn part2() -> () {

    let mut buffer = String::new();
    let mut nice_strings = 0;

    let lines: Vec<String> = std::fs::read_to_string("input")
        .unwrap()
        .lines()
        .map(|x: &str| x.to_string())
        .collect::<Vec<String>>();

    for i in 0..lines.len() {

        let mut letter_dict = HashMap::<String, i64>::new();
        let splitstr: Vec<String> = lines[i].split("")
            // take out empty string entries
            .filter_map(|x| { 
                if !x.to_string().is_empty() { 
                    Some(x.to_string()) 
                } else { None } 
            })
            .collect();
        

        if does_whatever_the_fuck_to_solve_this_fucking_shit(&splitstr){ 
            nice_strings += 1;
        }
        // panic!();
    }
    println!("part 2: {}", nice_strings);
}
fn main() {
    part1();
    //part2();
}
