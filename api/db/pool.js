const { Pool } = require('pg')
const config = require('../utils/config')

const pool = new Pool({
  user: config.DB_USER,
  host: config.DB_HOST,
  database: config.DB_DATABASE,
  password: config.DB_PASSWORD,
  port: config.DB_PORT,
})
let connection;

const getConnection = async () => {
  try {
    connection = await pool.connect()
    return connection;
  } catch (err) {
    console.log(err.stack)
    throw err;
  }
}

module.exports = { getConnection }