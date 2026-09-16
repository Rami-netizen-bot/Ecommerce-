from fastapi import FastAPI, Depends, HTTPException
from sqlalchemy.orm import Session, joinedload
from typing import List
from pydantic import BaseModel, EmailStr

from app.database import engine, Base, get_db
from app import models

# Create database tables automatically on startup
Base.metadata.create_all(bind=engine)

app = FastAPI(title="E-Commerce API", version="1.0.0")

# --- Pydantic Schemas for Requests/Responses ---
class UserCreate(BaseModel):
    username: str
    email: str
    password: str

class UserLogin(BaseModel):
    email: str
    password: str

class ProductCreate(BaseModel):
    title: str
    description: str | None = None
    price: float
    category: str
    image_url: str | None = None

class OrderItemCreate(BaseModel):
    product_id: int
    quantity: int

class OrderCreate(BaseModel):
    user_id: int = 1  
    total_price: float
    items: List[OrderItemCreate]

class ProductInOrder(BaseModel):
    id: int
    title: str
    price: float
    image_url: str | None = None

    class Config:
        from_attributes = True

class OrderItemOut(BaseModel):
    id: int
    quantity: int
    product: ProductInOrder | None = None

    class Config:
        from_attributes = True

class OrderOut(BaseModel):
    id: int
    user_id: int
    total_price: float
    status: str   
    items: List[OrderItemOut] = []

    class Config:
        from_attributes = True

class ProductOut(BaseModel):
    id: int
    title: str
    description: str | None = None
    price: float
    category: str
    image_url: str | None = None

    class Config:
        from_attributes = True

# --- API Endpoints ---
@app.get("/")
def read_root():
    return {"message": "Welcome to the E-Commerce FastAPI Backend!"}

# --- Authentication Endpoints ---
@app.post("/auth/register")
def register_user(user: UserCreate, db: Session = Depends(get_db)):
    existing_user = db.query(models.User).filter(
        (models.User.email == user.email) | (models.User.username == user.username)
    ).first()
    if existing_user:
        raise HTTPException(status_code=400, detail="Email or username already registered")
    
    db_user = models.User(
        username=user.username,
        email=user.email,
        hashed_password=user.password  # Note: Plain text for simplicity, hash in production
    )
    db.add(db_user)
    db.commit()
    db.refresh(db_user)
    return {"message": "User registered successfully", "user_id": db_user.id}

@app.post("/auth/login")
def login_user(credentials: UserLogin, db: Session = Depends(get_db)):
    db_user = db.query(models.User).filter(models.User.email == credentials.email).first()
    if not db_user or db_user.hashed_password != credentials.password:
        raise HTTPException(status_code=401, detail="Invalid email or password")
    
    return {"message": "Login successful", "user_id": db_user.id, "username": db_user.username}

# --- Product Endpoints ---
@app.get("/products/", response_model=List[ProductOut])
def get_products(skip: int = 0, limit: int = 10, category: str | None = None, db: Session = Depends(get_db)):
    query = db.query(models.Product)
    if category and category != "All":
        query = query.filter(models.Product.category == category)
    
    products = query.offset(skip).limit(limit).all()
    return products

@app.delete("/products/{product_id}")
def delete_product(product_id: int, db: Session = Depends(get_db)):
    product = db.query(models.Product).filter(models.Product.id == product_id).first()
    if not product:
        raise HTTPException(status_code=404, detail="Product not found")
    
    db.delete(product)
    db.commit()
    return {"message": "Product deleted successfully"}

@app.post("/products/", response_model=ProductOut)
def create_product(product: ProductCreate, db: Session = Depends(get_db)):
    db_product = models.Product(
        title=product.title, 
        description=product.description, 
        price=product.price, 
        category=product.category, 
        image_url=product.image_url
    )
    db.add(db_product)
    db.commit()
    db.refresh(db_product)
    return db_product

class ProductUpdate(BaseModel):
    title: str | None = None
    description: str | None = None
    price: float | None = None
    category: str | None = None
    image_url: str | None = None

@app.put("/products/{product_id}", response_model=ProductOut)
def update_product(product_id: int, product_data: ProductUpdate, db: Session = Depends(get_db)):
    db_product = db.query(models.Product).filter(models.Product.id == product_id).first()
    if not db_product:
        raise HTTPException(status_code=404, detail="Product not found")
    
    update_data = product_data.dict(exclude_unset=True)
    for key, value in update_data.items():
        setattr(db_product, key, value)
        
    db.commit()
    db.refresh(db_product)
    return db_product

# --- Order Endpoints ---
@app.post("/orders/", response_model=OrderOut)
def create_order(order_data: OrderCreate, db: Session = Depends(get_db)):
    db_order = models.Order(
        user_id=order_data.user_id,
        total_price=order_data.total_price,
        status="Completed"
    )
    db.add(db_order)
    db.commit()
    db.refresh(db_order)

    for item in order_data.items:
        db_item = models.OrderItem(
            order_id=db_order.id,
            product_id=item.product_id,
            quantity=item.quantity
        )
        db.add(db_item)
    
    db.commit()

    # Eagerly load items and nested products so OrderOut serializes them correctly
    db_order = (
        db.query(models.Order)
        .options(
            joinedload(models.Order.items).joinedload(models.OrderItem.product)
        )
        .filter(models.Order.id == db_order.id)
        .first()
    )
    return db_order

@app.get("/orders/{user_id}", response_model=List[OrderOut])
def get_user_orders(user_id: int, db: Session = Depends(get_db)):
    orders = (
        db.query(models.Order)
        .options(
            joinedload(models.Order.items).joinedload(models.OrderItem.product)
        )
        .filter(models.Order.user_id == user_id)
        .all()
    )
    return orders