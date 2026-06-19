#!/usr/bin/env node
import fs from "node:fs";
import zlib from "node:zlib";

const size = 1024;
const out = "assets/app_icon.png";
const pixels = Buffer.alloc((size * 4 + 1) * size);

function setPixel(x, y, r, g, b, a = 255) {
  if (x < 0 || y < 0 || x >= size || y >= size) return;
  const row = y * (size * 4 + 1);
  const index = row + 1 + x * 4;
  pixels[index] = r;
  pixels[index + 1] = g;
  pixels[index + 2] = b;
  pixels[index + 3] = a;
}

function fillCircle(cx, cy, radius, color) {
  const [r, g, b, a = 255] = color;
  for (let y = Math.max(0, cy - radius); y <= Math.min(size - 1, cy + radius); y++) {
    for (let x = Math.max(0, cx - radius); x <= Math.min(size - 1, cx + radius); x++) {
      if ((x - cx) ** 2 + (y - cy) ** 2 <= radius ** 2) setPixel(x, y, r, g, b, a);
    }
  }
}

function fillRect(x0, y0, w, h, color) {
  const [r, g, b, a = 255] = color;
  for (let y = y0; y < y0 + h; y++) {
    for (let x = x0; x < x0 + w; x++) setPixel(x, y, r, g, b, a);
  }
}

function fillRoundedRect(x0, y0, w, h, radius, color) {
  for (let y = y0; y < y0 + h; y++) {
    for (let x = x0; x < x0 + w; x++) {
      const dx = x < x0 + radius ? x0 + radius - x : x >= x0 + w - radius ? x - (x0 + w - radius - 1) : 0;
      const dy = y < y0 + radius ? y0 + radius - y : y >= y0 + h - radius ? y - (y0 + h - radius - 1) : 0;
      if (dx * dx + dy * dy <= radius * radius) setPixel(x, y, ...color);
    }
  }
}

function fillPolygon(points, color) {
  const [r, g, b, a = 255] = color;
  const minY = Math.max(0, Math.floor(Math.min(...points.map((p) => p[1]))));
  const maxY = Math.min(size - 1, Math.ceil(Math.max(...points.map((p) => p[1]))));
  for (let y = minY; y <= maxY; y++) {
    const nodes = [];
    for (let i = 0, j = points.length - 1; i < points.length; j = i++) {
      const [xi, yi] = points[i];
      const [xj, yj] = points[j];
      if ((yi < y && yj >= y) || (yj < y && yi >= y)) {
        nodes.push(Math.floor(xi + ((y - yi) / (yj - yi)) * (xj - xi)));
      }
    }
    nodes.sort((a, b) => a - b);
    for (let k = 0; k < nodes.length; k += 2) {
      for (let x = nodes[k]; x < nodes[k + 1]; x++) setPixel(x, y, r, g, b, a);
    }
  }
}

for (let y = 0; y < size; y++) pixels[y * (size * 4 + 1)] = 0;
fillCircle(512, 512, 500, [255, 59, 48]);
fillRoundedRect(270, 300, 484, 360, 95, [255, 255, 255]);
fillCircle(405, 455, 48, [26, 26, 46]);
fillCircle(620, 455, 48, [26, 26, 46]);
fillRoundedRect(415, 560, 195, 50, 22, [26, 26, 46]);
fillRect(490, 245, 44, 80, [255, 255, 255]);
fillCircle(512, 220, 42, [255, 204, 0]);
fillPolygon(
  [
    [710, 600],
    [905, 600],
    [790, 760],
    [900, 760],
    [660, 1000],
    [735, 805],
    [620, 805],
  ],
  [255, 204, 0],
);

function chunk(type, data) {
  const header = Buffer.alloc(8);
  header.writeUInt32BE(data.length, 0);
  header.write(type, 4, 4, "ascii");
  const crc = Buffer.alloc(4);
  crc.writeUInt32BE(crc32(Buffer.concat([Buffer.from(type), data])), 0);
  return Buffer.concat([header, data, crc]);
}

function crc32(buffer) {
  let c = ~0;
  for (const byte of buffer) {
    c ^= byte;
    for (let k = 0; k < 8; k++) c = c & 1 ? 0xedb88320 ^ (c >>> 1) : c >>> 1;
  }
  return ~c >>> 0;
}

const signature = Buffer.from([137, 80, 78, 71, 13, 10, 26, 10]);
const ihdr = Buffer.alloc(13);
ihdr.writeUInt32BE(size, 0);
ihdr.writeUInt32BE(size, 4);
ihdr[8] = 8;
ihdr[9] = 6;
const png = Buffer.concat([
  signature,
  chunk("IHDR", ihdr),
  chunk("IDAT", zlib.deflateSync(pixels)),
  chunk("IEND", Buffer.alloc(0)),
]);
fs.mkdirSync("assets", {recursive: true});
fs.writeFileSync(out, png);
console.log(`Wrote ${out}`);
