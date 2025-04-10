import { DataTypes } from 'sequelize';
import sequelize from '../config/database.js';

const Rate = sequelize.define('Rate', {
  dayType: {
    type: DataTypes.STRING,
    allowNull: false
  },
  rate: {
    type: DataTypes.FLOAT,
    allowNull: false
  }
});

export default Rate;
