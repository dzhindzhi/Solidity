const randomWait = () => {
  return new Promise((resolve) => {
    const min = 1
    const max = 4
    const rand = Math.floor(Math.random() * (max - min + 1)) + min
    console.log(`ждем ${rand} секунд${rand == 1 ? "у" : "ы"}`)
    setTimeout(() => {
      resolve()
    }, rand * 1000)
  })
}

console.log("A")
randomWait().then(() => {
    // Этот код срабатывает после успешного выполнения функции randomWait()
    console.log("B")
})
console.log("C")