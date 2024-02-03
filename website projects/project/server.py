from flask import Flask, render_template

app = Flask('name', template_folder='')

@app.route("/")
@app.route("/index.html")
def index():
    return render_template("index.html")

@app.route("/buyer.html")
def buyer():
    return render_template("buyer.html")

@app.route("/singin.html")
def singin():
    return render_template("singin.html")

@app.route("/register.html")
def register():
    return render_template("register.html")

@app.route("/sellerHub.html")
def sellerHub():
    return render_template("sellerHub.html")

@app.route("/addProduct.html")
def addProduct():
    return render_template("addProduct.html")

@app.route("/myProducts.html")
def myProducts():
    return render_template("myProducts.html")

app.run()