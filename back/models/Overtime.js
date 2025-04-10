import { DataTypes } from 'sequelize';
import sequelize from '../config/database.js';

const Overtime = sequelize.define('Overtime', {
  hours: {
    type: DataTypes.FLOAT,
    allowNull: false
  },
  date: {
    type: DataTypes.DATE,
    allowNull: false
  }
});

export default Overtime;
