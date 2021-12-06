use std::io::{BufRead, BufReader, Error, ErrorKind};

fn p1(ns: &[i32]) -> usize {
    ns.windows(2).filter(|x| x[0] < x[1]).count()
}

fn p2(ns: &[i32]) -> usize {
    let wins: Vec<i32> = ns.windows(3).map(|x| x.iter().sum()).collect();
    p1(&wins)
}

fn parse(reader: Box<dyn BufRead>) -> Result<Vec<i32>, Error> {
    let mut ns: Vec<i32> = vec![];

    for ln in reader.lines() {
        ns.push(
            ln?.trim()
                .parse()
                .map_err(|e| Error::new(ErrorKind::InvalidData, e))?,
        );
    }

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

    fn example() -> Vec<i32> {
        parse(Box::new(BufReader::new(EXAMPLE.as_bytes()))).expect("example is malformed")
    }

    #[test]
    fn test_p1() {
        assert_eq!(p1(&example()), 7);
    }

    #[test]
    fn test_p2() {
        assert_eq!(p2(&example()), 5);
    }
}
