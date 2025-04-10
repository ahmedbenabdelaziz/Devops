import cors from 'cors'; // Importer CORS
import express from 'express';
import { sequelize } from './models/index.js';
import employeeRoutes from './routes/employee.js';

const app = express();

// Configurer CORS pour autoriser les connexions de ton frontend Flutter
app.use(cors({
  origin: 'http://10.0.2.2:5000', // C’est l’adresse de ton émulateur Android. Utilise 'http://localhost:5000' si tu es sur un navigateur.
  methods: ['GET', 'POST', 'DELETE'],
}));

app.use(express.json());

app.use('/api/employees', employeeRoutes);

sequelize.sync({ force: false })
  .then(() => {
    console.log('Database synchronized');
    app.listen(5000, '0.0.0.0', () => {
      console.log('Server running at http://localhost:5000');
    });
  })
  .catch(err => {
    console.error('Synchronization error:', err);
    process.exit(1);
  });
