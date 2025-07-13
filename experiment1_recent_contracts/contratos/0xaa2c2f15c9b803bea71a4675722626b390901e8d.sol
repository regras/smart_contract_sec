// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract SVGStore {
    function getFullSVG(string memory code, string memory label) external pure returns (string memory) {
        return string(
            abi.encodePacked(
                "<svg xmlns='http://www.w3.org/2000/svg' width='300' height='420' viewBox='0 0 300 420'><defs>",
                "<filter id='glow' x='-50%' y='-50%' width='200%' height='200%'>",
                "<feDropShadow dx='0' dy='0' stdDeviation='4' flood-color='#2CFF05' flood-opacity='0.4'>",
                "<animate attributeName='flood-opacity' values='0.3;0.9;0.3' dur='3s' repeatCount='indefinite'/>",
                "</feDropShadow></filter>",
                "<pattern id='netGrid' width='20' height='20' patternUnits='userSpaceOnUse'>",
                "<path d='M20 0 L0 0 0 20' fill='none' stroke='#2CFF05' stroke-opacity='0.05' stroke-width='1'/>",
                "</pattern>",
                "<clipPath id='clipCard'><path d='M20,0 H280 Q300,0 300,20 V120 L290,130 V290 L300,300 V400 Q300,420 280,420 H20 Q0,420 0,400 V300 L10,290 V130 L0,120 V20 Q0,0 20,0 Z'/></clipPath>",
                "</defs>",
                "<rect width='300' height='420' fill='#121212'/>",
                "<rect width='300' height='420' fill='url(#netGrid)' clip-path='url(#clipCard)'/>",
                "<path d='M20,0 H280 Q300,0 300,20 V120 L290,130 V290 L300,300 V400 Q300,420 280,420 H20 Q0,420 0,400 V300 L10,290 V130 L0,120 V20 Q0,0 20,0 Z' fill='none' stroke='#2CFF05' stroke-width='1.5'/>",
                "<text x='50%' y='50%' text-anchor='middle' dominant-baseline='middle' font-family='monospace' font-size='45' fill='#2CFF05' filter='url(#glow)'>", code, "</text>",
                "<text x='30' y='390' font-family='monospace' font-size='10' fill='#2CFF05' opacity='0.7'>", label, "</text>",
                "</svg>"
            )
        );
    }
}