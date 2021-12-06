use std::io::{BufRead, BufReader, Error, ErrorKind};

fn p(days: i64, fish: &[i64]) -> i64 {
    let mut buf: Vec<i64> = fish.to_vec();
    for _ in 0..days {
        let z = buf[0];
        buf[0] = buf[1];
        buf[1] = buf[2];
        buf[2] = buf[3];
        buf[3] = buf[4];
        buf[4] = buf[5];
        buf[5] = buf[6];
        buf[6] = buf[7] + z;
        buf[7] = buf[8];
        buf[8] = z;
    }
    buf.iter().sum()
}

fn p1(fish: &[i64]) -> i64 {
    p(80, fish)
}


fn p2(fish: &[i64]) -> i64 {
    p(256, fish)
}

fn parse(reader: Box<dyn BufRead>) -> Result<Vec<i64>, Error> {
    let mut ns: Vec<i64> = vec![0; 9];
    for ln in reader.lines() {
        for n in ln?.trim().split(",") {
            let y: u32 = n
                .parse()
                .map_err(|e| Error::new(ErrorKind::InvalidData, e))?;
            ns[y as usize] += 1;
        }
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

    fn example() -> Vec<i64> {
        parse(Box::new(BufReader::new(EXAMPLE.as_bytes()))).expect("example is malformed")
    }

    #[test]
    fn test_p1() {
        assert_eq!(p1(&example()), 5934);
    }

    #[test]
    fn test_p2() {
        assert_eq!(p2(&example()), 26984457539);
    }
}
