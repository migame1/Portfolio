auth.onAuthStateChanged(user => {
    if(user == null){
        document.location="register.html"
    }
})

const signOut = document.getElementById("sign-out")

signOut.addEventListener("click", e => {
    auth.signOut()
})