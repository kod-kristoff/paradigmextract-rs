use std::io::{self, BufRead};

fn main() {
    let stdin = io::stdin();
    let mut handle = stdin.lock();
    let table = build_table(&mut handle);
    println!("Hello, world!");
}

fn build_table(data: &mut dyn BufRead) -> Vec<(Vec<String>, Vec<Vec<(String, String)>>)> {
    for l in data.lines() {}
    todo!()
}
