#[derive(Debug)]
pub struct LED {
    x: usize,
    y: usize,
    lit: bool,
}
impl LED {
    pub fn new(x: usize, y: usize, lit: bool) -> Self {
        Self {
            x: x,
            y: y,
            lit: lit
        }
    }
    pub fn to_string(&self) -> String {
        format!("{},{}",
            self.x, self.y
        )
    }
}
pub fn split_with_trim(strr: &String, delim: &str) -> Vec<String> {
    strr.clone()
        .split(delim)
        //trim empty string items
        .filter_map(|x| if !x.to_string().is_empty() { Some(x.to_string()) } else { None })
        .collect::<Vec<String>>()
}

pub fn part1() -> () {
    let mut grid: Vec<Vec<LED>> = vec!();
    for y in 0..1000 {
        grid.push(Vec::<LED>::new());
        for x in 0..1000 {
            grid[y].push(LED::new(x,y,false));
        }
    }
    // for y in 0..3 {
    //     grid.push(Vec::<LED>::new());
    //     for x in 0..3 {
    //         grid[y].push(LED::new(x,y,false));
    //     }
    // }

    let mut lines: Vec<String> = vec!();
    // lines.push("turn on 0,0 through 2,2".to_string());
    let lines: Vec<String> = std::fs::read_to_string("input").expect("the file to open plz lol")
        .lines()
        .map(|x| x.to_string()).collect();

    /* 
        let needle = Regex::new(r"^((?!on|off|toggle).)*$").unwrap();
    * regex parse error:
    ^((?!on|off|toggle).)*$
      ^^^
error: look-around, including look-ahead and look-behind, is not supported
    :(
*/

    // init grid

    for i in 0..lines.len() {
        //println!("line => {}", lines[i]);

        //println!("rest => {:?}", rest);

        if lines[i].contains("on") {

            let rest = &split_with_trim(&lines[i], "turn ")[0];
            // println!("{}", rest);
            // todo make the fn chain with itself? using implicit self param
            let coords_pre = &split_with_trim(&rest, "on ")[0];

            let coords = &split_with_trim(&coords_pre, " through ");

            let start_xy = coords[0].clone();
            let start_x = &split_with_trim(&start_xy, ",")[0].parse::<usize>().unwrap();
            let start_y = &split_with_trim(&start_xy, ",")[1].parse::<usize>().unwrap();

            let end_xy = coords[1].clone();
            let end_x = &split_with_trim(&end_xy, ",")[0].parse::<usize>().unwrap();
            let end_y = &split_with_trim(&end_xy, ",")[1].parse::<usize>().unwrap();

            for y in (*start_y as i32)..(*end_y as i32 + 1) {
                for x in (*start_x as i32)..(*end_x as i32 + 1) {
                    grid[y as usize][x as usize].lit = true;
                    // println!("gridyx {:?}", grid[y as usize][x as usize]);
                }
            }
        }
        if lines[i].contains("off") {
            //println!("off    | {}", lines[i]);
            // todo make the fn chain with itself? using implicit self param
            let rest = &split_with_trim(&lines[i], "turn ")[0];
            let coords_pre = &split_with_trim(&rest, "off ")[0];

            let coords = &split_with_trim(&coords_pre, " through ");

            let start_xy = coords[0].clone();
            let start_x = &split_with_trim(&start_xy, ",")[0].parse::<usize>().unwrap();
            let start_y = &split_with_trim(&start_xy, ",")[1].parse::<usize>().unwrap();

            let end_xy = coords[1].clone();
            let end_x = &split_with_trim(&end_xy, ",")[0].parse::<usize>().unwrap();
            let end_y = &split_with_trim(&end_xy, ",")[1].parse::<usize>().unwrap();

            for y in (*start_y as i32)..(*end_y as i32 + 1) {
                for x in (*start_x as i32)..(*end_x as i32 + 1) {
                    grid[y as usize][x as usize].lit = false;
                    // println!("gridyx {:?}", grid[y as usize][x as usize]);
                    // panic!();
                }
            }
        }
        if lines[i].contains("toggle") {
            let rest = &split_with_trim(&lines[i], "toggle ")[0];
            let coords = &split_with_trim(&rest, " through ");

            let start_xy = coords[0].clone();
            let start_x = &split_with_trim(&start_xy, ",")[0].parse::<usize>().unwrap();
            let start_y = &split_with_trim(&start_xy, ",")[1].parse::<usize>().unwrap();

            let end_xy = coords[1].clone();
            let end_x = &split_with_trim(&end_xy, ",")[0].parse::<usize>().unwrap();
            let end_y = &split_with_trim(&end_xy, ",")[1].parse::<usize>().unwrap();

            for y in (*start_y as i32)..(*end_y as i32 + 1) {
                for x in (*start_x as i32)..(*end_x as i32 + 1) {
                    grid[y as usize][x as usize].lit = !grid[y as usize][x as usize].lit;
                    // println!("gridyx {:?}", grid[y as usize][x as usize]);
                    // panic!();
                }
            }
        }
    }

    let mut on_count = 0;
    for y in 0..grid.len() {
        for x in 0..grid[y].len() {
            if grid[y][x].lit {
                on_count += 1;
            }
        }
    }
    println!("part1: {}", on_count);

}

fn main() {
    part1();
}
