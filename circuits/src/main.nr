use dep::std;

global ROWS = 2;
global COLS = 2;
global VALS = 4; //ROWS*COLS

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
        let m = Matrix::new(self.cols, self.rows, out);
        m
    }
}

fn main(x: Field, y: pub Field) -> pub Field {
    let m = Matrix::new(ROWS,COLS,[x,y,3,4]);
    let t = m.transpose();
    t.values[3]
}


// fn sum_array(arr: [Field]) -> Field {
//     std::array::sum(arr)
// }