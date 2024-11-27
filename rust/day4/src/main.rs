// cargo run
// author: dj-viking
use md5;
use std::string::String;


fn solve(part: i64) -> () {
    // start with initial input string
    // 
    let partnum = if part == 1 { 5 } else { 6 };
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

        for i in 0..partnum {
            let thing = format!("{:x}", digest);

            // optimizations..
            // skip hashes that don't start with '0'
            if thing
                .chars().nth(0).unwrap() != '0' { break; }

            // optimizations..
            // skip if some zeros existed but then 
            // hit non-zero chars
            // without reaching the goal
            if zeros > 0 && zeros < partnum && thing
            .chars().nth(i.try_into().unwrap()).unwrap() != '0' {
                break;
            }

            if thing
            .chars().nth(i.try_into().unwrap()).unwrap() == '0' {
                zeros += 1;
                if zeros == 5 { 
                    println!("processing... {} | {:?}", acc, digest);
                }
                if zeros == partnum.try_into().unwrap() {
                    break;
                }
            }
        }
        if zeros == partnum.try_into().unwrap() { break; }

        acc += 1;
        // if acc == 5 { break; }
    }
    // then the accumulated number used
    // as the combination with the input string
    // to create the md5 hash construction
    // is the answer
    //
    println!("part {}: {}", part, acc);
}
fn main() {
    solve(1);
    // part 2 takes a little while 
    // it could be optimized more maybe...
    solve(2);
}
