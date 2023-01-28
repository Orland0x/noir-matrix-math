use dep::std;

global ROWS = 2;
global COLS = 2;
global VALS = 4; //ROWS*COLS

global ROWS2 = 2;
global COLS2 = 2;
global VALS2 = 4; //ROWS*COLS

global OUT_SIZE = 4;

global MAX_ITER = 10;

// matrix inversion reference: 
// https://stackoverflow.com/questions/32114054/matrix-inversion-without-numpy
// determinant is working in some cases but fails with the below error sometimes. 
// TODO: figure out 'internal error: entered unreachable code: Can only multiply linear terms' issue. 
// refer to this https://github.com/noir-lang/noir/issues/580
// Error is fixed but cant update the noir version atm. (build not working so using prebuilt binary)


// PRIME = 0x30644e72e131a029b85045b68181585d2833e84879b9709143e1f593f0000000 : -1

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
}

global N = 2;
global M = 2;
global L = 2;
fn multiplyNML(values1: [u64;N*M], values2: [u64;M*L]) -> [u64;N*L] {
    let mut out = [0;N*L];
    for i in 0 .. L {
        for j in 0 .. N {
            let mut t = 0;
            for k in 0 .. M  {
                t = t + values1[i*M+k]*values2[j+M*k];
            };
            out[j+M*i] = t;
        };
    };
    out
}

global K = 4;
fn matrixMinorK(values: [u64;K*K], i: Field, j: Field) -> [u64;(K-1)*(K-1)+1] {
    // BUG: have to add +1 to the array size to make it work.
    // this val doesnt get written but still get an array out of bounds error if not added.
    let mut out = [0;(K-1)*(K-1)+1];
    let mut o = 0;
    for r in 0 .. K {
        for c in 0 .. K {
            if r !=i {
                if c != j {
                    out[o] = values[c+K*r];
                    o = o + 1;
                };  
            };
        };
    };
    out
}

fn determinant_3x3(values: [Field]) -> Field {
    // use sqrt
    let n: comptime Field = std::array::len(values)/3;

    // Building the upper triangular matrix
    let mut m = values;
    for fd in 0 .. n {
        for i in fd+1 .. n {
            // ignoring div 0 issue for now
            let crScalar = m[i*n+fd] / m[fd*n+fd];
            for j in 0 .. n {
                m[i*n+j] = m[i*n+j] - crScalar*m[fd*n+j];
            }
        }
    }
    // The determinant is the product of the diagonal of the upper triangular matrix
    let mut det = 1;
    for i in 0 .. n {
        det = det*m[i*n+i];
    }
    det
}

fn sqrt(x: u64) -> u64 {
    let mut z = (x+1) / 2;
    let mut y = x;
    let mut finished = false;
    for _i in 0..MAX_ITER {
        if z < y {
            y = z;
            z = ((x/z) + z) / 2;
        } else {
            finished = true;
        }
    }
    constrain finished;
    y
}



// Test main functions: 

// fn main() -> pub Field {
//     let m = [6,2,1,0,2,1,1,5,2];
//     let a = determinant_3x3(m);
//     a
// }

// fn main() -> pub u64 {
//     let s = sqrt(81);
//     s
// }

// fn main() -> pub u64 {
//     let m1 = [1,2,3,4];
//     let m2 = [5,6,7,8];
//     let m3 = multiplyNML(m1,m2);
//     m3[0] + m3[1] + m3[2] + m3[3]
// }

fn main() -> pub u64 {
    // let m = [6,2,1,0,2,1,1,5,2];
    let m = [6,2,1,0,2,1,1,5,2,6,2,1,0,2,1,1];
    let a = matrixMinorK(m,3,3);
    a[9]
}


