#![feature(slice_swap_unchecked)]

use std::{array, cmp::Ordering, time::Instant};

use csv_macro::graph_from_csv;
use rand::{Rng, rngs::ThreadRng, seq::SliceRandom};

graph_from_csv!("data/001/data.csv");

/// A metric for representing the quality of a solution to the TSP problem.
type Fit = f64;

/// A candidate solution for the TSP problem.
type Chromosome = [Node; NODE_COUNT];

/// The maximum size that the population can have.
const MAX_PSIZE: usize = 200;

static mut FULL_POPULATION: [Chromosome; MAX_PSIZE] = [[0; NODE_COUNT]; MAX_PSIZE];

/// Pool of current candidate solutions.
struct Symbionts(&'static mut [Chromosome]);

impl Symbionts {
    fn new(rng: &mut ThreadRng, size: usize) -> Self {
        let p = unsafe { &mut FULL_POPULATION[..size] };
        let mut rit = 0..NODE_COUNT;
        // SAFETY: Range iterator was declared above with NODE_COUNT.
        let mut r: [usize; NODE_COUNT] =
            array::from_fn(|_| unsafe { rit.next().unwrap_unchecked() });
        for i in &mut *p {
            r.shuffle(rng);
            *i = r;
        }

        Self(p)
    }

    fn evolve(&mut self, rng: &mut ThreadRng, tv: &[DynTransgeneticVector], current_it: usize, total_it: usize) -> &[Chromosome] {
        // TODO: Improve subpopulation selection.
        let plasmid_probability = 1.0 - (current_it as f64 / total_it as f64); // Decrease plasmid probability over time.
        // let plasmid_probability = current_it as f64 / total_it as f64; // Increase plasmid probability over time.
        let subpop = &mut self.0[..];
        for p in &mut *subpop {
            let wants_plasmid = rng.random_bool(plasmid_probability);
            let candidates: Vec<&DynTransgeneticVector> = tv.iter().filter(|agent| {
                let is_plasmid = matches!(agent, DynTransgeneticVector::Plasmid(_));
                is_plasmid == wants_plasmid
            }).collect();

            let agent = if candidates.is_empty() {
                &tv[rng.random_range(0..tv.len())]
            } else {
                candidates[rng.random_range(0..candidates.len())]
            };

            if let Some(manipulated) = agent.transcribed(p) {
                *p = manipulated;
            }
        }
        subpop
    }
}

trait TransgeneticVector {
    fn attack(&self, original: &Chromosome, modified: &Chromosome) -> bool;
    fn transcribe(&self, c: &Chromosome) -> Chromosome;
    fn block(&self, c: &Chromosome, it: usize);
    fn identify(&self, c: &Chromosome) -> Option<(usize, usize)>;

    fn transcribed(&self, c: &Chromosome) -> Option<Chromosome> {
        let transcribed = self.transcribe(c);
        if self.attack(c, &transcribed) {
            return Some(transcribed);
        }
        None
    }
}

struct Plasmid {
    seq: Vec<Node>,
}

impl Plasmid {
    fn new(gu: GeneticUnit) -> Self {
        let mut rng = rand::rng();
        let mut seq = vec![];
        let depth = rng.random_range(3..(g.len() / 6).max(4));

        while seq.len() < depth {
            seq.clear();

            let start = rng.random_range(0..gu.len());
            let mut visited = [false; NODE_COUNT];
            let mut stack = [None; NODE_COUNT];
            let mut top = 0;

            stack[top] = Some(start);

            while let Some(n) = stack[top] {
                stack[top] = None;
                top = top.saturating_sub(1);

                if depth == seq.len() {
                    break;
                }
                if visited[n] {
                    continue;
                }

                seq.push(n);
                visited[n] = true;

                for &adj in &gu[n] {
                    if visited[adj] {
                        continue;
                    }
                    stack[top] = Some(adj);
                    top += if top > 0 { 1 } else { 0 };
                    break;
                }
            }
        }

        Self { seq }
    }
}

impl TransgeneticVector for Plasmid {
    fn attack(&self, original: &Chromosome, modified: &Chromosome) -> bool {
        fit(original) - fit(modified) > 0.
    }

    fn transcribe(&self, c: &Chromosome) -> Chromosome {
        assert!(self.seq.len() <= c.len());

        let last = self.seq.last().unwrap();
        let seqlen = self.seq.len() - 1;
        let mut transcribed = [0; NODE_COUNT];
        let mut ins = 0;

        let mut lastpos = None;
        for v in c {
            if v != last && self.seq.contains(v) {
                continue;
            }
            if v == last {
                lastpos = Some(ins);
            }
            transcribed[ins] = *v;
            ins += 1;
        }

        let lastpos = lastpos.unwrap();

        for i in (lastpos..ins).rev() {
            transcribed[i + seqlen] = transcribed[i];
            transcribed[i] = 0;
        }

        for (i, v) in (lastpos..lastpos + seqlen).zip(self.seq[0..seqlen].iter()) {
            transcribed[i] = *v;
        }

        transcribed
    }

    fn block(&self, _: &Chromosome, _: usize) {}

    fn identify(&self, _: &Chromosome) -> Option<(usize, usize)> {
        None
    }
}

struct JumpAndSwapTransposon {
    k: usize
}

impl JumpAndSwapTransposon {
    fn new(k: usize) -> Self {
        Self { k }
    }
}

impl TransgeneticVector for JumpAndSwapTransposon {
    fn attack(&self, original: &Chromosome, modified: &Chromosome) -> bool {
        fit(original) - fit(modified) > 0.
    }

    fn transcribe(&self, c: &Chromosome) -> Chromosome {
        let (start, end) = match self.identify(c) {
            Some(range) => range,
            None => return c.clone(),
        };
        let mut best_chromosome = c.clone();
        let mut best_fitness = f64::MAX;
        for i in start..end {
            let mut candidate = c.clone();
            
            candidate.swap(i, i + 1);

            let current_fitness = fit(&candidate);

            if current_fitness < best_fitness {
                best_fitness = current_fitness;
                best_chromosome = candidate;
            }
        }

        best_chromosome
    }

    fn block(&self, _: &Chromosome, _: usize) {}

    fn identify(&self, c: &Chromosome) -> Option<(usize, usize)> {
        let c_len = c.len();
        if c_len <= self.k {
            return None;
        } 
        let mut rng = rand::rng();
        let mut start = rng.random_range(0..c_len);
        let mut end = rng.random_range(0..c_len);
        
        while start.abs_diff(end) < self.k {
            start = rng.random_range(0..c_len);
            end = rng.random_range(0..c_len);
        }

        if start > end {
            std::mem::swap(&mut start, &mut end);
        }

        Some((start, end))

    }
}

struct MutagenTransposon {
    k: usize
}

impl MutagenTransposon {
    fn new(k: usize) -> Self {
        Self { k }
    }
}

impl TransgeneticVector for MutagenTransposon {
    fn attack(&self, _: &Chromosome, _: &Chromosome) -> bool {
        true
    }

    fn transcribe(&self, c: &Chromosome) -> Chromosome {
        let (start, end) = match self.identify(c) {
            Some(range) => range,
            None => return c.clone(),
        };
        let mut candidate = c.clone();
        let mut rng = rand::rng();

        for _ in 0..self.k {
            let idx1 = rng.random_range(start..=end);
            let idx2 = rng.random_range(0..c.len());
        
            candidate.swap(idx1, idx2);
        }

        candidate
    }

    fn block(&self, _: &Chromosome, _: usize) {}

    fn identify(&self, c: &Chromosome) -> Option<(usize, usize)> {
        let c_len = c.len();
        if c_len <= self.k {
            return None;
        } 
        let mut rng = rand::rng();
        let mut start = rng.random_range(0..c_len);
        let mut end = rng.random_range(0..c_len);
        
        while start.abs_diff(end) < self.k {
            start = rng.random_range(0..c_len);
            end = rng.random_range(0..c_len);
        }

        if start > end {
            std::mem::swap(&mut start, &mut end);
        }

        Some((start, end))

    }
}

enum DynTransgeneticVector {
    Plasmid(Plasmid),
    JumpAndSwapTransposon(JumpAndSwapTransposon),
    MutagenTransposon(MutagenTransposon),
}

impl TransgeneticVector for DynTransgeneticVector {
    fn attack(&self, original: &Chromosome, modified: &Chromosome) -> bool {
        match self {
            Self::Plasmid(p) => p.attack(original, modified),
            Self::JumpAndSwapTransposon(t) => t.attack(original, modified),
            Self::MutagenTransposon(t) => t.attack(original, modified),
        }
    }

    fn transcribe(&self, c: &Chromosome) -> Chromosome {
        match self {
            Self::Plasmid(p) => p.transcribe(c),
            Self::JumpAndSwapTransposon(t) => t.transcribe(c),
            Self::MutagenTransposon(t) => t.transcribe(c),
        }
    }

    fn block(&self, c: &Chromosome, it: usize) {
        match self {
            Self::Plasmid(p) => p.block(c, it),
            Self::JumpAndSwapTransposon(t) => t.block(c, it),
            Self::MutagenTransposon(t) => t.block(c, it),
        }
    }

    fn identify(&self, c: &Chromosome) -> Option<(usize, usize)> {
        match self {
            Self::Plasmid(p) => p.identify(c),
            Self::JumpAndSwapTransposon(t) => t.identify(c),
            Self::MutagenTransposon(t) => t.identify(c),
        }
    }
}

type GeneticUnit = Vec<Vec<Node>>;

#[derive(Clone)]
struct GeneticInfo(Vec<GeneticUnit>);

impl GeneticInfo {
    fn new() -> Self {
        let mintree = minimum_spanning_tree();
        Self(vec![mintree])
    }
}

struct Agents(Vec<DynTransgeneticVector>);

impl Agents {
    fn new(rng: &mut ThreadRng, gi: GeneticInfo, max: usize) -> Self {
        Self(
            (0..max)
                .map(|_| Self::new_agent(gi.0[rng.random_range(0..gi.0.len())].clone()))
                .collect(),
        )
    }

    fn new_agent(gu: GeneticUnit) -> DynTransgeneticVector {
        // TODO: Make the agent to be randomly selected.
        // DynTransgeneticVector::Plasmid(Plasmid::new(gu))
        let mut rng = rand::rng();
        if rng.random_bool(0.5) {
            DynTransgeneticVector::Plasmid(Plasmid::new(gu))
        } else {
            let k = rng.random_range(3..(NODE_COUNT / 4).max(4));
            if rng.random_bool(0.5) {
                DynTransgeneticVector::JumpAndSwapTransposon(JumpAndSwapTransposon::new(k))
            } else {
                DynTransgeneticVector::MutagenTransposon(MutagenTransposon::new(k))
            }
        }
    }
}

struct Cell {
    gi: GeneticInfo,
    agents: Agents,
    symbionts: Symbionts,
}

impl Cell {
    fn new(rng: &mut ThreadRng, psize: usize, asize: usize) -> Self {
        let symbionts = Symbionts::new(rng, psize);
        let gi = GeneticInfo::new();
        let agents = Agents::new(rng, gi.clone(), asize);

        Self {
            gi,
            agents,
            symbionts,
        }
    }

    fn evolve(&mut self, rng: &mut ThreadRng, current_it: usize, total_it: usize) {
        let subpop = self.symbionts.evolve(rng, &self.agents.0, current_it, total_it);

        let mut aposteriori = subpop
            .iter()
            .copied()
            .take(rng.random_range(10..subpop.len()))
            .collect::<Vec<_>>();

        aposteriori.sort_by(|c1, c2| fit(c1.as_slice()).total_cmp(&fit(c2.as_slice())));

        self.gi.0.extend(aposteriori.into_iter().map(|c| {
            let c = c.to_vec();
            let mut edges = vec![vec![]; NODE_COUNT];
            for e in c.windows(2) {
                assert!(e.len() == 2);
                edges[e[0]].push(e[1]);
            }
            edges
        }));
    }
}

fn minimum_spanning_tree() -> Vec<Vec<Node>> {
    let mut flattened = vec![];
    for (i, r) in g.iter().enumerate() {
        for (j, w) in r.iter().enumerate().take(i) {
            flattened.push(((i, j), w));
        }
    }

    flattened.sort_by(|(_, w1), (_, w2)| w1.total_cmp(w2));

    let mut tree = vec![vec![]; g.len()];
    let mut parent: Vec<usize> = (0..g.len()).collect();
    let mut rank = [0; g.len()];

    for (u, v) in flattened.iter().copied().map(|(e, _)| e) {
        let ru = uf_find(&mut parent, u);
        let rv = uf_find(&mut parent, v);
        if ru != rv {
            tree[u].push(v);
            tree[v].push(u);
            uf_union(&mut parent, &mut rank, ru, rv);
        }
    }

    tree
}

/// Returns the representative of the set containing `x` (with path compression).
fn uf_find(parent: &mut [usize], x: usize) -> usize {
    if parent[x] != x {
        parent[x] = uf_find(parent, parent[x]);
    }
    parent[x]
}

/// Merges the sets whose representatives are `rx` and `ry` (union by rank).
fn uf_union(parent: &mut [usize], rank: &mut [usize], rx: usize, ry: usize) {
    match rank[rx].cmp(&rank[ry]) {
        Ordering::Less => parent[rx] = ry,
        Ordering::Greater => parent[ry] = rx,
        Ordering::Equal => {
            parent[ry] = rx;
            rank[rx] += 1;
        }
    }
}

/// Maps a fitness for some individual.
///
/// In this case, the sum of edge costs between adjacent nodes in the individual, including a cycle
/// back to the beginning.
fn fit(i: &[Node]) -> Fit {
    i.windows(2).map(|w| g[w[0]][w[1]]).sum::<Fit>() + g[i[i.len() - 1]][i[0]]
}

fn main() {
    let now = Instant::now();
    let mut rng = rand::rng();

    // Load hyper-params.
    let args = std::env::args().collect::<Vec<_>>();
    let itnum: usize = args.get(1).and_then(|s| s.parse().ok()).unwrap_or(500);
    let psize: usize = args.get(2).and_then(|s| s.parse().ok()).unwrap_or(50);
    let asize: usize = args.get(3).and_then(|s| s.parse().ok()).unwrap_or(42);

    assert!(psize <= MAX_PSIZE);

    let mut cell = Cell::new(&mut rng, psize, asize);

    for current_it in 0..itnum {
        cell.evolve(&mut rng, current_it, itnum);
    }

    // TODO: Extract this into func.
    // Print best fitness and time taken.
    println!(
        "{} {}",
        cell.symbionts
            .0
            .iter()
            .map(|x| fit(x.as_slice()))
            .min_by(|x, y| x.total_cmp(y))
            .unwrap_or(f64::INFINITY),
        now.elapsed().as_secs_f64()
    )
}
