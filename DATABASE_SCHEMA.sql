-- PostgreSQL Schema для Freelance Marketplace
-- Хост: Yandex Cloud (Москва)

CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  email VARCHAR(255) UNIQUE NOT NULL,
  phone VARCHAR(20),
  password_hash VARCHAR(255) NOT NULL,
  full_name VARCHAR(255),
  avatar_url VARCHAR(500),
  bio TEXT,
  
  -- Тип: 'freelancer' или 'client'
  user_type VARCHAR(20) NOT NULL,
  
  -- Для фрилансеров
  experience_level VARCHAR(20), -- 'beginner', 'intermediate', 'expert'
  hourly_rate DECIMAL(10,2),
  skills TEXT[], -- Array: ['Python', 'JavaScript', ...]
  portfolio_url VARCHAR(500),
  
  -- Рейтинг
  rating DECIMAL(3,2) DEFAULT 0,
  reviews_count INT DEFAULT 0,
  
  -- Подписка
  subscription_type VARCHAR(20) DEFAULT 'free', -- 'free', 'premium', 'pro'
  subscription_expires_at TIMESTAMP,
  
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE orders (
  id SERIAL PRIMARY KEY,
  client_id INT NOT NULL REFERENCES users(id),
  title VARCHAR(255) NOT NULL,
  description TEXT NOT NULL,
  category VARCHAR(50),
  budget DECIMAL(10,2),
  
  -- Уровень опыта фрилансера
  required_level VARCHAR(20), -- 'beginner', 'intermediate', 'expert'
  
  status VARCHAR(20) DEFAULT 'open', -- 'open', 'in_progress', 'completed', 'cancelled'
  
  deadline DATE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE applications (
  id SERIAL PRIMARY KEY,
  order_id INT NOT NULL REFERENCES orders(id),
  freelancer_id INT NOT NULL REFERENCES users(id),
  
  cover_letter TEXT,
  proposed_price DECIMAL(10,2),
  
  status VARCHAR(20) DEFAULT 'pending', -- 'pending', 'accepted', 'rejected'
  
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  UNIQUE(order_id, freelancer_id)
);

CREATE TABLE chats (
  id SERIAL PRIMARY KEY,
  order_id INT NOT NULL REFERENCES orders(id),
  user1_id INT NOT NULL REFERENCES users(id),
  user2_id INT NOT NULL REFERENCES users(id),
  
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE messages (
  id SERIAL PRIMARY KEY,
  chat_id INT NOT NULL REFERENCES chats(id),
  sender_id INT NOT NULL REFERENCES users(id),
  content TEXT NOT NULL,
  
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE reviews (
  id SERIAL PRIMARY KEY,
  order_id INT NOT NULL REFERENCES orders(id),
  reviewer_id INT NOT NULL REFERENCES users(id),
  reviewee_id INT NOT NULL REFERENCES users(id),
  
  rating INT CHECK (rating >= 1 AND rating <= 5),
  comment TEXT,
  
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE subscriptions (
  id SERIAL PRIMARY KEY,
  user_id INT NOT NULL REFERENCES users(id),
  plan_type VARCHAR(20), -- 'premium', 'pro'
  price DECIMAL(10,2),
  duration_days INT,
  
  yandex_payment_id VARCHAR(255),
  status VARCHAR(20), -- 'pending', 'paid', 'cancelled'
  
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  expires_at TIMESTAMP
);

-- Индексы для быстрого поиска
CREATE INDEX idx_users_type ON users(user_type);
CREATE INDEX idx_orders_client ON orders(client_id);
CREATE INDEX idx_orders_status ON orders(status);
CREATE INDEX idx_applications_order ON applications(order_id);
CREATE INDEX idx_messages_chat ON messages(chat_id);
