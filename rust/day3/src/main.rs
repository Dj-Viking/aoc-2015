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
    let mut point = Point::new(0, 0);

    let mut visited = HashMap::<Visited, i64>::new();

    // start at 0,0
    visited.entry(Visited { coords: point.to_string() }).or_insert(1);

    std::fs::read_to_string("input")
        .unwrap()
        .chars()
        .for_each(|l| match l {
            '^' => {
                point.go_up(&mut visited);
            },
            'v' => {
                point.go_down(&mut visited);
            },
            '>' => {
                point.go_right(&mut visited);
            },
            '<' => {
                point.go_left(&mut visited);
            },
            _ => (), 
        });
    let mut at_least_once = 0;
    for (_k, v) in &visited {
        //println!("{k:?} -> {v}");
        if *v >= 1 {
            at_least_once += 1;
        }
    } 
    println!("part 1: {}", at_least_once);
}
