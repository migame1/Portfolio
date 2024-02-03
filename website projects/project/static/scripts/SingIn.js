


const singInForm = document.getElementById("singIn-form")


singInForm.addEventListener('submit', (e) => {

    e.preventDefault()
    const email = document.getElementById("email").value
    const password = document.getElementById("psw").value
    
    auth.signInWithEmailAndPassword(email, password)
    .then(() => {
        if (auth.currentUser.emailVerified) {
            console.log("user loged in successfully")
            document.location="sellerHub.html"
        }  else {
            alert("email is not verified")
        }
        
    })
    .catch((err) => {
        
        alert(err)
    })   
})
