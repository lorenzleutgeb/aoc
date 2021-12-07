use std::io::{BufRead, BufReader, Error, ErrorKind};

/// WARNING: Assumes that ns are sorted!
fn median(ns: &[i64]) -> i64 {
    let mid = ns.len() / 2;
    if ns.len() % 2 == 0 {
        ns[mid]
    } else {
        (ns[mid] + ns[mid + 1]) / 2
    }
}

fn gauss(n: i64) -> i64 {
    (n * (n + 1)) / 2
}

fn abs_diff(a: i64, b: i64) -> i64 {
    (a - b).abs()
}

fn p1(ns: &[i64]) -> i64 {
    let m = median(&ns);
    ns.iter().map(|x| abs_diff(*x, m)).sum()
}

fn p2(ns: &[i64]) -> i64 {
    let min = ns[0];
    let max = ns[ns.len() - 1];
    (min..=max)
        .map(|i| ns.iter().map(|x| gauss(abs_diff(*x, i))).sum())
        .min()
        .unwrap()
}

fn parse(reader: Box<dyn BufRead>) -> Result<Vec<i64>, Error> {
    let mut ns: Vec<i64> = vec![];
    for ln in reader.lines() {
        for n in ln?.trim().split(",") {
            let y: i64 = n
                .parse()
                .map_err(|e| Error::new(ErrorKind::InvalidData, e))?;
            ns.push(y);
        }
    }
    ns.sort();
    Ok(ns)
}

fn main() -> Result<(), Error> {
    let reader: Box<dyn BufRead> = Box::new(BufReader::new(std::io::stdin()));
    let ns = parse(reader)?;
    println!("{}", p1(&ns));
    println!("{}", p2(&ns));
    Ok(())
}

#[cfg(test)]
mod tests {
    use super::*;

    const EXAMPLE: &str = include_str!("./example.txt");

    fn example() -> Vec<i64> {
        parse(Box::new(BufReader::new(EXAMPLE.as_bytes()))).expect("example is malformed")
    }

    #[test]
    fn test_p1() {
        assert_eq!(p1(&example()), 37);
    }

    #[test]
    fn test_p2() {
        assert_eq!(p2(&example()), 168);
    }
}
