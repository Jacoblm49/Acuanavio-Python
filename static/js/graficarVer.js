const graficas = document.getElementsByClassName('graficas__herramientas')

function getRandomNumber(min, max) {
  return Math.floor(Math.random() * (max - min + 1)) + min;
}

const randomNumber = getRandomNumber(100, 3000);

document.getElementById('graficas-btn').addEventListener('click',()=>{
setTimeout(()=>{
 for (let index = 0; index < graficas.length; index++) {
  graficas[index].classList.toggle('active')
 }
  
},randomNumber)
})