# User model for authentication and order management
from sqlalchemy import Column, Integer, String, Boolean, DateTime, ForeignKey, Float
from app.db.database import Base
import datetime

# User model for authentication and order management
class User(Base):
    __tablename__ = "users"
    id = Column(Integer, primary_key=True, index=True)
    email = Column(String, unique=True, index=True, nullable=False)
    hashed_password = Column(String, nullable=False)
    full_name = Column(String)
    is_active = Column(Boolean, default=True)
    created_at = Column(DateTime, default=datetime.datetime.utcnow)

# Pattern model for garment patterns
class Pattern(Base):
    __tablename__ = "patterns"
    id = Column(Integer, primary_key=True, index=True)
    name = Column(String, nullable=False)
    description = Column(String)
    file_url = Column(String)
    created_at = Column(DateTime, default=datetime.datetime.utcnow)

# Order model for pattern purchases
from sqlalchemy.orm import relationship
class Order(Base):
    __tablename__ = "orders"
    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.id"))
    pattern_id = Column(Integer, ForeignKey("patterns.id"))
    status = Column(String, default="pending")
    total_price = Column(Float)
    created_at = Column(DateTime, default=datetime.datetime.utcnow)
    user = relationship("User")
    pattern = relationship("Pattern")
