use std::cmp::Ordering;
use std::io::{BufRead, BufReader, Error, ErrorKind};

#[derive(Clone, PartialOrd, Copy, PartialEq, Eq, Debug)]
struct Point {
    x: i32,
    y: i32,
}

impl Ord for Point {
    fn cmp(&self, other: &Self) -> Ordering {
        self.x.cmp(&other.x).then(self.y.cmp(&other.y))
    }
}

#[derive(Clone, Copy, PartialEq, Eq, Debug)]
struct Line {
    a: Point,
    b: Point,
}

fn p(lines: &[Line]) -> usize {
    let mut points: Vec<Point> = lines.iter().map(|l| points(*l)).flatten().collect();
    points.sort();

    let mut count: usize = 0;
    let mut curr: Point = points[0];
    let mut switched: bool = true;
    for i in 1..points.len() {
        if switched && curr == points[i] {
            count += 1;
        }
        switched = curr != points[i];
        curr = points[i];
    }
    count
}

fn ortho(lines: &[Line]) -> Vec<Line> {
    lines
        .iter()
        .filter(|l| l.a.x == l.b.x || l.a.y == l.b.y)
        .map(|x| *x)
        .collect()
}

fn points(l: Line) -> Vec<Point> {
    let mut next: Vec<Point> = vec![l.a];
    let mut c = l.a;
    while c != l.b {
        if c.x < l.b.x {
            if c.y < l.b.y {
                c = Point {
                    x: c.x + 1,
                    y: c.y + 1,
                }
            } else if c.y > l.b.y {
                c = Point {
                    x: c.x + 1,
                    y: c.y - 1,
                }
            } else {
                c = Point { x: c.x + 1, y: c.y }
            }
        } else if c.x > l.b.x {
            if c.y < l.b.y {
                c = Point {
                    x: c.x - 1,
                    y: c.y + 1,
                }
            } else if c.y > l.b.y {
                c = Point {
                    x: c.x - 1,
                    y: c.y - 1,
                }
            } else {
                c = Point { x: c.x - 1, y: c.y }
            }
        } else {
            if c.y < l.b.y {
                c = Point { x: c.x, y: c.y + 1 }
            } else if c.y > l.b.y {
                c = Point { x: c.x, y: c.y - 1 }
            }
        }

        next.push(c);
    }
    next
}

fn parse() -> Result<Vec<Line>, Error> {
    let reader: Box<dyn BufRead> = Box::new(BufReader::new(std::io::stdin()));
    let mut lines: Vec<Line> = vec![];

    for ln in reader.lines() {
        let tmp: Result<Vec<i32>, Error> = ln?
            .split(" -> ")
            .map(|p| p.split(","))
            .flatten()
            .map(|x| x.parse().map_err(|e| Error::new(ErrorKind::InvalidData, e)))
            .collect();

        let xs = tmp.unwrap();

        if xs.len() != 4 {
            Error::new(ErrorKind::InvalidData, "could not parse");
        }

        lines.push(Line {
            a: Point { x: xs[0], y: xs[1] },
            b: Point { x: xs[2], y: xs[3] },
        });
    }

    Ok(lines)
}

fn main() -> Result<(), Error> {
    let lines = parse()?;
    println!("{:?}", p(&ortho(&lines)));
    println!("{:?}", p(&lines));
    Ok(())
}
