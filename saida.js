// Arquivo gerado pelo compilador PixelScript

let pen_x = 0; let pen_y = 0; let pen_thickness = 1;

// Aqui começa o código gerado
const canvas = document.getElementById('pixelCanvas');
const ctx = canvas.getContext('2d');
canvas.width = 100;
canvas.height = 100;
pen_thickness = Math.max(1, Math.floor(canvas.width * 0.01));
let num_celulas = 10;
let tamanho_canvas = 100;
let tamanho_celula = (tamanho_canvas / num_celulas);
let y = 0;
for (let _i = 0; _i < num_celulas; _i++) {
let x = 0;
for (let _i = 0; _i < num_celulas; _i++) {
pen_x = x;
pen_y = y;
if (((x + y)) < tamanho_canvas) {
ctx.fillStyle = `rgb(0, 0, 255)`;
} else {
ctx.fillStyle = `rgb(255, 165, 0)`;
}
ctx.fillRect(pen_x, pen_y, tamanho_celula, tamanho_celula);
x = (x + tamanho_celula);
}
y = (y + tamanho_celula);
}
// Aqui termina o código gerado

console.log('Execução do PixelScript finalizada.');
