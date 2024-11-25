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
    pub fn go_up(&mut self) -> () {
        self.y += 1;
    }
    pub fn go_down(&mut self) -> () {
        self.y -= 1;
    }
    pub fn go_left(&mut self) -> () {
        self.x -= 1;
    }
    pub fn go_right(&mut self) -> () {
        self.x += 1;
    }

    pub fn to_string(&self) -> String {
        format!("{0},{1}", self.x, self.y)
    }

}

#[derive(Hash, Eq, PartialEq, Debug)]
struct Visited {
    coords: String,
}

fn main() {
    let mut point = Point::new(0, 0);

    let mut visited = HashMap::<Visited, i64>::new();
    visited.entry(Visited { coords: point.to_string() }).or_insert(1);

    // println!("visited {:?}", visited);
    // for (point_coords, freq) in &visited {
    //     println!("{point_coords:?} been there -> {freq}");
    // }

    println!("start {:?}", point.to_string());

    std::fs::read_to_string("input")
        .unwrap()
        .chars()
        .for_each(|l| match l {
            '^' => {
                point.go_up();
                if !visited.contains_key(&Visited { coords: point.to_string() }) {
                    visited.entry(
                        Visited { coords: point.to_string() }
                    ).or_insert(1);

                } else { 
                    visited.entry(
                        Visited { coords: point.to_string() }
                    ).and_modify(|c| *c += 1); 
                }
            },
            'v' => {
                point.go_down();
                if !visited.contains_key(&Visited { coords: point.to_string() }) {
                    visited.entry(
                        Visited { coords: point.to_string() }
                    ).or_insert(1);

                } else { 
                    visited.entry(
                        Visited { coords: point.to_string() }
                    ).and_modify(|c| *c += 1); 
                }
            },
            '>' => {
                point.go_right();
                if !visited.contains_key(&Visited { coords: point.to_string() }) {
                    visited.entry(
                        Visited { coords: point.to_string() }
                    ).or_insert(1);

                } else { 
                    visited.entry(
                        Visited { coords: point.to_string() }
                    ).and_modify(|c| *c += 1); 
                }
            },
            '<' => {
                point.go_left();
                if !visited.contains_key(&Visited { coords: point.to_string() }) {
                    visited.entry(
                        Visited { coords: point.to_string() }
                    ).or_insert(1);

                } else { 
                    visited.entry(
                        Visited { coords: point.to_string() }
                    ).and_modify(|c| *c += 1); 
                }
            },
            _ => (), 
        });
    let mut at_least_once = 0;
    for (k, v) in &visited {
        println!("{k:?} -> {v}");
        if *v >= 1 {
            at_least_once += 1;
        }
    } 
    println!("something {}", at_least_once);
}
