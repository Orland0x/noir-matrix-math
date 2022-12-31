use dep::std;

global ROWS = 2;
global COLS = 2;
global VALS = 4; //ROWS*COLS

global ROWS2 = 2;
global COLS2 = 2;
global VALS2 = 4; //ROWS*COLS

global OUT_SIZE = 4;

struct Matrix {
    rows: Field,
    cols: Field,
    values: [Field; VALS]
}

impl Matrix {
    fn new(rows: Field, cols: Field, values: [Field; VALS]) -> Matrix {
        // Add constraint to check rows*cols = values.length

        Matrix {
            rows,
            cols, 
            values
        }
    }

    fn transpose(self) -> Matrix {     
        let mut out = [0; VALS];
        for i in 0..ROWS {
            for j in 0..COLS {
                out[i+ROWS*j] = self.values[j+COLS*i];
            };
        };
        Matrix::new(self.cols, self.rows, out)
    }

    // fn inverse(self) -> Matrix {
    // }


}

fn multiply(m1: Matrix, m2: Matrix) -> Matrix {
    // let vals = ROWS*COLS2;
    let mut out = [0; ROWS*COLS2];
    for i in 0..COLS2 {
        for j in 0..ROWS {
            let mut t = 0;
            for k in 0..COLS {
                t = t + m1.values[i*COLS+k]*m2.values[j+COLS2*k];
            };
            out[j+COLS*i] = t;
        };
    };
    Matrix::new(ROWS, COLS, out)
}

// fn multiply2(rows1: comptime Field, cols1: comptime Field, values1: [Field], rows2: comptime Field, cols2: comptime Field, values2: [Field]) ->  [Field; OUT_SIZE] {
//     constrain rows2 == cols1;
//     let mut out = [0; OUT_SIZE];
//     for i in 0..cols2 {
//         for j in 0..rows1 {
//             let mut t = 0;
//             for k in 0..cols1 {
//                 t = t + values1[i*cols1+k]*values2[j+rows2*k];
//             };
//             out[j+cols1*i] = t;
//         };
//     };
//     out
// }

fn multiply2(rows1: comptime Field, cols1: comptime Field, values1: [Field], rows2: comptime Field, cols2: comptime Field, values2: [Field], mut out: [Field]) ->  [Field] {
    constrain rows2 == cols1;
    let mut exit = false;
    let mut exit1 = false;
    let mut exit2 = false;
    for i in 0..std::array::len(values2) {
        if i as u64 < cols2 as u64 {
            for j in 0..std::array::len(values1) {
                if j as u64 < rows1 as u64 {
                    let mut t = 0;
                    for k in 0..std::array::len(values1) {
                        if k as u64 < cols1 as u64 {
                            t = t + 1; //values1[i*cols1+k]*values2[j+rows2*k];
                        } else {
                        exit2 = true;
                        };
                    };
                    out[j+cols1*i] = t;
                } else {
                exit1 = true;
                };
            };        
        } else {
         exit = true;
        };
    };
    constrain exit;
    constrain exit1;
    constrain exit2;
    out
}

fn multiply3(rows1: comptime Field, 
  cols1: comptime Field, 
  values1: [Field], 
  rows2: comptime Field, 
  cols2: comptime Field, 
  values2: [Field], 
  mut out: [Field]) ->  [Field] {
    constrain rows2 == cols1;
    for i in 0..cols2 {
        for j in 0..rows1 {
            let mut t = 0;
            for k in 0..cols1 {
                t = t + values1[i*cols1+k]*values2[j+rows2*k];
            };
            out[j+cols1*i] = t;
        };
    };
    out
}

// fn do_while<T>(max_iters: comptime u64, body: fn() -> (bool, T)) -> T {
//     let mut (continue, ret) = body();
//     for i in 1 .. max_iters { 
//         if continue {
//             let (c, r) = body();
//             continue = c;
//             ret = r;
//         }
//     }
//     constrain !continue;
//     ret
// }


// fn mimc(max_iters: comptime u64, x: Field, k: Field, constants: [Field], exp : Field) -> Field {
//     //round 0
//     let mut t = x + k;
//     let mut h = std::pow_32(t,exp);
//     //next rounds
//     constrain max_iters as Field == std::array::len(constants) - 1;
//     for i in 1 .. max_iters {
//         if i as u64 < max_iters as u64 {
//             t = h + k + constants[i];
//             h = std::pow_32(t,exp);
//         };
//     };
//     h + k
// }

// fn main(x: Field, y: pub Field) -> pub Field {
//     let constants: [Field;3] = [1,2,3];
//     let o = mimc(2, x, y, constants, 1);
//     o
// }

fn main(x: Field, y: pub Field) -> pub Field {
    // let m1 = Matrix::new(ROWS,COLS,[x,y,3,4]);
    // let m2 = Matrix::new(ROWS,COLS,[5,6,7,8]);
    // let m3 = multiply(m1,m2);
    // m3.values[3]

    let m1 = [x,y,3,4];
    let m2 = [5,6,7,8];
    let m3 = [0,0,0,0,0,0];
    let m4 = multiply2(ROWS,ROWS,m1,ROWS,ROWS,m2,m3);
    let o = m4[3];
    o
}

// raw matrix inversion: 
// https://stackoverflow.com/questions/32114054/matrix-inversion-without-numpy

// global ROWS = 2;
// global COLS = 2;

// fn main(x: Field, y: pub Field) -> pub Field {
//     let m1 = [x,y,3,4];
//     let m2 = [5,6,7,8];
//     let m3 = [0,0,0,0];
//     let m4 = multiply2(ROWS,COLS,m1,ROWS,COLS,m2,m3);
//     let o = m4[3];
//     o
// }

