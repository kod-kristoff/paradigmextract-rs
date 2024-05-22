use std::{
    collections::{HashMap, HashSet},
    hash::Hash,
    ops::BitAnd,
    usize,
};

#[cfg(test)]
mod tests;

/// Wordgraph class to extract LCS
/// Convert word w to directed graph that contains all subsequences of w.
///
/// Simple directed graph class where graphs are special types of automata
///    where each state is a final state.
///    This is used to quickly find the LCS of a large number of words by
///    first converting each word w to an automaton that accepts all substrings
///    of w.  Then the automata can be intersected with __and__, and the
///    longest path(s) extracted from the result with _maxpath().
pub struct WordGraph {
    alphabet: HashSet<char>,
    states: HashSet<usize>,
    transitions: HashMap<(usize, char), usize>,
    revtrans: HashMap<usize, HashSet<(usize, char)>>,
    longestwords: Option<Vec<String>>,
}

impl WordGraph {
    pub fn from_string(word: &str) -> Self {
        let mut trans = HashMap::new();
        for i in 0..word.len() {
            dbg!(&i);
            for (j, word_j) in word.chars().enumerate().skip(i) {
                dbg!(&j, String::from_iter(vec![word_j]));
                trans.entry((i, word_j)).or_insert_with(|| j + 1);
            }
        }
        dbg!(&trans);
        Self::new(trans)
    }

    fn new(transitions: HashMap<(usize, char), usize>) -> Self {
        let alphabet = transitions.keys().map(|(_state, symbol)| *symbol).collect();
        //  {symbol for (state, symbol) in transitions}
        // self.states = {state for (state, symbol) in transitions} | set(
        //     transitions.values()
        // )
        let states = transitions
            .keys()
            .map(|(state, _symbol)| *state)
            .chain(transitions.values().copied())
            .collect();
        let mut revtrans = HashMap::new();
        for ((state, sym), value) in transitions.iter() {
            let curr_set: HashSet<(usize, char)> = HashSet::from([(*state, *sym); 1]);
            revtrans
                .entry(*value)
                .and_modify(|e: &mut HashSet<(usize, char)>| {
                    *e = (*e).union(&curr_set).copied().collect()
                })
                .or_insert(curr_set);
        }
        // for state, sym in self.transitions:
        //     if self.transitions[(state, sym)] in self.revtrans:
        //         self.revtrans[self.transitions[(state, sym)]] |= {(state, sym)}
        //     else:
        //         self.revtrans[self.transitions[(state, sym)]] = {(state, sym)}
        Self {
            alphabet,
            states,
            transitions,
            revtrans,
            longestwords: None
        }
    }

    pub fn longestwords(&mut self) -> &Vec<String> {
        if self.longestwords.is_none() {
            self._maxpath();
        }
        self.longestwords.as_ref().unwrap()
    }
    // fn __getattr__(self, attr)
    //     {if attr == "longestwords":
    //         self._maxpath()
    //         return self.longestwords
    //     raise AttributeError("%r object has no attribute %r" % (self.__class__, attr))}

    // fn __and__(self, other)
    //     {return self._intersect(other)}

    /// Calculate intersection of two directed graphs.
    fn _intersect(&self, other: &Self) -> Self {
        dbg!("_intersect enter");
        let alphabet = &self.alphabet & &other.alphabet;
        let mut stack = vec![(0, 0)];
        let mut statemap: HashMap<(usize, usize), usize> = HashMap::from_iter([((0, 0), 0); 1]);
        let mut nextstate = 1;
        let mut trans = HashMap::new();
        while let Some((asource, bsource)) = stack.pop() {
            for sym in &alphabet {
                if self.transitions.contains_key(&(asource, *sym))
                    && other.transitions.contains_key(&(bsource, *sym))
                {
                    let atarget = self.transitions[&(asource, *sym)];
                    let btarget = other.transitions[&(bsource, *sym)];
                    if let std::collections::hash_map::Entry::Vacant(e) =
                        statemap.entry((atarget, btarget))
                    {
                        e.insert(nextstate);
                        nextstate += 1;
                        stack.push((atarget, btarget));
                    }
                    trans.insert(
                        (statemap[&(asource, bsource)], *sym),
                        statemap[&(atarget, btarget)],
                    );
                }
            }
        }

        Self::new(trans)
    }

    fn _backtrace(
        &self,
        longestwords: &mut Vec<String>,
        maxlen: &HashMap<usize, usize>,
        state: usize,
        mut tempstring: Vec<char>,
    ) {
        dbg!(&longestwords,&state,&tempstring);
        // if state not in self.revtrans:
        //         tempstring.reverse()
        //         self.longestwords.append("".join(tempstring))
        //         return
        if !self.revtrans.contains_key(&state) {
            tempstring.reverse();
            longestwords.push(String::from_iter(tempstring));
            return;
        }
        //     for backstate, symbol in self.revtrans[state]:
        //         if maxlen[backstate] == maxlen[state] - 1:
        //             self._backtrace(maxsources, maxlen, backstate, [*tempstring, symbol])
        for (backstate, symbol) in &self.revtrans[&state] {
            if maxlen[backstate] == maxlen[&state] - 1 {
                let mut new_tempstring = tempstring.clone();
                new_tempstring.push(*symbol);
                self._backtrace(longestwords, maxlen, *backstate, new_tempstring)
            }
        }
    }

    /// Returns a list of strings that represent the set of longest words accepted by the automaton.
    fn _maxpath(&mut self) {
        dbg!("_maxpath enter");
        //     tr = {}
        let mut tr: HashMap<usize, HashSet<usize>> = HashMap::new();
        // Create tr which simply has graph structure without symbols
        for (state, sym) in self.transitions.keys() {
            tr.entry(*state)
                .and_modify(|e| {
                    (*e).insert(self.transitions[&(*state, *sym)]);
                })
                .or_default();
        }
        //     for state, sym in self.transitions:
        //         if state not in tr:
        //             tr[state] = set()
        //         tr[state].update({self.transitions[(state, sym)]})

        //     S = {0}
        let mut S = HashSet::from([0; 1]);
        //     maxlen = {}
        let mut maxlen = HashMap::new();
        //     maxsources = {}
        let mut maxsources = HashMap::new();
        //     for i in self.states:
        //         maxlen[i] = 0
        //         maxsources[i] = {}
        for i in &self.states {
            maxlen.insert(*i, 0);
            maxsources.insert(*i, HashSet::new());
        }

        //     step = 1
        let mut step: usize = 1;
        //     while S:
        loop {
            dbg!(&S, &step);
            if S.is_empty() {
                break;
            }
            //         Snew = set()
            let mut Snew = HashSet::new();
            //         for state in S:
            for state in S {
                dbg!(&state);
                //             if state in tr:
                if tr.contains_key(&state) {
                    //                 for target in tr[state]:
                    for target in &tr[&state] {
                        dbg!(target);
                        dbg!(maxlen[target]);
                        //                     if maxlen[target] < step:
                        if maxlen[target] < step {
                            //                         maxsources[target] = {state}
                            maxsources.insert(*target, HashSet::from([state; 1]));
                            //                         maxlen[target] = step
                            maxlen.insert(*target, step);
                            //                         Snew.update({target})}
                            Snew.insert(*target);
                        } else if maxlen[target] == step {
                            //                     elif maxlen[target] == step:
                            //                         maxsources[target] |= {state}}}}
                            maxsources
                                .entry(*target)
                                .and_modify(|e| {(*e).insert(state);});
                        }
                    }
                }
            }
            //         S = Snew
            S = Snew;
            //         step += 1
            step += 1;
        }
        let max_maxlen_values = maxlen.values().max().unwrap();
        //     endstates = [key for key, val in maxlen.items() if val == max(maxlen.values())]
        let endstates = maxlen
            .iter()
            .filter(|(_key, val)| *val == max_maxlen_values)
            .map(|(key, _val)| key);
            
        //     self.longestwords = []
        let mut longestwords = vec![];
        for w in endstates {
            //         self._backtrace(maxsources, maxlen, w, [])
            self._backtrace(&mut longestwords, &maxlen, *w, vec![]);
        }
        self.longestwords = Some(longestwords);
    }
}

impl BitAnd for WordGraph {
    type Output = WordGraph;

    fn bitand(self, rhs: Self) -> Self::Output {
        self._intersect(&rhs)
    }
}
