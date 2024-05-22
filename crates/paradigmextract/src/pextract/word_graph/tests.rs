use std::{collections::HashSet, hash::RandomState};

use super::WordGraph;

fn get_lcs(table: &[&str]) -> Vec<String> {
    let mut result = table
        .iter()
        .map(|s| WordGraph::from_string(s))
        .reduce(|x, y| x & y)
        .unwrap();
    result.longestwords().clone()
}

#[test]
fn test1() {
    let table = ["stad", "städer", "stads"];
    let lcs = get_lcs(&table);
    println!("{:?}", lcs);
    assert_eq!(lcs.len(), 1);
    assert_eq!(lcs[0], "std");
}

#[test]
fn test_no_vars() {
let    table = ["xy", "z", "a"];
    let lcs = get_lcs(&table);
    assert_eq!( lcs.len(), 0);
}

#[test]
fn test2() {
let    table = ["apa", "apans", "xy"];
    let lcs = get_lcs(&table);
    assert_eq!( lcs.len(), 0);
}

#[test]
fn test3() {
   let table = [
        "svälter ihjäl",
        "svältes ihjäl",
        "svälts ihjäl",
        "svälte ihjäl",
        "svältes ihjäl",
        "svält ihjäl",
        "svälta ihjäl",
        "svältas ihjäl",
        "svält ihjäl",
        "svälts ihjäl",
        "svältande ihjäl",
        "svältandes ihjäl",
        "svält ihjäl",
        "ihjälsvält",
        "svälts ihjäl",
        "ihjälsvälts",
   ];
    let lcs = get_lcs(&table);
    assert_eq!(HashSet::<&str, RandomState>::from_iter(lcs.iter().map(String::as_str)), HashSet::from_iter(["svält", "ihjäl"]));
}

#[test]
        fn test4() {
   let table = [
        "gytter",
        "gytters",
        "gyttret",
        "gyttrets",
        "gytter-",
        "gytter",
        "gytter-",
        "gytter",
        "gytter-",
   ];
    let lcs = get_lcs(&table);
    assert_eq!(HashSet::<&str, RandomState>::from_iter(lcs.iter().map(String::as_str)), HashSet::from_iter(["gytte", "gyttr"]));
}
