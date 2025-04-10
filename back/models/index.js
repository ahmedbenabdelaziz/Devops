import sequelize from '../config/database.js';
import Employee from './Employee.js';
import Overtime from './Overtime.js';
import Rate from './Rate.js';

// Defining relationships
Employee.hasMany(Overtime, { foreignKey: 'employeeId' });
Overtime.belongsTo(Employee, { foreignKey: 'employeeId' });

export { Employee, Overtime, Rate, sequelize };
