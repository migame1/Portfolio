auth.onAuthStateChanged(user => {
    if(user == null){
        document.location="register.html"
    }
  })
  

let userID = null
const productList = document.querySelector('#products-list')

function renderProducts(doc) {
    let li = document.createElement('li')
    let name = document.createElement('span')
    let price = document.createElement('span')
    let cross = document.createElement('div')

    li.setAttribute('data-id', doc.id)
    name.textContent = doc.data().name
    price.textContent = doc.data().price + "$"
    cross.textContent = "x"


    li.appendChild(name)
    li.appendChild(price)
    li.appendChild(cross)


    productList.appendChild(li)


    cross.addEventListener('click', (e) => {
        e.preventDefault()
        let id = e.target.parentElement.getAttribute('data-id')
        if (confirm("are you sure you want to delete the product?")){
            db.collection("products").doc(id).delete()
        }
        
    })

}


db.collection("shops").get()
    .then((snapshot) => {
        snapshot.docs.forEach(doc => {

            auth.currentUser.providerData.forEach((profile) => {

                if (profile.email == doc.data().email) {
                    userEmail = doc.data().email
                }

            })
        })
    })

.then(() => {
    db.collection('products').orderBy('name').onSnapshot(snapshot => {
        let changes = snapshot.docChanges()
        changes.forEach(change => {
            if (change.type == "added" && userEmail == change.doc.data().email) {
                renderProducts(change.doc)
            } else if (change.type == "removed") {
                let li = productList.querySelector('[data-id=' + change.doc.id + ']')
                productList.removeChild(li)
            }
        })
    })
})





