const search = document.getElementById("search")
const productList = document.querySelector('#produts-search')
const viewProduct = document.getElementById('produts-search')
const popWindow = document.getElementById('product-window')
const popWindowWright = document.querySelector('.container')


function renderDeitalis(doc) {
  
  let li = document.createElement('li')
  let name = document.createElement('h2')
  let price = document.createElement('span')
  let categorie = document.createElement('span')
  let subCategorie = document.createElement('h3')
  let email = document.createElement('span')
  let cross = document.createElement('div')
  let descreption = document.createElement('p')
  let descreptionSpacer = document.createElement("span")


  subCategorieText = doc.data().subCategorie
  subCategorieText = subCategorieText.replaceAll('-', ' ')


  name.textContent = doc.data().name
  price.textContent = "price - " + doc.data().price + "$"
  descreption.textContent = doc.data().descreption
  descreptionSpacer.textContent = "descreption:"
  subCategorie.textContent = subCategorieText
  email.textContent = "email to contact - " + doc.data().email
  cross.textContent = "x"
  

  name.setAttribute("class", "title")
  descreptionSpacer.setAttribute("class", "descreptionSpacer")

  li.appendChild(name)
  li.appendChild(subCategorie)
  li.appendChild(price)
  li.appendChild(email)
  li.appendChild(cross)
  li.appendChild(descreptionSpacer)
  li.appendChild(descreption)



  popWindowWright.appendChild(li)
  
  cross.addEventListener('click', (e) => {
    e.preventDefault()
    document.getElementById("product-window-inner").innerHTML = ""
    popWindow.style.display = "none"


})


}

function renderProducts(doc) {
  let li = document.createElement('li')
  let name = document.createElement('span')
  let price = document.createElement('span')


  li.setAttribute('data-id', doc.id)
  name.textContent = doc.data().name
  price.textContent = doc.data().price + "$"


  li.appendChild(name)
  li.appendChild(price)


  productList.appendChild(li)



  li.addEventListener('click', (e) => {


    renderDeitalis(doc)
  
  
    popWindow.style.display = "block"
  
  })

}




viewProduct.addEventListener('click', (e) => {


  renderDeitalis()

  db.collection("products").doc().get()

  popWindow.style.display = "block"

})



search.addEventListener("submit", async (e) => {
    e.preventDefault()
    const searchField = document.getElementById("searchField").value
    document.getElementById("produts-search").innerHTML = ""
    const products = [
      (await db.collection("products").where("name", "==", searchField).get()).docs,
      (await db.collection("products").where("subCategorie", "==", searchField).get()).docs,
      (await db.collection("products").where("categorie", "==", searchField).get()).docs,
      (await db.collection("products").where("shopName", "==", searchField).get()).docs
    ].flat()
    products.forEach(doc => {
      renderProducts(doc)
    });
})