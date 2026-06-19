-- Freelance Marketplace Database Schema
-- PostgreSQL

-- Users table
CREATE TABLE IF NOT EXISTS users (
  id SERIAL PRIMARY KEY,
  email VARCHAR(255) UNIQUE NOT NULL,
  password_hash VARCHAR(255) NOT NULL,
  full_name VARCHAR(255) NOT NULL,
  user_type VARCHAR(50) NOT NULL, -- 'client' or 'freelancer'
  avatar_url TEXT,
  rating DECIMAL(3, 2) DEFAULT 0,
  level VARCHAR(50) DEFAULT 'новичок', -- 'новичок', 'опытный', 'ветеран'
  phone VARCHAR(20),
  bio TEXT,
  is_verified BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Orders table
CREATE TABLE IF NOT EXISTS orders (
  id SERIAL PRIMARY KEY,
  client_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  title VARCHAR(255) NOT NULL,
  description TEXT NOT NULL,
  category VARCHAR(100), -- 'web', 'design', 'writing', etc.
  budget DECIMAL(10, 2) NOT NULL,
  required_level VARCHAR(50), -- 'новичок', 'опытный', 'ветеран'
  deadline DATE,
  status VARCHAR(50) DEFAULT 'open', -- 'open', 'in_progress', 'completed', 'cancelled'
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Applications table (заявки фрилансеров на заказы)
CREATE TABLE IF NOT EXISTS applications (
  id SERIAL PRIMARY KEY,
  order_id INTEGER NOT NULL REFERENCES orders(id) ON DELETE CASCADE,
  freelancer_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  cover_letter TEXT,
  proposed_price DECIMAL(10, 2),
  status VARCHAR(50) DEFAULT 'pending', -- 'pending', 'accepted', 'rejected'
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Contracts table (принятые заявки)
CREATE TABLE IF NOT EXISTS contracts (
  id SERIAL PRIMARY KEY,
  order_id INTEGER NOT NULL REFERENCES orders(id),
  freelancer_id INTEGER NOT NULL REFERENCES users(id),
  client_id INTEGER NOT NULL REFERENCES users(id),
  start_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  end_date TIMESTAMP,
  amount DECIMAL(10, 2) NOT NULL,
  status VARCHAR(50) DEFAULT 'active', -- 'active', 'completed', 'cancelled'
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Reviews table
CREATE TABLE IF NOT EXISTS reviews (
  id SERIAL PRIMARY KEY,
  from_user_id INTEGER NOT NULL REFERENCES users(id),
  to_user_id INTEGER NOT NULL REFERENCES users(id),
  contract_id INTEGER REFERENCES contracts(id),
  rating INTEGER CHECK (rating >= 1 AND rating <= 5),
  comment TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Payments table (для будущих платежей через Яндекс.Касса)
CREATE TABLE IF NOT EXISTS payments (
  id SERIAL PRIMARY KEY,
  contract_id INTEGER REFERENCES contracts(id),
  user_id INTEGER NOT NULL REFERENCES users(id),
  amount DECIMAL(10, 2) NOT NULL,
  status VARCHAR(50) DEFAULT 'pending', -- 'pending', 'completed', 'failed'
  payment_method VARCHAR(100),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Notifications table
CREATE TABLE IF NOT EXISTS notifications (
  id SERIAL PRIMARY KEY,
  user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  type VARCHAR(100), -- 'order_created', 'application_received', 'contract_accepted', etc.
  title VARCHAR(255),
  message TEXT,
  is_read BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for performance
CREATE INDEX idx_orders_client_id ON orders(client_id);
CREATE INDEX idx_orders_status ON orders(status);
CREATE INDEX idx_applications_order_id ON applications(order_id);
CREATE INDEX idx_applications_freelancer_id ON applications(freelancer_id);
CREATE INDEX idx_contracts_freelancer_id ON contracts(freelancer_id);
CREATE INDEX idx_notifications_user_id ON notifications(user_id);
