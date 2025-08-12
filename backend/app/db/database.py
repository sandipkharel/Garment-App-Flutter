# Database configuration for FastAPI backend
from sqlalchemy.ext.asyncio import create_async_engine, AsyncSession
from sqlalchemy.orm import sessionmaker, declarative_base
import os

DATABASE_URL = "postgresql+asyncpg://postgres.ozwafwmqvinazjhjbcio:aA%4035763576@aws-0-ap-south-1.pooler.supabase.com:5432/postgres"

engine = create_async_engine(DATABASE_URL, echo=True)
SessionLocal = sessionmaker(bind=engine, class_=AsyncSession, expire_on_commit=False)
Base = declarative_base()
