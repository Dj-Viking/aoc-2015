use std::collections::HashMap;

#[derive(Debug)]
pub struct Point {
    x: i64,
    y: i64,
}
impl Point {

    pub fn new(cx: i64, cy: i64) -> Self {
        Self {
            x: cx,
            y: cy,
        }
    }
    pub fn go_up(&mut self, visited: &mut HashMap::<Visited, i64>) -> () {
        self.y += 1;
        if !visited.contains_key(&Visited { coords: self.to_string() }) {
            visited.entry(
                Visited { coords: self.to_string() }
            ).or_insert(1);

        } else { 
            visited.entry(
                Visited { coords: self.to_string() }
            ).and_modify(|c| *c += 1); 
        }
    }
    pub fn go_down(&mut self, visited: &mut HashMap::<Visited, i64>) -> () {
        self.y -= 1;
        if !visited.contains_key(&Visited { coords: self.to_string() }) {
            visited.entry(
                Visited { coords: self.to_string() }
            ).or_insert(1);

        } else { 
            visited.entry(
                Visited { coords: self.to_string() }
            ).and_modify(|c| *c += 1); 
        }
    }
    pub fn go_left(&mut self, visited: &mut HashMap::<Visited, i64>) -> () {
        self.x -= 1;
        if !visited.contains_key(&Visited { coords: self.to_string() }) {
            visited.entry(
                Visited { coords: self.to_string() }
            ).or_insert(1);

        } else { 
            visited.entry(
                Visited { coords: self.to_string() }
            ).and_modify(|c| *c += 1); 
        }
    }
    pub fn go_right(&mut self, visited: &mut HashMap::<Visited, i64>) -> () {
        self.x += 1;
        if !visited.contains_key(&Visited { coords: self.to_string() }) {
            visited.entry(
                Visited { coords: self.to_string() }
            ).or_insert(1);

        } else { 
            visited.entry(
                Visited { coords: self.to_string() }
            ).and_modify(|c| *c += 1); 
        }
    }

    pub fn to_string(&self) -> String {
        format!("{0},{1}", self.x, self.y)
    }

}

#[derive(Hash, Eq, PartialEq, Debug)]
pub struct Visited {
    coords: String,
}

fn main() {
    let mut santa = Point::new(0, 0);

    let mut visited_santa_one = HashMap::<Visited, i64>::new();

    // start at 0,0
    visited_santa_one.entry(Visited { coords: santa.to_string() }).or_insert(1);

    std::fs::read_to_string("input")
        .unwrap()
        .chars()
        .for_each(|l| match l {
            '^' => { santa.go_up(&mut visited_santa_one); },
            'v' => { santa.go_down(&mut visited_santa_one); },
            '>' => { santa.go_right(&mut visited_santa_one); },
            '<' => { santa.go_left(&mut visited_santa_one); },
            _ => (), 
        });
    let mut at_least_once = 0;
    for (_k, v) in &visited_santa_one {
        //println!("{k:?} -> {v}");
        if *v >= 1 {
            at_least_once += 1;
        }
    } 
    println!("part 1: {}", at_least_once);

//////////////////////////////////////////////////////

    let mut santa = Point::new(0, 0);
    let mut robo = Point::new(0, 0);
    
    let mut visited = HashMap::<Visited, i64>::new();

    visited.entry(Visited { coords: santa.to_string() })
        .or_insert(1);
    visited.entry(Visited { coords: robo.to_string() })
        .and_modify(|e| *e += 1);

    let mut counter = 0;

    std::fs::read_to_string("input")
        .unwrap()
        .chars()
        .for_each(|c| {
            if counter % 2 == 0 {
                match c {
                    '^' => santa.go_up(&mut visited),
                    '>' => santa.go_right(&mut visited),
                    '<' => santa.go_left(&mut visited),
                    'v' => santa.go_down(&mut visited),
                    _ => (),
                }
            } else {
                match c {
                    '^' => robo.go_up(&mut visited),
                    '>' => robo.go_right(&mut visited),
                    '<' => robo.go_left(&mut visited),
                    'v' => robo.go_down(&mut visited),
                    _ => (),
                }
            }            
            counter += 1;
        });


    let mut at_least_once = 0;
    
    for (_k, v) in &visited {
        if *v >= 1 {
            at_least_once += 1;
        }
    } 

    println!("part 2: {}", at_least_once);

}
