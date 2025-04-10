import express from 'express';
import request from 'supertest';
import { sequelize } from '../models';
import employeeRoutes from '../routes/employee';

const app = express();
app.use(express.json());
app.use('/api/employees', employeeRoutes);

beforeAll(async () => {
  await sequelize.sync({ force: true });
});

describe('Employee API Tests', () => {
  it('should retrieve all employees', async () => {
    const response = await request(app).get('/api/employees');
    expect(response.status).toBe(200);
    expect(Array.isArray(response.body)).toBe(true);
  });
});

afterAll(async () => {
  await sequelize.close();
});
