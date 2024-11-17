fn main() {
    let result1 = std::fs::read("input").unwrap()
        .iter()
        .map(|&b| if b == b'(' { 1 } else { -1 })
        .sum::<i32>();

    let result2 = std::fs::read("input").unwrap()
        .iter()
        // transform collection
        .map(|&b| if b == b'(' { 1 } else { -1 })
        // accumulate 0 on each item rolling sum  
        .scan(0, |acc, x| { *acc += x; Some(*acc) })
        .position(|x| x == -1).unwrap() + 1;

    println!("{:?}", result1);
    println!("{}", result2)
}
