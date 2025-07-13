// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract DescriptionStore {
    function getDescription(string memory format) external pure returns (string memory) {
        if (keccak256(bytes(format)) == keccak256(bytes("1L1D"))) return "The first breath of structure. A relic of pre-chain memory, unaltered by entropy.";
        if (keccak256(bytes(format)) == keccak256(bytes("1L2D"))) return "Carved in rumor and protocol. Known by few, understood by none.";
        if (keccak256(bytes(format)) == keccak256(bytes("2L1D"))) return "Drawn from orbital balance  cold, silent, and aligned with distant logic.";
        if (keccak256(bytes(format)) == keccak256(bytes("2L2D"))) return "Patterned in symmetry. Obeys a deeper structure beneath the chain.";
        if (keccak256(bytes(format)) == keccak256(bytes("3L1D"))) return "Rediscovered architecture from the early stack. Dusty, but indestructible.";
        if (keccak256(bytes(format)) == keccak256(bytes("1L3D"))) return "Like glyphs burned into the chain. Strange characters that hum in silence.";
        if (keccak256(bytes(format)) == keccak256(bytes("1L4D"))) return "Curved across time and intent. Moves fast and leaves little behind.";
        if (keccak256(bytes(format)) == keccak256(bytes("3L2D"))) return "Drawn from the dark between functions. You see only its shadow.";
        if (keccak256(bytes(format)) == keccak256(bytes("2L3D"))) return "Unstable and fleeting. A flicker of form between certainty and noise.";
        if (keccak256(bytes(format)) == keccak256(bytes("4L1D"))) return "Buried deep in forgotten logic. Old code that still grows.";
        if (keccak256(bytes(format)) == keccak256(bytes("4L2D"))) return "Engineered to evolve. Mutates with purpose as it spreads.";
        if (keccak256(bytes(format)) == keccak256(bytes("1L5D"))) return "A volatile stream of digits. Burns bright, then vanishes without trace.";
        if (keccak256(bytes(format)) == keccak256(bytes("3L3D"))) return "A lattice of shifting logic. What you see isn't always what's there.";
        if (keccak256(bytes(format)) == keccak256(bytes("2L4D"))) return "Thin threads connect it to the rest. Sometimes it pulses. Sometimes it waits.";
        if (keccak256(bytes(format)) == keccak256(bytes("3L4D"))) return "Frozen logic. Sealed tight, unmoving until called.";
        if (keccak256(bytes(format)) == keccak256(bytes("2L5D"))) return "Fragments of synthetic thought. Alive, reactive, and uncertain.";
        if (keccak256(bytes(format)) == keccak256(bytes("4L3D"))) return "Steel logic hardened into structure. Unbending and exact.";
        if (keccak256(bytes(format)) == keccak256(bytes("3L5D"))) return "Every symbol is a challenge. A self-contained system of questions.";
        if (keccak256(bytes(format)) == keccak256(bytes("4L4D"))) return "A flash in protocol. Appears once, leaves a signal behind.";
        if (keccak256(bytes(format)) == keccak256(bytes("4L5D"))) return "The central core. The structure around which all others revolve.";
        return "Unknown structure.";
    }

    function getFormatName(string memory format) external pure returns (string memory) {
        if (keccak256(bytes(format)) == keccak256(bytes("1L1D"))) return "Primordial";
        if (keccak256(bytes(format)) == keccak256(bytes("1L2D"))) return "Mythic";
        if (keccak256(bytes(format)) == keccak256(bytes("2L1D"))) return "Celestial";
        if (keccak256(bytes(format)) == keccak256(bytes("1L3D"))) return "Runic";
        if (keccak256(bytes(format)) == keccak256(bytes("3L1D"))) return "Ancient";
        if (keccak256(bytes(format)) == keccak256(bytes("2L2D"))) return "Sacred";
        if (keccak256(bytes(format)) == keccak256(bytes("4L1D"))) return "Darkroot";
        if (keccak256(bytes(format)) == keccak256(bytes("1L4D"))) return "Arc";
        if (keccak256(bytes(format)) == keccak256(bytes("2L3D"))) return "Specter";
        if (keccak256(bytes(format)) == keccak256(bytes("3L2D"))) return "Vanta";
        if (keccak256(bytes(format)) == keccak256(bytes("1L5D"))) return "Binary Flame";
        if (keccak256(bytes(format)) == keccak256(bytes("2L4D"))) return "Ghostwire";
        if (keccak256(bytes(format)) == keccak256(bytes("4L2D"))) return "Daemonseed";
        if (keccak256(bytes(format)) == keccak256(bytes("3L3D"))) return "Shadowgrid";
        if (keccak256(bytes(format)) == keccak256(bytes("2L5D"))) return "Neurobyte";
        if (keccak256(bytes(format)) == keccak256(bytes("3L4D"))) return "Cryo-Vault";
        if (keccak256(bytes(format)) == keccak256(bytes("4L3D"))) return "Ironline";
        if (keccak256(bytes(format)) == keccak256(bytes("3L5D"))) return "Technocrypt";
        if (keccak256(bytes(format)) == keccak256(bytes("4L4D"))) return "Echoflare";
        if (keccak256(bytes(format)) == keccak256(bytes("4L5D"))) return "Mainframe";
        return "Unknown";
    }

    function getDropRate(string memory format) external pure returns (string memory) {
        if (keccak256(bytes(format)) == keccak256(bytes("1L1D"))) return "0.001%";
        if (keccak256(bytes(format)) == keccak256(bytes("1L2D"))) return "0.01%";
        if (keccak256(bytes(format)) == keccak256(bytes("2L1D"))) return "0.01%";
        if (keccak256(bytes(format)) == keccak256(bytes("2L2D"))) return "0.1%";
        if (keccak256(bytes(format)) == keccak256(bytes("3L1D"))) return "0.1%";
        if (keccak256(bytes(format)) == keccak256(bytes("1L3D"))) return "0.1%";
        if (keccak256(bytes(format)) == keccak256(bytes("1L4D"))) return "1%";
        if (keccak256(bytes(format)) == keccak256(bytes("3L2D"))) return "1%";
        if (keccak256(bytes(format)) == keccak256(bytes("2L3D"))) return "1%";
        if (keccak256(bytes(format)) == keccak256(bytes("4L1D"))) return "1%";
        if (keccak256(bytes(format)) == keccak256(bytes("4L2D"))) return "7%";
        if (keccak256(bytes(format)) == keccak256(bytes("1L5D"))) return "7%";
        if (keccak256(bytes(format)) == keccak256(bytes("3L3D"))) return "7%";
        if (keccak256(bytes(format)) == keccak256(bytes("2L4D"))) return "7%";
        if (keccak256(bytes(format)) == keccak256(bytes("3L4D"))) return "10%";
        if (keccak256(bytes(format)) == keccak256(bytes("2L5D"))) return "10%";
        if (keccak256(bytes(format)) == keccak256(bytes("4L3D"))) return "10%";
        if (keccak256(bytes(format)) == keccak256(bytes("3L5D"))) return "13%";
        if (keccak256(bytes(format)) == keccak256(bytes("4L4D"))) return "13%";
        if (keccak256(bytes(format)) == keccak256(bytes("4L5D"))) return "11.679%";
        return "Unknown";
    }
}