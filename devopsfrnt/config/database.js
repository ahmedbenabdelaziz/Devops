import { Sequelize } from 'sequelize';

const sequelize = new Sequelize({
  database:'db',
  username: process.env.DATABASE_USER,
  password: process.env.DATABASE_PASSWORD,
  host: process.env.DATABASE_HOST, // 'db' au lieu de 'localhost'
  dialect: 'mysql',
  logging: false
});
export default sequelize;
