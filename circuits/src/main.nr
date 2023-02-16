use dep::std;

// PRIME = 0x30644e72e131a029b85045b68181585d2833e84879b9709143e1f593f0000000 : -1

// TODO: figure out 'internal error: entered unreachable code: Can only multiply linear terms' issue. 
// refer to this https://github.com/noir-lang/noir/issues/580
// Error is fixed but cant update the noir version atm. (build not working so using prebuilt binary)

// Returns the transpose of an AxB matrix
global A = 2;
global B = 3;
fn transpose_AB(values: [u64; A*B]) -> [u64; A*B] {     
    let mut out = [0; A*B];
    for i in 0..A {
        for j in 0..B {
            out[i+A*j] = values[j+B*i];
        };
    };
    out
}

// Returns the product of an N*M and an MxL matrix
global N = 2;
global M = 2;
global L = 2;
fn multiply_NML(values1: [u64;N*M], values2: [u64;M*L]) -> [u64;N*L] {
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

// Returns the matrix minor of a KxK matrix at position row i and column j
global K = 4;
fn matrixMinor_K(values: [u64;K*K], i: Field, j: Field) -> [u64;(K-1)*(K-1)+1] {
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

// Returns the determinant of a DxD matrix via a reduction to its upper triangular
global D = 3;
fn determinant_D(values: [Field;D*D]) -> Field {
    // Building the upper triangular matrix
    let mut m = values;
    for fd in 0 .. D {
        for i in fd+1 .. D {
            // ignoring div 0 issue for now
            let crScalar = m[i*D+fd] / m[fd*D+fd];
            for j in 0 .. D {
                m[i*D+j] = m[i*D+j] - crScalar*m[fd*D+j];
            }
        }
    }
    // The determinant is the product of the diagonal of the upper triangular matrix
    let mut det = 1;
    for i in 0 .. D {
        det = det*m[i*D+i];
    }
    det
}

// Returns the square root of a number
global MAX_ITER = 10;
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

// Test circuits: 

// fn main() {
//     let m = [1,2,3,4,5,6];
//     let a = transpose_AB(m);
//     constrain a[0] == 1;
//     constrain a[1] == 4;
//     constrain a[2] == 2;
//     constrain a[3] == 5;
//     constrain a[4] == 3;
//     constrain a[5] == 6;
// }

// fn main() {
//     let m = [6,2,1,0,2,1,1,5,2];
//     let a = determinant_D(m);
//     constrain a == 0x30644e72e131a029b85045b68181585d2833e84879b9709143e1f593effffffb; // -6
// }

// fn main() {
//     let s = sqrt(81);
//     constrain s == 9;
// }

// fn main() {
//     let m1 = [1,2,3,4];
//     let m2 = [5,6,7,8];
//     let m3 = multiply_NML(m1,m2);
//     constrain m3[0] == 19;
//     constrain m3[1] == 22;
//     constrain m3[2] == 43;
//     constrain m3[3] == 50;
// }

fn main() {
    let m = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16];
    let a = matrixMinor_K(m,2,1);
    constrain a[0] == 1;
    constrain a[1] == 3;
    constrain a[2] == 4;
    constrain a[3] == 5;
    constrain a[4] == 7;
    constrain a[5] == 8;
    constrain a[6] == 13;
    constrain a[7] == 15;
    constrain a[8] == 16;    
}


