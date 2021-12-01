use std::io::{BufRead, BufReader, Error, ErrorKind};

fn p1(ns: &[i32]) -> usize {
    ns.windows(2).filter(|x| x[0] < x[1]).count()
}

fn p2(ns: &[i32]) -> usize {
    let wins: Vec<i32> = ns.windows(3).map(|x| x.iter().sum()).collect();
    p1(&wins)
}

fn parse() -> Result<Vec<i32>, Error> {
    let reader: Box<dyn BufRead> = Box::new(BufReader::new(std::io::stdin()));
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
    let ns = parse()?;
    println!("{}", p1(&ns));
    println!("{}", p2(&ns));
    Ok(())
}
