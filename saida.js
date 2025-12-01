// Arquivo gerado pelo compilador PixelScript

let pen_x = 0; let pen_y = 0; let pen_thickness = 1;

// Aqui começa o código gerado
let tamanho_canvas = 1000;
const canvas = document.getElementById('pixelCanvas');
const ctx = canvas.getContext('2d');
canvas.width = tamanho_canvas;
canvas.height = tamanho_canvas;
pen_thickness = Math.max(1, Math.floor(canvas.width * 0.01));
let centro_x = (tamanho_canvas / 2);
let centro_y = (tamanho_canvas / 2);
let x = centro_x;
let y = centro_y;
pen_x = x;
pen_y = y;
let escala = (tamanho_canvas / 50);
let direcao = 0;
let passos = 1;
let contador_passos = 0;
let contador_giros = 0;
for (let _i = 0; _i < 100; _i++) {
if (direcao == 0) {
ctx.fillStyle = `rgb(255, 0, 0)`;
} else {
if (direcao == 1) {
ctx.fillStyle = `rgb(0, 255, 0)`;
} else {
if (direcao == 2) {
ctx.fillStyle = `rgb(0, 0, 255)`;
} else {
if (direcao == 3) {
ctx.fillStyle = `rgb(255, 165, 0)`;
}
}
}
}
let proximo_x = x;
let proximo_y = y;
if (direcao == 0) {
proximo_x = (x + ((passos * escala)));
} else {
if (direcao == 1) {
proximo_y = (y - ((passos * escala)));
} else {
if (direcao == 2) {
proximo_x = (x - ((passos * escala)));
} else {
if (direcao == 3) {
proximo_y = (y + ((passos * escala)));
}
}
}
}
ctx.beginPath(); ctx.lineWidth = pen_thickness; ctx.strokeStyle = ctx.fillStyle; ctx.moveTo(pen_x, pen_y); ctx.lineTo(proximo_x, proximo_y); ctx.stroke();
pen_x = proximo_x;
pen_y = proximo_y;
x = proximo_x;
y = proximo_y;
pen_x = x;
pen_y = y;
direcao = (direcao + 1);
if (direcao > 3) {
direcao = 0;
}
contador_giros = (contador_giros + 1);
if (contador_giros == 2) {
passos = (passos + 1);
contador_giros = 0;
}
}
// Aqui termina o código gerado

console.log('Execução do PixelScript finalizada.');
