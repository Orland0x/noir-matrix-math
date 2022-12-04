import { compile, acir_from_bytes } from '@noir-lang/noir_wasm';
import { SinglePedersen } from '@noir-lang/barretenberg/dest/crypto/pedersen';
import { BarretenbergWasm } from '@noir-lang/barretenberg/dest/wasm';
import { setup_generic_prover_and_verifier, create_proof, verify_proof, create_proof_with_witness } from '@noir-lang/barretenberg/dest/client_proofs';
import { packed_witness_to_witness, serialise_public_inputs, compute_witnesses } from '@noir-lang/aztec_backend';
import path from 'path';
import { readFileSync } from 'fs';
import { expect } from 'chai';
import { ethers } from "hardhat";
import { Contract, ContractFactory, utils } from 'ethers';

export function pedersenLeftRight(
    barretenberg: BarretenbergWasm, 
    left: string, 
    right: string): string {
      let leftBuffer = Buffer.from(left, 'hex');
      console.log(leftBuffer);
      let rightBuffer = Buffer.from(right, 'hex');
      console.log(rightBuffer);
      let pedersen = new SinglePedersen(barretenberg);
      let hashRes = pedersen.compress(leftBuffer, rightBuffer);
      return hashRes.toString('hex')
  }

  const toFixedHex = (number: number, pad0x: boolean, length = 32) => {
    let hexString = number.toString(16).padStart(length * 2, '0');
    return (pad0x ? `0x` + hexString : hexString);
  }

describe("1_mul", function() {

    it("Should verify proof using abi and acir from typescript", async function() {        
        // Compile noir program
        const compiled_program = compile(path.resolve(__dirname, '../circuits/src/main.nr')); 
        let acir = compiled_program.circuit;
        const abi = compiled_program.abi;
        const barretenberg = await BarretenbergWasm.new();
        let pedersen: SinglePedersen;
        pedersen = new SinglePedersen(barretenberg);

        let a = 1234;
        let b = 5678;
        let hash = '0x'+pedersen.compressInputs([Buffer.from(toFixedHex(a, false), 'hex'), Buffer.from(toFixedHex(b, false), 'hex')]).toString('hex');
        console.log(Buffer.from(toFixedHex(1, false), 'hex'))
        console.log(hash);
        // Specify abi
        abi.x = a;
        abi.y = b;
        abi.return = hash;

        let [prover, verifier] = await setup_generic_prover_and_verifier(acir);
 
        const proof = await create_proof(prover, acir, abi);

        const verified = await verify_proof(verifier, proof);
      
        console.log(verified);

        expect(verified).eq(true)
    });

    // it("Should verify proof using acir from file and abi for typescript", async function() {
    //     let acirByteArray = path_to_uint8array(path.resolve(__dirname, '../circuits/build/p.acir'));
    //     let acir = acir_from_bytes(acirByteArray);

    //     // The abi can also be specified using hex strings, just make sure there is an even number of bytes
    //     let abi = {
    //         x: 3,
    //         y: 4,
    //         return: 12,
    //     }

    //     let [prover, verifier] = await setup_generic_prover_and_verifier(acir);
 
    //     const proof = await create_proof(prover, acir, abi);

    //     const verified = await verify_proof(verifier, proof);
      
    //     console.log(verified);

    //     expect(verified).eq(true)
    // });

    // it("Should verify proof using witness arr", async function() {
    //     let acirByteArray = path_to_uint8array(path.resolve(__dirname, '../circuits/build/p.acir'));
    //     let acir = acir_from_bytes(acirByteArray);

    //     let witnessByteArray = path_to_uint8array(path.resolve(__dirname, '../circuits/build/p.tr'));
    //     const barretenberg_witness_arr = await packed_witness_to_witness(acir, witnessByteArray);

    //     let [prover, verifier] = await setup_generic_prover_and_verifier(acir);
    
    //     const proof = await create_proof_with_witness(prover, barretenberg_witness_arr);
    
    //     const verified = await verify_proof(verifier, proof);

    //     expect(verified).eq(true)
    // });

    // it("Should verify proof using compute witness", async function() {
    //     let acirByteArray = path_to_uint8array(path.resolve(__dirname, '../circuits/build/p.acir'));
    //     let acir = acir_from_bytes(acirByteArray);

    //     let [prover, verifier] = await setup_generic_prover_and_verifier(acir);
 
    //     let initial_js_witness = ["0x03", "0x04", "0x0c"];
    //     // NOTE: breaks without even number of bytes specified, the line below does not work
    //     // let initial_js_witness = ["0x3", "0x4", "0x5100"];

    //     let barretenberg_witness_arr = compute_witnesses(acir, initial_js_witness);

    //     const proof = await create_proof_with_witness(prover, barretenberg_witness_arr);
    
    //     const verified = await verify_proof(verifier, proof);

    //     expect(verified).eq(true)
    // });

});

// describe('1_mul using solidity verifier', function() {
//     let Verifier: ContractFactory;
//     let verifierContract: Contract;

//     before(async () => {
//         Verifier = await ethers.getContractFactory("TurboVerifier");
//         verifierContract = await Verifier.deploy();
//     });

//     it("Should verify using proof generated by typescript wrapper", async () => {
//         const compiled_program = compile(path.resolve(__dirname, '../circuits/src/main.nr')); 
//         let acir = compiled_program.circuit;

//         let abi = {
//             x: 3,
//             y: 4,
//             return: 12,
//         }

//         let [prover, verifier] = await setup_generic_prover_and_verifier(acir);
 
//         const proof = await create_proof(prover, acir, abi);

//         const verified = await verify_proof(verifier, proof);
//         expect(verified).eq(true)

//         const sc_verified = await verifierContract.verify(proof);
//         expect(sc_verified).eq(true)
//     });

// });

function path_to_uint8array(path: string) {
    let buffer = readFileSync(path);
    return new Uint8Array(buffer);
}