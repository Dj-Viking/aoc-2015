fn main() {

    let part_one = std::fs::read_to_string("input")
        .unwrap()
        .lines()
        // numxnumxnum
        // 2*l    2*w   2*h
        // 142   x  2  x   3
        .map(|x| {
            let list: Vec<usize> = x.split('x').map(|x| x.parse::<usize>().unwrap()).collect();
            let combos = [list[0]*list[1], list[1]*list[2], list[2]*list[0]];
            combos.iter().map(|x| x*2).sum::<usize>() + combos.iter().min().unwrap()
            
        })
        .sum::<usize>();

    println!("{}", part_one);

    let _ = std::fs::read_to_string("input").unwrap()
        .lines()
        .map(|l| l.split('x')
            .filter_map(|x| x.parse::<usize>().ok()))
        .map(|c| c.clone().zip(c.cycle().skip(1))
            .map(|(a, b)| a * b))
        .map(|c| c.clone().map(|x| x * 2)
            .sum::<usize>() + c.min().unwrap())
        .sum::<usize>();

    let part_two = std::fs::read_to_string("input")
        .unwrap()
        .lines()
        .map(|l|{
            let mut list: Vec<usize> = l.split('x').map(|l| l.parse::<usize>().unwrap()).collect();
            list.sort();
            let ribbon = (list[0]*2 + list[1]*2) + (list[0]*list[1]*list[2]); 
            ribbon
        })
        .sum::<usize>();
        println!("{}", part_two);
}

