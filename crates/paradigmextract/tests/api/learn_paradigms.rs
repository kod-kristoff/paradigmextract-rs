use std::{collections::HashMap, fs};

use nanoserde::DeJson;
use paradigmextract::pextract::learnparadigms;

#[derive(Debug, DeJson)]
struct TestTable {
    msds: Vec<String>,
    wordforms: Vec<String>,
}
#[test]
fn test_all() -> eyre::Result<()> {
    let path = "assets/testdata.json";
    let json_data = fs::read_to_string(path)?;
    let test_tables: Vec<TestTable> = DeJson::deserialize_json(&json_data)?;
    assert_eq!(test_tables.len(), 9943);
    let mut final_tables = Vec::new();
    // join = os.path.join("/", *os.path.realpath(__file__).split("/")[:-2], "testdata.json")
    // with open(join) as fp:
    //     test_tables = json.load(fp)
    //     final_tables = []
    //     assert 9943 == len(test_tables)
    //     for table in test_tables:
    for TestTable { msds, wordforms } in test_tables.into_iter() {
        let tags = msds
            .into_iter()
            .map(|msd| (String::from("msd"), msd))
            .collect();
        final_tables.push((wordforms, tags));
    }
    //         msds_ = table["msds"]
    //         tags = []
    //         for msd in msds_:
    //             tags.append(("msd", msd))
    //         final_tables.append((table["wordforms"], tags))
    let new_paradigms = learnparadigms(final_tables);
    //     # this value is transient, sometimes 551 sometimes 552 (for full testset)
    //     # it differs for the words "bortgallra", "bortkollra", "bortjaga", "bortsopa"
    //     # where they sometimes are all in the same paradigm and sometimes "bortjaga" is its own paradigm
    //     assert len(new_paradigms) == 551 or len(new_paradigms) == 552
    Ok(())
}
