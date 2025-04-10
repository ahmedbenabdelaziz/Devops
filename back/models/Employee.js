import { DataTypes } from 'sequelize';
import sequelize from '../config/database.js';

const Employee = sequelize.define('Employee', {
  nom: {
    type: DataTypes.STRING,
    allowNull: false
  },
  prenom: {
    type: DataTypes.STRING,
    allowNull: false
  },
  poste: {
    type: DataTypes.STRING,
    allowNull: false
  }
}, {
  tableName: 'employees'
});

export default Employee;
