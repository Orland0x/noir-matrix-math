// use dep::std;

global ROWS = 2;
global COLS = 2;
global VALS = 4; //ROWS*COLS

global ROWS2 = 2;
global COLS2 = 2;
global VALS2 = 4; //ROWS*COLS

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

fn main(x: Field, y: pub Field) -> pub Field {
    let m1 = Matrix::new(ROWS,COLS,[x,y,3,4]);
    let m2 = Matrix::new(ROWS,COLS,[5,6,7,8]);
    let m3 = multiply(m1,m2);
    m3.values[3]
}

// raw matrix inversion: 
// https://stackoverflow.com/questions/32114054/matrix-inversion-without-numpy