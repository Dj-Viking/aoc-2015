use std::fs::{read_to_string};

fn main() -> () {
   let chararr: Vec<char> = read_to_string("./input.txt").unwrap().chars().collect();
   println!("{:?}", chararr);
}
