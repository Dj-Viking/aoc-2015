// cargo run
// author: dj-viking
use md5;

fn main() {
    // start with initial input string
    // 
    let mut input = "iwrupvqb"; 
    let mut acc = 0;
    // create a new string appending a zero
    // in front of the original string
    //
    // in a loop
    // construct md5 hash out of the new string

    loop {
        println!("whats it now {input}{acc}");
        let digest = md5::compute(b"{input}{acc}");
        println!("md5 => {:?}", digest);
        acc += 1;
        if acc == 5 { break };
    }
    //
    // check how many zeros are in the
    // md5 hash and if the amount of consecutive
    // zeros are in the string
    // i.e. 00000ffacd3 or whatever theres 5 zeros
    // in a row consecutively
    //
    // then the accumulated number used
    // as the combination with the input string
    // to create the md5 hash construction
    // is the answer
    //
}
