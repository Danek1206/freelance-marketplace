const express = require('express');
const { Pool } = require('pg');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const cors = require('cors');
require('dotenv').config();

const app = express();

// Middleware
app.use(cors());
app.use(express.json());

// PostgreSQL Pool (Yandex Cloud)
const pool = new Pool({
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  host: process.env.DB_HOST,
  port: process.env.DB_PORT,
  database: process.env.DB_NAME,
});

// ==================== AUTH ====================
// POST /auth/register
app.post('/auth/register', async (req, res) => {
  try {
    const { email, password, full_name, user_type } = req.body;
    
    // Хеш пароля
    const password_hash = await bcrypt.hash(password, 10);
    
    const result = await pool.query(
      'INSERT INTO users (email, password_hash, full_name, user_type) VALUES ($1, $2, $3, $4) RETURNING id, email',
      [email, password_hash, full_name, user_type]
    );
    
    res.json({ success: true, user: result.rows[0] });
  } catch (err) {
    res.status(400).json({ error: err.message });
  }
});

// POST /auth/login
app.post('/auth/login', async (req, res) => {
  try {
    const { email, password } = req.body;
    
    const result = await pool.query('SELECT * FROM users WHERE email = $1', [email]);
    if (result.rows.length === 0) {
      return res.status(401).json({ error: 'Invalid credentials' });
    }
    
    const user = result.rows[0];
    const valid = await bcrypt.compare(password, user.password_hash);
    
    if (!valid) {
      return res.status(401).json({ error: 'Invalid credentials' });
    }
    
    const token = jwt.sign({ id: user.id }, process.env.JWT_SECRET, { expiresIn: '7d' });
    res.json({ token, user: { id: user.id, email: user.email, full_name: user.full_name } });
  } catch (err) {
    res.status(400).json({ error: err.message });
  }
});

// ==================== ORDERS ====================
// GET /orders (с фильтром)
app.get('/orders', async (req, res) => {
  try {
    const { category, level, budget_min, budget_max } = req.query;
    
    let query = 'SELECT * FROM orders WHERE status = $1';
    let params = ['open'];
    
    if (category) {
      query += ' AND category = $' + (params.length + 1);
      params.push(category);
    }
    if (level) {
      query += ' AND required_level = $' + (params.length + 1);
      params.push(level);
    }
    if (budget_min) {
      query += ' AND budget >= $' + (params.length + 1);
      params.push(budget_min);
    }
    if (budget_max) {
      query += ' AND budget <= $' + (params.length + 1);
      params.push(budget_max);
    }
    
    query += ' ORDER BY created_at DESC LIMIT 50';
    
    const result = await pool.query(query, params);
    res.json(result.rows);
  } catch (err) {
    res.status(400).json({ error: err.message });
  }
});

// GET /orders/:id
app.get('/orders/:id', async (req, res) => {
  try {
    const result = await pool.query('SELECT * FROM orders WHERE id = $1', [req.params.id]);
    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'Order not found' });
    }
    res.json(result.rows[0]);
  } catch (err) {
    res.status(400).json({ error: err.message });
  }
});

// POST /orders (создать заказ) - требует auth
app.post('/orders', async (req, res) => {
  try {
    const { title, description, category, budget, required_level, deadline } = req.body;
    const client_id = req.headers['user-id']; // TODO: из JWT токена
    
    const result = await pool.query(
      'INSERT INTO orders (client_id, title, description, category, budget, required_level, deadline) VALUES ($1, $2, $3, $4, $5, $6, $7) RETURNING *',
      [client_id, title, description, category, budget, required_level, deadline]
    );
    
    res.json(result.rows[0]);
  } catch (err) {
    res.status(400).json({ error: err.message });
  }
});

// ==================== APPLICATIONS ====================
// POST /applications (подать заявку)
app.post('/applications', async (req, res) => {
  try {
    const { order_id, cover_letter, proposed_price } = req.body;
    const freelancer_id = req.headers['user-id']; // TODO: из JWT
    
    const result = await pool.query(
      'INSERT INTO applications (order_id, freelancer_id, cover_letter, proposed_price) VALUES ($1, $2, $3, $4) RETURNING *',
      [order_id, freelancer_id, cover_letter, proposed_price]
    );
    
    res.json(result.rows[0]);
  } catch (err) {
    res.status(400).json({ error: err.message });
  }
});

// GET /orders/:id/applications
app.get('/orders/:id/applications', async (req, res) => {
  try {
    const result = await pool.query(
      'SELECT a.*, u.full_name, u.avatar_url, u.rating FROM applications a JOIN users u ON a.freelancer_id = u.id WHERE a.order_id = $1',
      [req.params.id]
    );
    res.json(result.rows);
  } catch (err) {
    res.status(400).json({ error: err.message });
  }
});

// ==================== USERS ====================
// GET /users/:id
app.get('/users/:id', async (req, res) => {
  try {
    const result = await pool.query('SELECT * FROM users WHERE id = $1', [req.params.id]);
    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'User not found' });
    }
    res.json(result.rows[0]);
  } catch (err) {
    res.status(400).json({ error: err.message });
  }
});

// ==================== HEALTH CHECK ====================
app.get('/health', (req, res) => {
  res.json({ status: 'OK' });
});

// Start server
const PORT = process.env.PORT || 8000;
app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
