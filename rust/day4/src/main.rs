// cargo run
// author: dj-viking
use md5;
use std::string::String;

// fn main1() {
//     for i in 0..5 { println!("{}", i); }
// }

fn main() {
    // start with initial input string
    // 
    let mut input = String::new();
    input += "iwrupvqb";
    let mut acc: i32 = 0;
    // create a new string appending a zero
    // in front of the original string
    //
    // in a loop
    // construct md5 hash out of the new string

    loop {
        let _input = input.clone()
            + &acc.to_string();
        let digest = md5::compute(_input.clone());
        //println!("num {} | md5 => {:?}", acc, digest);

        //
        // check how many zeros are in the
        // md5 hash and if the amount of consecutive
        // zeros are in the string
        // i.e. 00000ffacd3 or whatever theres 5 zeros
        // in a row consecutively
        //
        let mut zeros: i64 = 0;

        for i in 0..5 {
            if format!("{:x}", digest)
            .chars().nth(i).unwrap() == '0' {
                if acc % 10000 == 0 { 
                    println!(
                        "zeros {} | input {} | md5 => {:x}",
                        zeros, _input.clone(), digest);
                    println!("{} current accumulation", acc);
                }
                zeros += 1;
                if zeros == 5 {
                    break;
                }
            }
        }
        if zeros == 5 { break; }

        acc += 1;
        // if acc == 5 { break; }
    }
    // then the accumulated number used
    // as the combination with the input string
    // to create the md5 hash construction
    // is the answer
    //
    println!("part1: {}", acc);
}
