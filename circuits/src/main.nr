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

fn multiply5x5_5x5(values1: [u64;5*5], values2: [u64;5*5]) -> [u64;5*5] {
    // Currently comptime variables are not allowed in function arguments, 
    // therefore we define them here until that feature is added.
    // Note: A new multiplcation function is needed for each shape of input matricies. 
    let rows1: comptime Field = 5;
    let cols1: comptime Field = 5;
    let rows2: comptime Field = 5;
    let cols2: comptime Field = 5;

    constrain rows2 == cols1;

    let mut out = [0;25];
    for i in 0 .. cols2 {
        for j in 0 .. rows1 {
            let mut t = 0;
            for k in 0 .. cols1  {
                t = t + values1[i*cols1+k]*values2[j+rows2*k];
            };
            out[j+cols1*i] = t;
        };
    };
    out
}

fn matrixMinor(values: [u64], i: u64, j: u64) -> [u64] {
    let mut out = [0;4]
}

// determinant can only be found for square matricies so we can infer the shape from the 
// square root of the number of values. 
fn determinant(values: [u64]) -> u64 {

}


// fn invert2x2_2x2()




fn main(m1: [u64;25], m2: pub [u64;25]) -> pub u64 {
    let o = multiply5x5_5x5(m1, m2);
    o[0]
}

// fn main(x: Field, y: pub Field) -> pub Field {
//     // let m1 = Matrix::new(ROWS,COLS,[x,y,3,4]);
//     // let m2 = Matrix::new(ROWS,COLS,[5,6,7,8]);
//     // let m3 = multiply(m1,m2);
//     // m3.values[3]

//     let m1 = [x,1,2,3];
//     let m2 = [y,5,6,7];
//     let m3 = [0,0,0,0];
//     let m4 = multiply6(2,2,m1,2,2,m2,m3);
//     let o = m4[0];
//     o
// }

// [2,1
//  2,3]

// [3,5
//  6,7]

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

