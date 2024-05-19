use paradigmextract::pextract::WordGraph;


fn get_lcs(table: &[&str]) {
    wg = [WordGraph.from_string(x) for x in table]
    result = functools.reduce(lambda x, y: x & y, wg)
    return result.longestwords
}

#[test]
fn test1() {
let    table = ["stad", "städer", "stads"];
    let lcs = get_lcs(table);
    assert_eq!( lcs.len(), 1);
    assert_eq!( lcs[0],"std");
}


#[test]
fn test_no_vars() {
let    table = ["xy", "z", "a"];
    let lcs = get_lcs(table);
    assert_eq!( lcs.len(), 0);
}


#[test]
fn test2() {
let    table = ["apa", "apans", "xy"];
    let lcs = get_lcs(table);
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
    let lcs = get_lcs(table);
    assert set(lcs) == {"svält", "ihjäl"}
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
    assert_eq!(set(lcs) ,{"gytte", "gyttr"});
}
