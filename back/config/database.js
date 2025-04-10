import { Sequelize } from 'sequelize';

const sequelize = new Sequelize({
  database:'db',
  username: 'root',
  password:'',
  host: process.env.DATABASE_HOST, // 'db' au lieu de 'localhost'
  dialect: 'mysql',
  logging: false
});
export default sequelize;
