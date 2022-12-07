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

function pedersenLeftRight(
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

function path_to_uint8array(path: string) {
  let buffer = readFileSync(path);
  return new Uint8Array(buffer);
}

describe("Matrix Operations", function() {
    it("Should perform matrix operations", async function() {
        let acirByteArray = path_to_uint8array(path.resolve(__dirname, '../circuits/build/p.acir'));
        let acir = acir_from_bytes(acirByteArray);

        // The abi can also be specified using hex strings, just make sure there is an even number of bytes
        let abi = {
            x: 1,
            y: 2,
            return: 2,
        }

        let [prover, verifier] = await setup_generic_prover_and_verifier(acir);
 

        const proof = await create_proof(prover, acir, abi);
        const verified = await verify_proof(verifier, proof);
      
        console.log(verified);

        expect(verified).eq(true)
    });
});

